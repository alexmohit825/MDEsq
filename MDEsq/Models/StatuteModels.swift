import SwiftUI
import UIKit

// MARK: - MDEsq Executive Legal Folio Design System

public enum MDEsqTheme {
    public static let obsidian = Color(red: 0.06, green: 0.09, blue: 0.16)       // #0F172A
    public static let slateInk = Color(red: 0.12, green: 0.16, blue: 0.23)       // #1E293B
    public static let parchment = Color(red: 0.97, green: 0.98, blue: 0.99)      // #F8FAFC
    public static let warmPaper = Color(red: 0.99, green: 0.99, blue: 0.98)      // #FDFDFB
    public static let emeraldSeal = Color(red: 0.02, green: 0.47, blue: 0.34)    // #047857
    public static let emeraldSoft = Color(red: 0.93, green: 0.99, blue: 0.96)    // #ECFDF5
    public static let crimsonTrap = Color(red: 0.75, green: 0.07, blue: 0.24)    // #BE123C
    public static let crimsonSoft = Color(red: 1.00, green: 0.95, blue: 0.95)    // #FFF1F2
    public static let amberGold = Color(red: 0.71, green: 0.33, blue: 0.04)      // #B45309
    public static let amberSoft = Color(red: 1.00, green: 0.98, blue: 0.92)      // #FFFBEB
    public static let royalBlue = Color(red: 0.11, green: 0.31, blue: 0.85)      // #1D4ED8
    public static let royalSoft = Color(red: 0.94, green: 0.96, blue: 1.00)      // #EFF6FF
    public static let purpleJudicial = Color(red: 0.43, green: 0.16, blue: 0.85) // #6D28D9
    public static let purpleSoft = Color(red: 0.96, green: 0.95, blue: 1.00)     // #F5F3FF
    public static let borderSubtle = Color(red: 0.89, green: 0.91, blue: 0.94)   // #E2E8F0
}

public enum MDEsqHaptics {
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
        guard !rawText.isEmpty else { return "" }
        var text = rawText
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
                text = regex.stringByReplacingMatches(in: text, options: [], range: range, withTemplate: replacement)
            }
        }
        return text
    }
}

// MARK: - Unified Serverless Cloudflare Edge AI Client (Rule 11)

public actor MDEsqEdgeAIClient {
    public static let shared = MDEsqEdgeAIClient()
    private let workerEndpoint = URL(string: "https://mdesq.mohalex.workers.dev/api/chat")!
    
    public func askCopilot(prompt: String, jurisdiction: String = "WA") async -> String {
        let sanitized = PHISanitizer.sanitize(prompt)
        var request = URLRequest(url: workerEndpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 18
        
        let payload: [String: String] = [
            "prompt": sanitized,
            "jurisdiction": jurisdiction
        ]
        
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
            return """
            ⚖️ MDEsq Strategic Contract Analysis (\(jurisdiction) Statutory Mode):
            • Non-Compete Parity (RCW 49.62): Geographic practice bans >18 months or covering satellite clinics are rebuttably presumed unreasonable. Strike radius bans and substitute a 12-month patient non-solicitation clause.
            • Malpractice Tail Allocation: Demand 100% employer-funded tail coverage upon any without-cause termination, hospital breach, or after 24 months of service vesting.
            • Emergency Call Stipends: Under Stark Law (42 U.S.C. § 1395nn), unassigned trauma/ED call exceeding 4–5 shifts/month warrants dedicated FMV per-diem stipends ($1,800–$3,000/24h).
            """
        } else if q.contains("peer review") || q.contains("suspension") || q.contains("npdb") || q.contains("sham") {
            return """
            🛡️ MDEsq Hospital Peer Review & HCQIA Defense:
            • Cardinal Rule: NEVER voluntarily resign privileges while under investigation. Doing so triggers a permanent federal NPDB adverse action report under 45 CFR § 60.12.
            • The 30-Day Cliff: Summary suspensions resolved or lifted within 29 days are NOT reportable to the NPDB. Demand a Fair Hearing within 14 days and challenge any economic competitors on the panel under 42 U.S.C. § 11112.
            """
        } else if q.contains("wmc") || q.contains("board") || q.contains("stid") || q.contains("cooperation") {
            return """
            🏛️ Washington Medical Commission (WMC) Defense Protocol:
            • Certified Record Pre-Condition: Never submit a narrative response to a Letter of Cooperation before reviewing the full EMR audit trail.
            • Non-Disciplinary STID Shield: Advocate for a Stipulation to Informal Disposition (RCW 18.130.172) or confidential Letter of Concern to protect your license from formal disciplinary findings.
            """
        }
        return """
        ⚖️ MDEsq Executive Medicolegal Brief (\(jurisdiction)):
        • Standard of Care (RCW 7.70.040): Evaluated against a reasonably prudent specialist in the same class and acting under the same or similar clinical circumstances.
        • Informed Consent (RCW 7.70.050): Chart procedure-specific material risks, conservative non-surgical alternatives, and the risks of no treatment.
        • Quality Assurance Privilege (RCW 70.41.200): Keep internal incident reports strictly separate from the patient's clinical medical chart.
        """
    }
}

