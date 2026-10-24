import SwiftUI
import UniformTypeIdentifiers
import StoreKit

struct ContractAnalyzerView: View {
    @StateObject private var viewModel = ContractAnalyzerViewModel()
    @Environment(\.requestReview) private var requestReview
    @AppStorage("mdesq_milestone_audits_count") private var completedAuditsCount: Int = 0
    @State private var showFileImporter = false
    @State private var showFullTextEditor = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                MDEsqTheme.obsidian.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        executiveHeaderBanner
                        documentIntakeCard
                        if viewModel.hasAnalyzed {
                            executiveScoreboardCard
                            flaggedClausesSection
                        } else {
                            emptyStateBriefingCard
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    .padding(.bottom, 40)
                }

                if let toast = viewModel.copiedToastMessage {
                    toastBanner(message: toast)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .padding(.bottom, 16)
                }
            }
            .navigationTitle("Contract Redline Auditor")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if viewModel.hasAnalyzed {
                        ShareLink(
                            item: viewModel.generateRedlineMemorandum(),
                            subject: Text("MD Esq. Contract Redline Memorandum — \(viewModel.documentTitle)"),
                            message: Text("Attached is the statutory physician contract audit and proposed redline replacements.")
                        ) {
                            HStack(spacing: 4) {
                                Image(systemName: "square.and.arrow.up")
                                Text("Export Memo")
                                    .font(.caption.weight(.semibold))
                            }
                            .foregroundStyle(MDEsqTheme.gold)
                        }
                    }
                }
            }
            .fileImporter(
                isPresented: $showFileImporter,
                allowedContentTypes: [.pdf, .plainText, .rtf, .data],
                allowsMultipleSelection: false
            ) { result in
                switch result {
                case .success(let urls):
                    if let first = urls.first {
                        viewModel.importDocument(from: first)
                        triggerMilestoneReviewIfAppropriate()
                    }
                case .failure(let error):
                    viewModel.importErrorMessage = error.localizedDescription
                }
            }
        }
    }

    private func triggerMilestoneReviewIfAppropriate() {
        completedAuditsCount += 1
        if completedAuditsCount == 2 || completedAuditsCount == 6 {
            requestReview()
        }
    }

    // MARK: - Subviews
    private var executiveHeaderBanner: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Label("STATUTORY REDLINE ENGINE • RCW 49.62 & STARK", systemImage: "signature")
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .foregroundStyle(MDEsqTheme.gold)
                Spacer()
                Text("PDFKit + AI Edge")
                    .font(.system(size: 10, weight: .semibold, design: .monospaced))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(MDEsqTheme.gold.opacity(0.15))
                    .foregroundStyle(MDEsqTheme.goldLight)
                    .clipShape(Capsule())
            }
            Text("Physician Employment & Call Agreement Auditor")
                .font(.system(size: 22, weight: .bold, design: .serif))
                .foregroundStyle(MDEsqTheme.ivory)
            Text("Import any hospital employment PDF or paste contract clauses to extract predatory provisions, compute statutory risk, and generate Track-Changes replacement redlines.")
                .font(.subheadline)
                .foregroundStyle(MDEsqTheme.slateMuted)
        }
        .padding(16)
        .background(MDEsqTheme.navyCard)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(MDEsqTheme.borderSubtle, lineWidth: 1)
        )
    }

    private var documentIntakeCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Image(systemName: "doc.viewfinder.fill")
                    .foregroundStyle(MDEsqTheme.gold)
                VStack(alignment: .leading, spacing: 2) {
                    Text("ACTIVE DOCUMENT FOLIO")
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .foregroundStyle(MDEsqTheme.slateMuted)
                    Text(viewModel.documentTitle)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(MDEsqTheme.ivory)
                        .lineLimit(1)
                }
                Spacer()
                if !viewModel.contractText.isEmpty {
                    Button {
                        viewModel.clearContract()
                    } label: {
                        Text("Clear")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(MDEsqTheme.crimson)
                    }
                }
            }

            // Primary Action Row: Import PDF / Load Sample
            HStack(spacing: 10) {
                Button {
                    MDEsqHaptics.impactLight()
                    showFileImporter = true
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "doc.badge.plus")
                        Text("Import PDF / Doc")
                            .font(.footnote.weight(.bold))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(MDEsqTheme.gold)
                    .foregroundStyle(MDEsqTheme.obsidian)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }

                Button {
                    viewModel.loadSampleContract()
                    triggerMilestoneReviewIfAppropriate()
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "building.columns.fill")
                        Text("Load 8-Clause Sample")
                            .font(.footnote.weight(.semibold))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(MDEsqTheme.navyElevated)
                    .foregroundStyle(MDEsqTheme.goldLight)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(MDEsqTheme.gold.opacity(0.45), lineWidth: 1)
                    )
                }
            }

            if let errorMsg = viewModel.importErrorMessage {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(MDEsqTheme.amber)
                    Text(errorMsg)
                        .font(.caption)
                        .foregroundStyle(MDEsqTheme.amber)
                }
                .padding(10)
                .background(MDEsqTheme.amber.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }

            DisclosureGroup(isExpanded: $showFullTextEditor) {
                VStack(alignment: .leading, spacing: 10) {
                    TextEditor(text: $viewModel.contractText)
                        .font(.system(size: 13, design: .serif))
                        .scrollContentBackground(.hidden)
                        .foregroundStyle(MDEsqTheme.parchment)
                        .frame(minHeight: 150, maxHeight: 240)
                        .padding(10)
                        .background(MDEsqTheme.obsidian.opacity(0.85))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(MDEsqTheme.borderSubtle, lineWidth: 1)
                        )

                    HStack(spacing: 10) {
                        Button {
                            if let clip = UIPasteboard.general.string, !clip.isEmpty {
                                viewModel.documentTitle = "Clipboard Contract Excerpt"
                                viewModel.contractText = clip
                                viewModel.analyzeContract()
                                triggerMilestoneReviewIfAppropriate()
                            }
                        } label: {
                            Label("Paste Clipboard", systemImage: "doc.on.clipboard")
                                .font(.caption.weight(.semibold))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(MDEsqTheme.navyElevated)
                                .foregroundStyle(MDEsqTheme.ivory)
                                .clipShape(Capsule())
                        }

                        Spacer()

                        Button {
                            MDEsqHaptics.impactMedium()
                            viewModel.analyzeContract()
                            triggerMilestoneReviewIfAppropriate()
                        } label: {
                            Label("Run Statutory Audit", systemImage: "bolt.shield.fill")
                                .font(.caption.weight(.bold))
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(MDEsqTheme.gold)
                                .foregroundStyle(MDEsqTheme.obsidian)
                                .clipShape(Capsule())
                        }
                    }
                }
                .padding(.top, 8)
            } label: {
                HStack {
                    Text(viewModel.contractText.isEmpty ? "Or Paste / Edit Contract Text Manually" : "Inspect Extracted Contract Text (\(viewModel.contractText.count) chars)")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(MDEsqTheme.slateMuted)
                }
            }
            .tint(MDEsqTheme.gold)
        }
        .padding(16)
        .background(MDEsqTheme.navyCard)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(MDEsqTheme.borderSubtle, lineWidth: 1)
        )
    }

    private var executiveScoreboardCard: some View {
        let gradeColor: Color = {
            switch viewModel.overallGrade {
            case "A", "B": return MDEsqTheme.emerald
            case "C": return MDEsqTheme.amber
            default: return MDEsqTheme.crimson
            }
        }()

        return VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .stroke(gradeColor.opacity(0.2), lineWidth: 6)
                        .frame(width: 68, height: 68)
                    Circle()
                        .trim(from: 0, to: CGFloat(max(8, viewModel.overallRiskScore)) / 100.0)
                        .stroke(gradeColor, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .frame(width: 68, height: 68)
                    VStack(spacing: 0) {
                        Text(viewModel.overallGrade)
                            .font(.system(size: 26, weight: .black, design: .serif))
                            .foregroundStyle(gradeColor)
                        Text("\(viewModel.overallRiskScore) PTS")
                            .font(.system(size: 9, weight: .bold, design: .monospaced))
                            .foregroundStyle(MDEsqTheme.slateMuted)
                        .contentTransition(.numericText())
                    }
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("EXECUTIVE RISK ASSESSMENT")
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .foregroundStyle(MDEsqTheme.gold)
                    Text(viewModel.flaggedClauses.isEmpty ? "Clean Physician-Favorable Folio" : "\(viewModel.flaggedClauses.count) Predatory Clauses Flagged for Redline")
                        .font(.headline)
                        .foregroundStyle(MDEsqTheme.ivory)
                    Text("Audited against RCW 49.62.020 (2026 WA $136,593.19 threshold), 42 U.S.C. § 1395nn, and WA medical malpractice tail & indemnification standards.")
                        .font(.caption)
                        .foregroundStyle(MDEsqTheme.slateMuted)
                }
            }

            Divider().overlay(MDEsqTheme.borderSubtle)

            HStack(spacing: 10) {
                Button {
                    UIPasteboard.general.string = viewModel.generateRedlineMemorandum()
                    MDEsqHaptics.success()
                    viewModel.showToast("Full Redline Memorandum copied to clipboard")
                } label: {
                    Label("Copy Complete Redline Memo", systemImage: "doc.on.doc.fill")
                        .font(.caption.weight(.bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(MDEsqTheme.navyElevated)
                        .foregroundStyle(MDEsqTheme.goldLight)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }

                ShareLink(
                    item: viewModel.generateRedlineMemorandum(),
                    subject: Text("MD Esq. Redline Audit — \(viewModel.documentTitle)")
                ) {
                    Label("Share Attorney Brief", systemImage: "paperplane.fill")
                        .font(.caption.weight(.bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(MDEsqTheme.gold.opacity(0.18))
                        .foregroundStyle(MDEsqTheme.gold)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
        .padding(16)
        .background(MDEsqTheme.navyCard)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(gradeColor.opacity(0.45), lineWidth: 1)
        )
    }

    private var flaggedClausesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(viewModel.flaggedClauses) { clause in
                ClauseRedlineCard(
                    clause: clause,
                    customAIRewrite: viewModel.aiRewriteByClauseID[clause.id],
                    isGeneratingAI: viewModel.isGeneratingAIForClauseID == clause.id,
                    onCopyRedline: { text in
                        UIPasteboard.general.string = text
                        MDEsqHaptics.success()
                        viewModel.showToast("Copied Redline for \(clause.category)")
                    },
                    onRequestAIRewrite: {
                        Task {
                            await viewModel.requestAICustomRedline(for: clause)
                        }
                    }
                )
            }
        }
    }

    private var emptyStateBriefingCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("7-POINT STATUTORY AUDIT COVERAGE", systemImage: "checklist.checked")
                .font(.system(size: 11, weight: .bold, design: .monospaced))
                .foregroundStyle(MDEsqTheme.gold)

            ForEach(ContractDatabase.clauseRules) { rule in
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "shield.lefthalf.filled")
                        .font(.caption)
                        .foregroundStyle(MDEsqTheme.gold)
                        .padding(.top, 2)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(rule.title)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(MDEsqTheme.ivory)
                        Text(rule.statutoryCitation)
                            .font(.system(size: 11, design: .monospaced))
                            .foregroundStyle(MDEsqTheme.slateMuted)
                    }
                }
            }
        }
        .padding(16)
        .background(MDEsqTheme.navyCard)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(MDEsqTheme.borderSubtle, lineWidth: 1)
        )
    }

    private func toastBanner(message: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark.seal.fill")
                .foregroundStyle(MDEsqTheme.obsidian)
            Text(message)
                .font(.caption.weight(.bold))
                .foregroundStyle(MDEsqTheme.obsidian)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(MDEsqTheme.gold)
        .clipShape(Capsule())
        .shadow(color: .black.opacity(0.4), radius: 8, y: 4)
    }
}

