import Foundation
import SwiftUI
import PDFKit
import UniformTypeIdentifiers

@MainActor
final class ContractAnalyzerViewModel: ObservableObject {
    @Published var contractText: String = ""
    @Published var documentTitle: String = "Manual Contract Entry"
    @Published var flaggedClauses: [FlaggedClause] = []
    @Published var overallRiskScore: Int = 0
    @Published var overallGrade: String = "A"
    @Published var hasAnalyzed: Bool = false
    @Published var isImportingDocument: Bool = false
    @Published var importErrorMessage: String? = nil
    @Published var aiRewriteByClauseID: [String: String] = [:]
    @Published var isGeneratingAIForClauseID: String? = nil
    @Published var copiedToastMessage: String? = nil

    func loadSampleContract() {
        MDEsqHaptics.impactLight()
        documentTitle = "Pacific Northwest Medical System — Physician Agreement.pdf (Sample)"
        contractText = ContractDatabase.sampleHospitalContract
        analyzeContract()
    }

    func clearContract() {
        MDEsqHaptics.selection()
        contractText = ""
        documentTitle = "Manual Contract Entry"
        flaggedClauses = []
        overallRiskScore = 0
        overallGrade = "A"
        hasAnalyzed = false
        aiRewriteByClauseID = [:]
        importErrorMessage = nil
    }