// MARK: - Statutory & Regulatory Models

public struct StatuteItem: Identifiable, Hashable {
    public let id: String
    public let code: String
    public let title: String
    public let category: String
    public let summary: String
    public let keyProvisions: [String]
    public let physicianTakeaway: String
    
    public init(id: String, code: String, title: String, category: String, summary: String, keyProvisions: [String], physicianTakeaway: String) {
        self.id = id
        self.code = code
        self.title = title
        self.category = category
        self.summary = summary
        self.keyProvisions = keyProvisions
        self.physicianTakeaway = physicianTakeaway
    }
}

public struct FederalRegulation: Identifiable, Hashable {
    public let id: String
    public let name: String
    public let citation: String
    public let summary: String
    public let penalty: String
    public let defenseSafeHarbor: String
    
    public init(id: String, name: String, citation: String, summary: String, penalty: String, defenseSafeHarbor: String) {
        self.id = id
        self.name = name
        self.citation = citation
        self.summary = summary
        self.penalty = penalty
        self.defenseSafeHarbor = defenseSafeHarbor
    }
}

public struct StatutoryDatabase {
    public static let washingtonStatutes: [StatuteItem] = [
        StatuteItem(
            id: "rcw-18-71",
            code: "RCW 18.71",
            title: "Medical Practice Act & WMC Licensing Standards",
            category: "Licensing & Discipline",
            summary: "Governs physician licensure, scope of surgical practice, and Washington Medical Commission (WMC) oversight.",
            keyProvisions: [
                "Defines licensing qualifications and mandatory reporting obligations.",
                "Establishes confidentiality protections for physician health program participation.",
                "Empowers WMC panels to investigate complaints, malpractice payouts, and hospital privilege actions."
            ],
            physicianTakeaway: "Never provide unsworn verbal or written statements to a WMC investigator without healthcare regulatory counsel."
        ),
        StatuteItem(
            id: "rcw-18-130",
            code: "RCW 18.130",
            title: "Uniform Disciplinary Act (UDA) & STID Shield",
            category: "Board Defense",
            summary: "Establishes procedural due process, definitions of unprofessional conduct (RCW 18.130.180), and informal dispositions (RCW 18.130.172).",
            keyProvisions: [
                "RCW 18.130.172: Authorizes non-disciplinary Stipulations to Informal Disposition (STID).",
                "RCW 18.130.230: Governs Letters of Cooperation and 21-day response timelines.",
                "Commission bears the burden of proving charges by Clear, Cogent, and Convincing Evidence."
            ],
            physicianTakeaway: "Always negotiate for a confidential Letter of Concern or non-disciplinary STID without practice restrictions to avoid NPDB reporting."
        ),
        StatuteItem(
            id: "rcw-7-70",
            code: "RCW 7.70",
            title: "Actions for Injuries Resulting from Health Care",
            category: "Malpractice Defense",
            summary: "Codifies Washington medical malpractice standard of care, informed consent elements, and recognized complication defenses.",
            keyProvisions: [
                "RCW 7.70.040: Plaintiff must prove failure to exercise the degree of care, skill, and learning expected of a reasonably prudent specialist.",
                "RCW 7.70.050: Prudent Patient Standard for informed consent and non-surgical alternatives.",
                "Recognized intraoperative complications do not establish a presumption of negligence."
            ],
            physicianTakeaway: "Contemporaneous charting of material risks, conservative alternatives, and intraoperative verification tests is your strongest shield."
        ),
        StatuteItem(
            id: "rcw-49-62",
            code: "RCW 49.62",
            title: "Non-Competition Covenants & Physician Mobility",
            category: "Contracts & Employment",
            summary: "Restricts employer non-competition covenants and penalizes overbroad geographic or durational restrictions.",
            keyProvisions: [
                "Presumes any post-employment non-compete exceeding 18 months to be unreasonable and void.",
                "Protects moonlighting and supplemental clinical services unless they directly conflict with safety.",
                "RCW 49.62.080: Employers enforcing unlawful or overbroad covenants owe mandatory $5,000+ statutory damages plus full attorney fees."
            ],
            physicianTakeaway: "Strike 25-mile multi-facility hospital non-competes and replace with a narrow 12-month patient non-solicitation provision."
        ),
        StatuteItem(
            id: "rcw-70-41-200",
            code: "RCW 70.41.200",
            title: "Hospital Quality Improvement & Peer Review Privilege",
            category: "Peer Review Shield",
            summary: "Shields hospital quality assurance committees, M&M conferences, and peer review files from civil discovery.",
            keyProvisions: [
                "QA committee proceedings, logs, and internal reviews are strictly immune from civil subpoena.",
                "Privilege does not shield the patient's underlying clinical medical chart.",
                "Referencing QA incident reports inside the clinical EMR waives statutory privilege."
            ],
            physicianTakeaway: "Keep clinical progress notes purely factual; never mention incident reports, risk management, or QA debates in the patient chart."
        )
    ]
    
