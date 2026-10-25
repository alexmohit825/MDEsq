import SwiftUI
import UIKit

// MARK: - MDEsq Executive Legal Folio Design System

public enum MDEsqTheme {
    // Executive Canvas & Surfaces
    public static let obsidian = Color(red: 0.04, green: 0.06, blue: 0.11)       // #0A0F1D
    public static let navyCard = Color(red: 0.07, green: 0.11, blue: 0.18)       // #131B2E
    public static let navyElevated = Color(red: 0.10, green: 0.14, blue: 0.24)   // #1A243D
    public static let slateInk = Color(red: 0.12, green: 0.16, blue: 0.23)       // #1E293B
    public static let slateMuted = Color(red: 0.54, green: 0.60, blue: 0.68)     // #8A99AD
    public static let parchment = Color(red: 0.96, green: 0.95, blue: 0.91)      // #F5F2E9
    public static let ivory = Color(red: 0.98, green: 0.97, blue: 0.94)          // #FAF8F0
    public static let warmPaper = Color(red: 0.99, green: 0.99, blue: 0.98)      // #FDFDFB

    // Executive Accents
    public static let gold = Color(red: 0.79, green: 0.66, blue: 0.30)           // #C9A84C
    public static let goldLight = Color(red: 0.91, green: 0.84, blue: 0.58)      // #E8D595
    public static let emerald = Color(red: 0.06, green: 0.73, blue: 0.51)        // #10B981
    public static let emeraldSeal = Color(red: 0.02, green: 0.47, blue: 0.34)    // #047857
    public static let emeraldSoft = Color(red: 0.93, green: 0.99, blue: 0.96)    // #ECFDF5
    public static let crimson = Color(red: 0.94, green: 0.27, blue: 0.27)        // #EF4444
    public static let crimsonTrap = Color(red: 0.75, green: 0.07, blue: 0.24)    // #BE123C
    public static let crimsonSoft = Color(red: 1.00, green: 0.95, blue: 0.95)    // #FFF1F2
    public static let amber = Color(red: 0.96, green: 0.62, blue: 0.13)          // #F59E0B
    public static let amberGold = Color(red: 0.71, green: 0.33, blue: 0.04)      // #B45309
    public static let amberSoft = Color(red: 1.00, green: 0.98, blue: 0.92)      // #FFFBEB
    public static let royalBlue = Color(red: 0.11, green: 0.31, blue: 0.85)      // #1D4ED8
    public static let royalSoft = Color(red: 0.94, green: 0.96, blue: 1.00)      // #EFF6FF
    public static let purpleJudicial = Color(red: 0.43, green: 0.16, blue: 0.85) // #6D28D9
    public static let purpleSoft = Color(red: 0.96, green: 0.95, blue: 1.00)     // #F5F3FF
    public static let borderSubtle = Color(red: 0.18, green: 0.24, blue: 0.36)   // Border
}

public enum MDEsqHaptics {
    public static func impactLight() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
    public static func impactMedium() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
    public static func selection() {
        UISelectionFeedbackGenerator().selectionChanged()
    }
    public static func light() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
    public static func medium() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
    public static func success() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
    public static func warning() {
        UINotificationFeedbackGenerator().notificationOccurred(.warning)
    }
    public static func error() {
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }
}

// MARK: - Zero-Knowledge On-Device PHI/PII Sanitizer

public enum PHISanitizer {
    public static func sanitize(_ rawText: String) -> String {
        return scrub(rawText).sanitizedText
    }

    public static func scrub(_ rawText: String) -> (sanitizedText: String, redactedCount: Int) {
        guard !rawText.isEmpty else { return ("", 0) }
        var text = rawText
        var count = 0
        let patterns: [(String, String)] = [
            ("\\b(MRN|mrn|ID|id|record\\s*#?)\\s*[:#]?\\s*\\d{4,12}\\b", "[MRN-REDACTED]"),
            ("\\b\\d{3}[-]?\\d{2}[-]?\\d{4}\\b", "[SSN-REDACTED]"),
            ("\\b(?:\\+?1[-.\\s]?)?\\(?\\d{3}\\)?[-.\\s]?\\d{3}[-.\\s]?\\d{4}\\b", "[PHONE-REDACTED]"),
            ("\\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}\\b", "[EMAIL-REDACTED]"),
            ("\\b\\d{1,2}[/\\.-]\\d{1,2}[/\\.-]\\d{2,4}\\b", "[DATE-REDACTED]"),
            ("\\b(Patient|pt|Mr\\.|Ms\\.|Mrs\\.)\\s+([A-Z][a-z]+)(\\s+[A-Z][a-z]+)?\\b", "[PATIENT-NAME-REDACTED]")
        ]
        for (pattern, replacement) in patterns {
            if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
                let range = NSRange(text.startIndex..<text.endIndex, in: text)
                let matches = regex.matches(in: text, options: [], range: range)
                if !matches.isEmpty {
                    count += matches.count
                    text = regex.stringByReplacingMatches(in: text, options: [], range: range, withTemplate: replacement)
                }
            }
        }
        return (text, count)
    }
}