    // MARK: - Native PDF & Document Import (Pillar II)
    func importDocument(from url: URL) {
        importErrorMessage = nil
        let didAccess = url.startAccessingSecurityScopedResource()
        defer {
            if didAccess {
                url.stopAccessingSecurityScopedResource()
            }
        }

        let ext = url.pathExtension.lowercased()
        documentTitle = url.lastPathComponent

        if ext == "pdf" {
            guard let pdf = PDFDocument(url: url), pdf.pageCount > 0 else {
                importErrorMessage = "Unable to read PDF document. Verify the file is not password-encrypted."
                return
            }
            var extractedPages: [String] = []
            for pageIndex in 0..<pdf.pageCount {
                if let page = pdf.page(at: pageIndex),
                   let pageText = page.string?.trimmingCharacters(in: .whitespacesAndNewlines),
                   !pageText.isEmpty {
                    extractedPages.append("[Page \(pageIndex + 1)]\n\(pageText)")
                }
            }
            if extractedPages.isEmpty {
                importErrorMessage = "This PDF appears to be a scanned image without selectable text. Paste text or use Live Text."
                return
            }
            contractText = extractedPages.joined(separator: "\n\n")
            MDEsqHaptics.success()
            analyzeContract()
        } else {
            do {
                let data = try Data(contentsOf: url)
                if let utf8Text = String(data: data, encoding: .utf8), !utf8Text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    contractText = utf8Text
                    MDEsqHaptics.success()
                    analyzeContract()
                } else if let asciiText = String(data: data, encoding: .isoLatin1) {
                    // Fallback extraction for XML/DOCX or RTF streams
                    let cleaned = asciiText.replacingOccurrences(of: "<[^>]+>", with: " ", options: .regularExpression)
                    contractText = cleaned
                    MDEsqHaptics.success()
                    analyzeContract()
                } else {
                    importErrorMessage = "Unsupported text encoding in selected file."
                }
            } catch {
                importErrorMessage = "Failed to load file: \(error.localizedDescription)"
            }
        }
    }

    // MARK: - Real Paragraph & Section Extraction Engine
    func analyzeContract() {
        let trimmed = contractText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            flaggedClauses = []
            overallRiskScore = 0
            overallGrade = "A"
            hasAnalyzed = false
            return
        }

        // Split contract into logical paragraphs while tracking active Section / Page headers
        let rawLines = trimmed.components(separatedBy: .newlines)
        var paragraphs: [(header: String, body: String)] = []
        var currentHeader = "Section 1 / Preamble"
        var currentBuffer: [String] = []

        for rawLine in rawLines {
            let line = rawLine.trimmingCharacters(in: .whitespacesAndNewlines)
            if line.isEmpty {
                let joined = currentBuffer.joined(separator: " ").trimmingCharacters(in: .whitespacesAndNewlines)
                if !joined.isEmpty {
                    paragraphs.append((header: currentHeader, body: joined))
                }
                currentBuffer.removeAll()
                continue
            }
            // Detect Page Marker or Section Heading
            if line.hasPrefix("[Page ") && line.hasSuffix("]") {
                let joined = currentBuffer.joined(separator: " ").trimmingCharacters(in: .whitespacesAndNewlines)
                if !joined.isEmpty {
                    paragraphs.append((header: currentHeader, body: joined))
                }
                currentBuffer.removeAll()
                currentHeader = line.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")
                continue
            }
            if line.range(of: #"^(SECTION|ARTICLE)\s+[0-9IVX]+[:\.\-\s]"#, options: [.regularExpression, .caseInsensitive]) != nil {
                let joined = currentBuffer.joined(separator: " ").trimmingCharacters(in: .whitespacesAndNewlines)
                if !joined.isEmpty {
                    paragraphs.append((header: currentHeader, body: joined))
                }
                currentBuffer.removeAll()
                currentHeader = line
                currentBuffer.append(line)
                continue
            }
            currentBuffer.append(line)
        }

        let finalJoined = currentBuffer.joined(separator: " ").trimmingCharacters(in: .whitespacesAndNewlines)
        if !finalJoined.isEmpty {
            paragraphs.append((header: currentHeader, body: finalJoined))
        }
        currentBuffer.removeAll()

        if paragraphs.isEmpty {
            paragraphs = [(header: "Uploaded Document", body: trimmed)]
        }

        var detected: [FlaggedClause] = []
        var accumulatedRisk = 0

        for rule in ContractDatabase.clauseRules {
            var bestParagraph: (header: String, body: String)? = nil
            var bestHitTokens: [String] = []

            for para in paragraphs {
                let lowerPara = para.body.lowercased()
                let hits = rule.triggerKeywords.filter { lowerPara.contains($0.lowercased()) }
                if hits.count > bestHitTokens.count {
                    bestHitTokens = hits
                    bestParagraph = para
                }
            }

            if let matchPara = bestParagraph, !bestHitTokens.isEmpty {
                let excerpt = extractFocusedExcerpt(from: matchPara.body, matching: bestHitTokens.first ?? "")
                detected.append(
                    FlaggedClause(
                        id: rule.id,
                        title: rule.title,
                        category: rule.category,
                        severity: rule.severity,
                        riskPoints: rule.riskPoints,
                        statutoryCitation: rule.statutoryCitation,
                        sectionOrPageLabel: matchPara.header,
                        matchedTriggerTokens: bestHitTokens,
                        actualMatchedExcerpt: excerpt,
                        legalAnalysis: rule.legalAnalysis,
                        recommendedRedline: rule.recommendedRedline,
                        negotiationScript: rule.negotiationScript
                    )
                )
                accumulatedRisk += rule.riskPoints
            }
        }

        flaggedClauses = detected.sorted { $0.riskPoints > $1.riskPoints }
        overallRiskScore = min(100, accumulatedRisk)
        overallGrade = Self.computeLetterGrade(for: overallRiskScore)
        hasAnalyzed = true
    }

    private func extractFocusedExcerpt(from paragraph: String, matching keyword: String) -> String {
        guard paragraph.count > 440 else { return paragraph }
        let lower = paragraph.lowercased()
        if let range = lower.range(of: keyword.lowercased()) {
            let centerIndex = paragraph.distance(from: paragraph.startIndex, to: range.lowerBound)
            let startOffset = max(0, centerIndex - 160)
            let endOffset = min(paragraph.count, centerIndex + 260)
            let startIdx = paragraph.index(paragraph.startIndex, offsetBy: startOffset)
            let endIdx = paragraph.index(paragraph.startIndex, offsetBy: endOffset)
            let prefix = startOffset > 0 ? "… " : ""
            let suffix = endOffset < paragraph.count ? " …" : ""
            return prefix + String(paragraph[startIdx..<endIdx]) + suffix
        }
        return String(paragraph.prefix(420)) + " …"
    }

    static func computeLetterGrade(for score: Int) -> String {
        switch score {
        case 0...14: return "A"
        case 15...29: return "B"
        case 30...49: return "C"
        case 50...69: return "D"
        default: return "F"
        }
    }

    // MARK: - Live AI Custom Clause Rewrite (Cloudflare Worker Gemini 3.8 Flash)
    func requestAICustomRedline(for clause: FlaggedClause) async {
        MDEsqHaptics.impactLight()
        isGeneratingAIForClauseID = clause.id
        defer { isGeneratingAIForClauseID = nil }

        let prompt = """
        Draft a surgical, legally enforceable physician defense replacement clause and a 2-sentence verbal CMO negotiation script for the following hospital employment agreement provision:
        
        Clause Category: \(clause.title) (\(clause.statutoryCitation))
        Actual Contract Language Extracted: "\(clause.actualMatchedExcerpt)"
        
        Provide:
        1. CUSTOM REPLACEMENT REDLINE CLAUSE (ready to paste into Word Track Changes)
        2. EXECUTIVE NEGOTIATION LEVERAGE POINT (citing \(clause.statutoryCitation))
        """

        let response = await MDEsqEdgeAIClient.shared.askCopilot(
            prompt: prompt,
            systemContext: "Module: Employment Contract Redline Auditor. Jurisdiction: Washington State (RCW 49.62, RCW 7.70) & Federal Stark/AKS."
        )
        aiRewriteByClauseID[clause.id] = response
        MDEsqHaptics.success()
    }

    // MARK: - Exportable Attorney-Ready Redline Memorandum
    func generateRedlineMemorandum() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        let dateStr = dateFormatter.string(from: Date())

        var lines: [String] = []
        lines.append("====================================================================")
        lines.append("MD ESQ. — EXECUTIVE PHYSICIAN CONTRACT REDLINE MEMORANDUM")
        lines.append("====================================================================")
        lines.append("Document Audited: \(documentTitle)")
        lines.append("Audit Date: \(dateStr)")
        lines.append("Contract Risk Score: \(overallRiskScore)/100 (Executive Grade: \(overallGrade))")
        lines.append("Flagged Predatory / High-Risk Provisions: \(flaggedClauses.count)")
        lines.append("====================================================================\n")

        if flaggedClauses.isEmpty {
            lines.append("No high-risk predatory triggers detected across standard 7-point statutory audit.")
        } else {
            for (idx, clause) in flaggedClauses.enumerated() {
                lines.append("[\(idx + 1)] \(clause.title.uppercased()) — [\(clause.severity.rawValue.uppercased())]")
                lines.append("Location: \(clause.sectionOrPageLabel)")
                lines.append("Statutory Authority: \(clause.statutoryCitation)")
                lines.append("")
                lines.append("CURRENT CONTRACT LANGUAGE (STRIKE):")
                lines.append("\"\(clause.actualMatchedExcerpt)\"")
                lines.append("")
                lines.append("LEGAL & FINANCIAL EXPOSURE:")
                lines.append(clause.legalAnalysis)
                lines.append("")
                lines.append("PROPOSED PHYSICIAN-PROTECTIVE REDLINE (INSERT):")
                if let customAI = aiRewriteByClauseID[clause.id] {
                    lines.append(customAI)
                } else {
                    lines.append("\"\(clause.recommendedRedline)\"")
                }
                lines.append("")
                lines.append("VERBAL NEGOTIATION SCRIPT:")
                lines.append(clause.negotiationScript)
                lines.append("--------------------------------------------------------------------\n")
            }
        }

        lines.append("Prepared via MD Esq. — Physician Medicolegal & Contract Defense Suite")
        lines.append("© 2026 A. Alex Mohit. Informational legal intelligence; confirm final execution with retained counsel.")
        return lines.joined(separator: "\n")
    }

    func showToast(_ text: String) {
        copiedToastMessage = text
        Task {
            try? await Task.sleep(nanoseconds: 2_200_000_000)
            if copiedToastMessage == text {
                copiedToastMessage = nil
            }
        }
    }
}