    public static let federalRegulations: [FederalRegulation] = [
        FederalRegulation(
            id: "stark-law",
            name: "Physician Self-Referral Law (Stark Law)",
            citation: "42 U.S.C. § 1395nn / 42 CFR § 411.357",
            summary: "Prohibits physician referrals of Medicare/Medicaid patients for Designated Health Services (DHS) to entities with a financial relationship unless structured within a statutory Safe Harbor.",
            penalty: "Strict liability statute: denial of payment, mandatory refund of all tainted claims, civil penalties of $27,750+ per service, and False Claims Act treble damages.",
            defenseSafeHarbor: "Bona Fide Employment & FMV Exceptions: Compensation must be set in advance, consistent with Fair Market Value (typically 25th–75th percentile), commercially reasonable even without referrals, and never tied to the volume or value of DHS referrals."
        ),
        FederalRegulation(
            id: "aks",
            name: "Federal Anti-Kickback Statute (AKS)",
            citation: "42 U.S.C. § 1320a-7b(b)",
            summary: "Criminal statute prohibiting the knowing and willful offer, payment, solicitation, or receipt of any remuneration to induce or reward referrals of federal healthcare program business.",
            penalty: "Felony conviction, up to 10 years imprisonment, $100,000 criminal fine per violation, and mandatory exclusion from Medicare and Medicaid.",
            defenseSafeHarbor: "Personal Services & ASC Safe Harbors (42 CFR § 1001.952): Written signed agreement for ≥1 year, aggregate compensation set in advance at Fair Market Value."
        ),
        FederalRegulation(
            id: "hcqia",
            name: "Health Care Quality Improvement Act (HCQIA)",
            citation: "42 U.S.C. § 11101 / 45 CFR Part 60",
            summary: "Establishes national standards for hospital professional review actions and mandates NPDB reporting for adverse privilege restrictions lasting longer than 30 days.",
            penalty: "Hospitals acting in bad faith or violating due process lose civil immunity; physicians face permanent national NPDB reporting if suspended >30 days.",
            defenseSafeHarbor: "Section 11112 Due Process Mandate: Physician is entitled to written notice, 30 days to request a Fair Hearing, representation by legal counsel, a verbatim court reporter record, cross-examination of witnesses, and an impartial hearing panel free of direct economic competitors."
        ),
        FederalRegulation(
            id: "emtala",
            name: "Emergency Medical Treatment & Labor Act (EMTALA)",
            citation: "42 U.S.C. § 1395dd",
            summary: "Requires hospitals and on-call specialty physicians to provide medical screening examinations and stabilizing treatment regardless of insurance status.",
            penalty: "Civil monetary penalties up to $119,942 per violation for on-call physicians and termination of Medicare provider status.",
            defenseSafeHarbor: "Document objective clinical stability prior to any transfer, respond within bylaw-mandated on-call windows, and negotiate dedicated FMV call stipends."
        )
    ]
}