// MARK: - Editorial Legal Folio Redline Diff Card
private struct ClauseRedlineCard: View {
    let clause: FlaggedClause
    let customAIRewrite: String?
    let isGeneratingAI: Bool
    let onCopyRedline: (String) -> Void
    let onRequestAIRewrite: () -> Void

    private var severityColor: Color {
        switch clause.severity {
        case .critical: return MDEsqTheme.crimson
        case .high: return MDEsqTheme.amber
        case .moderate: return MDEsqTheme.gold
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Top Meta Row
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text(clause.severity.rawValue.uppercased())
                            .font(.system(size: 10, weight: .bold, design: .monospaced))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(severityColor.opacity(0.18))
                            .foregroundStyle(severityColor)
                            .clipShape(Capsule())

                        Text(clause.sectionOrPageLabel)
                            .font(.system(size: 10, weight: .semibold, design: .monospaced))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(MDEsqTheme.navyElevated)
                            .foregroundStyle(MDEsqTheme.parchment)
                            .clipShape(Capsule())
                    }
                    Text(clause.title)
                        .font(.system(size: 18, weight: .bold, design: .serif))
                        .foregroundStyle(MDEsqTheme.ivory)
                    Text(clause.statutoryCitation)
                        .font(.system(size: 11, weight: .medium, design: .monospaced))
                        .foregroundStyle(MDEsqTheme.gold)
                }
                Spacer()
                Text("+\(clause.riskPoints) RISK")
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .foregroundStyle(severityColor)
            }

            // 1. EXTRACTED ACTUAL CONTRACT EXCERPT (CRIMSON STRIKE FOLIO)
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Image(systemName: "minus.circle.fill")
                        .foregroundStyle(MDEsqTheme.crimson)
                    Text("EXTRACTED FROM YOUR DOCUMENT (STRIKE):")
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .foregroundStyle(MDEsqTheme.crimson)
                }
                Text("“\(clause.actualMatchedExcerpt)”")
                    .font(.system(size: 13.5, design: .serif))
                    .italic()
                    .foregroundStyle(MDEsqTheme.parchment.opacity(0.9))
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(MDEsqTheme.crimson.opacity(0.09))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(MDEsqTheme.crimson.opacity(0.35), lineWidth: 1)
                    )
            }

            // 2. STATUTORY EXPOSURE ANALYSIS
            VStack(alignment: .leading, spacing: 4) {
                Text("STATUTORY & FINANCIAL EXPOSURE")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundStyle(MDEsqTheme.slateMuted)
                Text(clause.legalAnalysis)
                    .font(.footnote)
                    .foregroundStyle(MDEsqTheme.ivory.opacity(0.92))
            }

            // 3. RECOMMENDED REDLINE REPLACEMENT (EMERALD FOLIO)
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .foregroundStyle(MDEsqTheme.emerald)
                    Text("PROTECTIVE REDLINE REPLACEMENT (INSERT):")
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .foregroundStyle(MDEsqTheme.emerald)
                    Spacer()
                    Button {
                        onCopyRedline(customAIRewrite ?? clause.recommendedRedline)
                    } label: {
                        Label("Copy Redline", systemImage: "doc.on.doc")
                            .font(.system(size: 11, weight: .bold))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(MDEsqTheme.emerald.opacity(0.2))
                            .foregroundStyle(MDEsqTheme.emerald)
                            .clipShape(Capsule())
                    }
                }

                Text("“\(clause.recommendedRedline)”")
                    .font(.system(size: 14, weight: .medium, design: .serif))
                    .foregroundStyle(MDEsqTheme.ivory)
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(MDEsqTheme.emerald.opacity(0.09))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(MDEsqTheme.emerald.opacity(0.4), lineWidth: 1)
                    )
            }

            // 4. VERBAL CMO / HOSPITAL COUNSEL NEGOTIATION SCRIPT
            VStack(alignment: .leading, spacing: 4) {
                Text("EXECUTIVE VERBAL NEGOTIATION SCRIPT")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundStyle(MDEsqTheme.gold)
                Text(clause.negotiationScript)
                    .font(.system(size: 12.5, design: .serif))
                    .foregroundStyle(MDEsqTheme.parchment)
            }
            .padding(10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(MDEsqTheme.navyElevated)
            .clipShape(RoundedRectangle(cornerRadius: 10))

            // 5. LIVE AI CUSTOM REWRITE FOR SPECIFIC EXTRACTED LANGUAGE
            if let customAI = customAIRewrite {
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Label("AI EDGE BESPOKE RIDER FOR THIS EXACT CLAUSE", systemImage: "sparkles")
                            .font(.system(size: 10, weight: .bold, design: .monospaced))
                            .foregroundStyle(MDEsqTheme.goldLight)
                        Spacer()
                        Button {
                            onCopyRedline(customAI)
                        } label: {
                            Text("Copy AI Rider")
                                .font(.caption2.weight(.bold))
                                .foregroundStyle(MDEsqTheme.gold)
                        }
                    }
                    Text(customAI)
                        .font(.system(size: 13, design: .serif))
                        .foregroundStyle(MDEsqTheme.ivory)
                }
                .padding(12)
                .background(MDEsqTheme.gold.opacity(0.10))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(MDEsqTheme.gold.opacity(0.4), lineWidth: 1)
                )
            } else {
                Button {
                    onRequestAIRewrite()
                } label: {
                    HStack(spacing: 6) {
                        if isGeneratingAI {
                            ProgressView()
                                .tint(MDEsqTheme.gold)
                                .scaleEffect(0.8)
                            Text("Synthesizing Custom Rider via Edge AI…")
                                .font(.caption.weight(.semibold))
                        } else {
                            Image(systemName: "sparkles")
                            Text("Generate Custom AI Rider Tailored to This Exact Excerpt")
                                .font(.caption.weight(.semibold))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 9)
                    .background(MDEsqTheme.navyElevated)
                    .foregroundStyle(MDEsqTheme.goldLight)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .disabled(isGeneratingAI)
            }
        }
        .padding(16)
        .background(MDEsqTheme.navyCard)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(MDEsqTheme.borderSubtle, lineWidth: 1)
        )
    }
}