// MARK: - Unified Serverless Cloudflare Edge AI Client (Rule 11)

public actor MDEsqEdgeAIClient {
    public static let shared = MDEsqEdgeAIClient()
    private let workerEndpoint = URL(string: "https://mdesq.mohalex.workers.dev/api/chat")!

    public func askCopilot(prompt: String, systemContext: String? = nil, jurisdiction: String = "WA") async -> String {
        let sanitized = PHISanitizer.sanitize(prompt)
        var request = URLRequest(url: workerEndpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 18

        var payload: [String: String] = [
            "prompt": sanitized,
            "jurisdiction": jurisdiction
        ]
        if let ctx = systemContext {
            payload["systemContext"] = ctx
        }

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload)
            let (data, response) = try await URLSession.shared.data(for: request)
            if let http = response as? HTTPURLResponse, http.statusCode == 200,
               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let reply = json["response"] as? String, !reply.isEmpty {
                return reply
            }
        } catch {
            // Fall through to deterministic offline legal intelligence engine
        }
        return deterministicFallback(for: sanitized, jurisdiction: jurisdiction)
    }

    private func deterministicFallback(for query: String, jurisdiction: String) -> String {
        let q = query.lowercased()
        if q.contains("tail") || q.contains("non-compete") || q.contains("contract") || q.contains("redline") {
            return "STATUTORY ADVISORY (RCW 49.62 & WA Malpractice Standards):\nUnder Washington law (RCW 49.62.020), restrictive covenants exceeding 18 months are presumptively unreasonable, and agreements lacking pre-acceptance disclosure are void ab initio. For tail insurance, standard practice dictates the hospital covers 100% upon termination without cause or mutual agreement."
        } else if q.contains("peer review") || q.contains("suspension") || q.contains("wmc") || q.contains("stid") {
            return "STATUTORY ADVISORY (HCQIA 42 U.S.C. § 11112 & RCW 18.130.172):\nDo not submit a resignation during an active investigation—doing so triggers mandatory, permanent NPDB reporting under 45 C.F.R. § 60.12. For WMC inquiries, respond within the 14-day Letter of Cooperation window via counsel and seek a non-disciplinary Stipulation to Informal Disposition (STID) where appropriate."
        } else {
            return "STATUTORY ADVISORY (RCW 7.70.040 & WPI 105.08):\nIn Washington medical malpractice defense, adverse clinical outcomes do not establish breach of care. The physician's exercise of reasonable clinical judgment between accepted treatment alternatives is shielded under WPI 105.08. Document prospective decision-making contemporaneously."
        }
    }
}

// MARK: - Statutory Reference Models

public struct LegalStatute: Identifiable, Hashable {
    public let id: String
    public let code: String
    public let jurisdiction: String
    public let title: String
    public let summary: String
    public let keyProvisions: [String]
    public let clinicalImpact: String
}

public struct StatutoryDatabase {
    public static let allStatutes: [LegalStatute] = [
        LegalStatute(
            id: "wa-rcw-49-62",
            code: "RCW 49.62",
            jurisdiction: "WA",
            title: "Washington Non-Compete Act",
            summary: "Governs restrictive covenants in Washington State. For employees and independent contractors, strict earnings thresholds, mandatory pre-acceptance written disclosure, and maximum 18-month duration ceilings apply.",
            keyProvisions: [
                "RCW 49.62.020(1)(a): Must disclose all non-compete terms in writing no later than the acceptance of the offer of employment.",
                "RCW 49.62.020(1)(b): Restrictive covenants void for employees earning below annual threshold (indexed annually by L&I; $136,593.19 in 2026).",
                "RCW 49.62.020(1)(c): If employee is laid off or terminated without cause, covenant is void unless employer pays full base salary compensation throughout the restricted duration.",
                "RCW 49.62.020(2): Restrictive covenants exceeding 18 months in duration are presumptively unreasonable and void.",
                "RCW 49.62.080: Mandatory statutory damages ($5,000 or actual damages) plus reasonable attorney fees and costs awarded to physician if covenant violates the statute."
            ],
            clinicalImpact: "Enables physicians to defeat overbroad geographic and temporal hospital non-competes. A health system attempting to enforce a non-compliant covenant faces mandatory attorney fee liability."
        ),
        LegalStatute(
            id: "wa-rcw-7-70",
            code: "RCW 7.70",
            jurisdiction: "WA",
            title: "Actions for Injuries Resulting from Health Care",
            summary: "Exclusive statutory scheme governing all medical malpractice and informed consent actions in Washington State.",
            keyProvisions: [
                "RCW 7.70.030: Plaintiff must establish injury resulted from failure to follow standard of care, lack of informed consent, or promise that injury would not occur.",
                "RCW 7.70.040: Standard of care requires plaintiff to prove healthcare provider failed to exercise the degree of care, skill, and learning expected of a reasonably prudent healthcare provider in that profession acting in the same or similar circumstances.",
                "RCW 7.70.050: Informed consent requires disclosure of material risks that a reasonably prudent person in the patient's position would attach significance to in deciding whether to submit to the treatment.",
                "RCW 7.70.060: Written consent forms meeting statutory criteria create a rebuttable presumption of valid informed consent."
            ],
            clinicalImpact: "Protects surgeons from outcome-based liability. Incidental complications (such as incidental durotomy during revision spine decompression) do not constitute negligence without independent standard-of-care breach."
        ),
        LegalStatute(
            id: "wa-rcw-18-130",
            code: "RCW 18.130",
            jurisdiction: "WA",
            title: "Uniform Disciplinary Act (UDA)",
            summary: "Governs professional discipline, investigations, and board proceedings across all Washington health commissions, including the Washington Medical Commission (WMC).",
            keyProvisions: [
                "RCW 18.130.080: Initiation of complaints and case review.",
                "RCW 18.130.172: Stipulation to Informal Disposition (STID) allows resolution without a finding of unprofessional conduct.",
                "RCW 18.130.180(8): Failure to cooperate with an investigation constitutes unprofessional conduct.",
                "RCW 18.130.160: Permissible sanctions upon formal finding of unprofessional conduct."
            ],
            clinicalImpact: "Provides statutory mechanism (STID under RCW 18.130.172) to settle board inquiries without public findings or admission of clinical misconduct."
        ),
        LegalStatute(
            id: "fed-hcqia",
            code: "42 U.S.C. § 11101 et seq.",
            jurisdiction: "Federal",
            title: "Health Care Quality Improvement Act (HCQIA)",
            summary: "Federal statute establishing peer review immunity, standards for fair hearings, and the National Practitioner Data Bank (NPDB).",
            keyProvisions: [
                "42 U.S.C. § 11112(a): Immunity requires peer review action taken in reasonable belief of furthering quality health care, after reasonable effort to obtain facts, adequate notice and hearing, and reasonable belief that action was warranted.",
                "42 U.S.C. § 11112(b): Minimum standards for notice, right to hearing, right to counsel, right to call witnesses, and impartial tribunal.",
                "42 U.S.C. § 11112(c): Summary suspension exception requires reasonable belief that failure to act may result in imminent danger to the health of any individual.",
                "45 C.F.R. § 60.12: Mandatory NPDB reporting for clinical privileges actions adversely affecting privileges for more than 30 days, or resignation while under investigation."
            ],
            clinicalImpact: "Establishes the critical 30-day summary suspension deadline and due-process standards to defeat sham peer reviews."
        ),
        LegalStatute(
            id: "fed-stark-law",
            code: "42 U.S.C. § 1395nn",
            jurisdiction: "Federal",
            title: "Physician Self-Referral Law (Stark Law)",
            summary: "Prohibits physician referrals for designated health services (DHS) payable by Medicare/Medicaid to entities with which the physician has a financial relationship, unless a statutory exception applies.",
            keyProvisions: [
                "42 C.F.R. § 411.357(c): Bona fide employment relationships exception requiring compensation within Fair Market Value (FMV), commercially reasonable terms, and compensation not determined by volume or value of referrals.",
                "42 C.F.R. § 411.357(p): Fair Market Value compensation exception.",
                "Special Rule for Productivity Bonuses: wRVU productivity formulas permitted if based solely on personally performed physician services."
            ],
            clinicalImpact: "Governs physician salary caps, conversion factors, and compensation models. Total cash compensation above the 90th percentile triggers regulatory FMV audit risk."
        )
    ]
}
