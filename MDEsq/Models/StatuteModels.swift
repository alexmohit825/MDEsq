import SwiftUI
import UIKit

// MARK: - MDEsq Luminous Editorial Legal Folio Design System (Sunlit Alabaster & Midnight Sapphire)

public enum MDEsqAppearanceMode: String, CaseIterable {
    case sunlit = "Sunlit Folio"
    case midnight = "Midnight"
    case system = "Auto"

    public var colorScheme: ColorScheme? {
        switch self {
        case .sunlit: return .light
        case .midnight: return .dark
        case .system: return nil
        }
    }

    public var iconName: String {
        switch self {
        case .sunlit: return "sun.max.fill"
        case .midnight: return "moon.stars.fill"
        case .system: return "circle.lefthalf.filled"
        }
    }
}

public enum MDEsqTheme {
    private static func adaptive(light: UIColor, dark: UIColor) -> Color {
        Color(UIColor { traits in
            traits.userInterfaceStyle == .dark ? dark : light
        })
    }

    // Primary Canvas & Architectural Card Surfaces
    // In Sunlit (Light) mode: Warm Alabaster Paper (#F5F3EC) with Pure Crisp White Cards (#FFFFFF)
    // In Midnight (Dark) mode: Luminous Sapphire (#0F172A) with Elevated Slate-Navy Cards (#1E293B)
    public static let obsidian = adaptive(
        light: UIColor(red: 0.96, green: 0.95, blue: 0.92, alpha: 1.0), // #F5F3EC Warm Sunlit Alabaster
        dark:  UIColor(red: 0.06, green: 0.09, blue: 0.16, alpha: 1.0)  // #0F172A Luminous Midnight Sapphire
    )

    public static let navyCard = adaptive(
        light: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.0), // #FFFFFF Pure Editorial White Card
        dark:  UIColor(red: 0.11, green: 0.16, blue: 0.25, alpha: 1.0)  // #1C2840 Bright Navy Card
    )

    public static let navyElevated = adaptive(
        light: UIColor(red: 0.93, green: 0.91, blue: 0.86, alpha: 1.0), // #EDE9DC Warm Stone Pill/Inset
        dark:  UIColor(red: 0.15, green: 0.21, blue: 0.33, alpha: 1.0)  // #263654 Elevated Indigo Surface
    )

    public static let slateInk = adaptive(
        light: UIColor(red: 0.06, green: 0.09, blue: 0.16, alpha: 1.0),
        dark:  UIColor(red: 0.12, green: 0.16, blue: 0.23, alpha: 1.0)
    )

    // Typography Hierarchy (High-Contrast AA/AAA Legibility in Bright Hospital Lighting)
    public static let ivory = adaptive(
        light: UIColor(red: 0.06, green: 0.09, blue: 0.16, alpha: 1.0), // #0F172A Deep Oxford Ink
        dark:  UIColor(red: 0.98, green: 0.98, blue: 0.96, alpha: 1.0)  // #FAF9F5 Crisp Ivory
    )

    public static let parchment = adaptive(
        light: UIColor(red: 0.15, green: 0.20, blue: 0.29, alpha: 1.0), // #26334A Rich Charcoal Slate
        dark:  UIColor(red: 0.92, green: 0.90, blue: 0.85, alpha: 1.0)  // #EBE6D9 Warm Parchment
    )

    public static let slateMuted = adaptive(
        light: UIColor(red: 0.32, green: 0.38, blue: 0.47, alpha: 1.0), // #526178 Crisp Muted Slate
        dark:  UIColor(red: 0.64, green: 0.70, blue: 0.78, alpha: 1.0)  // #A3B3C7 Bright Muted Silver
    )

    public static let warmPaper = Color(red: 0.99, green: 0.99, blue: 0.98)

    // Executive Accents (Contrast-Tuned for Both Sunlit & Midnight Modes)
    public static let gold = adaptive(
        light: UIColor(red: 0.64, green: 0.44, blue: 0.05, alpha: 1.0), // #A3700D Burnished Judicial Gold
        dark:  UIColor(red: 0.90, green: 0.73, blue: 0.30, alpha: 1.0)  // #E6BA4C Luminous Sovereign Gold
    )

    public static let goldLight = adaptive(
        light: UIColor(red: 0.52, green: 0.35, blue: 0.04, alpha: 1.0), // #85590A Deep Antique Bronze
        dark:  UIColor(red: 0.95, green: 0.86, blue: 0.58, alpha: 1.0)  // #F2DC94 Champagne Gold
    )

    public static let emerald = adaptive(
        light: UIColor(red: 0.02, green: 0.52, blue: 0.36, alpha: 1.0), // #05855C Deep Judicial Emerald
        dark:  UIColor(red: 0.10, green: 0.82, blue: 0.58, alpha: 1.0)  // #1AD194 Luminous Emerald
    )

    public static let emeraldSeal = Color(red: 0.02, green: 0.47, blue: 0.34)
    public static let emeraldSoft = Color(red: 0.93, green: 0.99, blue: 0.96)

    public static let crimson = adaptive(
        light: UIColor(red: 0.78, green: 0.11, blue: 0.18, alpha: 1.0), // #C71C2E High-Contrast Crimson
        dark:  UIColor(red: 0.97, green: 0.33, blue: 0.33, alpha: 1.0)  // #F85454 Vibrant Alert Red
    )

    public static let crimsonTrap = Color(red: 0.75, green: 0.07, blue: 0.24)
    public static let crimsonSoft = Color(red: 1.00, green: 0.95, blue: 0.95)

    public static let amber = adaptive(
        light: UIColor(red: 0.76, green: 0.38, blue: 0.04, alpha: 1.0), // #C2610A Deep Amber Warning
        dark:  UIColor(red: 0.98, green: 0.68, blue: 0.16, alpha: 1.0)  // #FAAD29 Bright Amber
    )

    public static let amberGold = Color(red: 0.71, green: 0.33, blue: 0.04)
    public static let amberSoft = Color(red: 1.00, green: 0.98, blue: 0.92)
    public static let royalBlue = Color(red: 0.11, green: 0.31, blue: 0.85)
    public static let royalSoft = Color(red: 0.94, green: 0.96, blue: 1.00)
    public static let purpleJudicial = Color(red: 0.43, green: 0.16, blue: 0.85)
    public static let purpleSoft = Color(red: 0.96, green: 0.95, blue: 1.00)

    public static let borderSubtle = adaptive(
        light: UIColor(red: 0.84, green: 0.81, blue: 0.73, alpha: 1.0), // #D6CFC2 Crisp Folio Rule Border
        dark:  UIColor(red: 0.22, green: 0.30, blue: 0.44, alpha: 1.0)  // #384D70 Luminous Border
    )
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
            ("\\b(?:\\+?1[-.\\s]?)?\\(?\\d{3}\\)?[-.\\s]?\\d{3}\\)?[-.\\s]?\\d{4}\\b", "[PHONE-REDACTED]"),
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
        if q.contains("tail") || q.contains("non-compete") || q.contains("contract") || q.contains("redline") || q.contains("invention") || q.contains("patent") {
            return "STATUTORY ADVISORY (RCW 49.62, RCW 49.44.140 & WA Malpractice Standards):\nUnder Washington law (RCW 49.62.020), restrictive covenants exceeding 18 months are presumptively unreasonable, and agreements lacking pre-acceptance disclosure are void ab initio. Under RCW 49.44.140, hospital clauses claiming ownership of physician inventions created on personal time without hospital resources are void. For tail insurance, require 100% hospital funding upon termination without cause."
        } else if q.contains("peer review") || q.contains("suspension") || q.contains("wmc") || q.contains("stid") {
            return "STATUTORY ADVISORY (HCQIA 42 U.S.C. § 11112 & RCW 18.130.172):\nDo not submit a resignation during an active investigation—doing so triggers mandatory, permanent NPDB reporting under 45 C.F.R. § 60.12. For WMC inquiries, respond within the 14-day Letter of Cooperation window via counsel and seek a non-disciplinary Stipulation to Informal Disposition (STID) where appropriate."
        } else {
            return "STATUTORY ADVISORY (RCW 7.70.040, RCW 5.64.010 & WPI 105.08):\nIn Washington medical malpractice defense, adverse clinical outcomes do not establish breach of care. The physician's exercise of reasonable clinical judgment between accepted treatment alternatives is shielded under WPI 105.08. Document prospective decision-making contemporaneously."
        }
    }
}

// MARK: - First-Hour Physician Crisis Triage Playbooks (Unique Physician Survival Engine)

public struct CrisisPlaybook: Identifiable, Hashable {
    public let id: String
    public let badge: String
    public let title: String
    public let icon: String
    public let urgencyWindow: String
    public let fatalTrap: String
    public let first60MinutesSteps: [String]
    public let verbatimScript: String
    public let statutoryAnchor: String
}

public struct CrisisPlaybookDatabase {
    public static let allPlaybooks: [CrisisPlaybook] = [
        CrisisPlaybook(
            id: "crisis-cmo-ambush",
            badge: "SCENARIO 1 • HOSPITAL ADMINISTRATION",
            title: "The Friday 4:30 PM CMO / VPMA 'Step Into My Office' Ambush",
            icon: "exclamationmark.shield.fill",
            urgencyWindow: "FIRST 30 MINUTES",
            fatalTrap: "Signing a 'voluntary leave of absence' or verbally resigning privileges on the spot to avoid a threatened investigation—which triggers an immediate, permanent NPDB Adverse Action Report under 45 C.F.R. § 60.12 with zero right to a Fair Hearing.",
            first60MinutesSteps: [
                "Listen calmly, take written notes of everyone present, and make zero clinical concessions or apologies.",
                "Refuse to sign any document, resignation, or 'voluntary abeyance' during the meeting.",
                "Demand in writing the specific Medical Staff Bylaw section being invoked and the exact patient MRNs at issue.",
                "Within 30 minutes of leaving the room, send a timestamped 'Confirming Memorandum' email to the CMO and your personal email documenting that you have NOT resigned and demand all notices in writing."
            ],
            verbatimScript: "\"I take patient safety and my clinical practice seriously. Because you are referencing medical staff governance matters, I will not make verbal statements or sign any documents today. Please provide the specific written notice, patient identifiers, and relevant Medical Staff Bylaws provisions so my counsel and I can review them properly.\"",
            statutoryAnchor: "42 U.S.C. § 11112(b) (HCQIA Notice) & 45 C.F.R. § 60.12"
        ),
        CrisisPlaybook(
            id: "crisis-catastrophic-outcome",
            badge: "SCENARIO 2 • OPERATING ROOM / ICU",
            title: "Unexpected Catastrophic Intra-Operative Complication or Death",
            icon: "Waveform.path.ecg.rectangle.fill".lowercased(),
            urgencyWindow: "FIRST 2 HOURS",
            fatalTrap: "Speculating on fault during emotional family disclosure, venting in text messages/emails to colleagues (which are 100% discoverable outside a formal Quality Committee), or going back days later to alter the EMR without a transparent Late Entry timestamp.",
            first60MinutesSteps: [
                "Deliver compassionate, factual disclosure to the family using Washington's Apology Shield (RCW 5.64.010): express sympathy and describe known objective anatomical facts, but NEVER speculate or state 'I made a mistake' before full root-cause facts are known.",
                "Dictate a calm, objective, anatomically precise Operative Note within 2 hours detailing the patient's pre-existing pathology (e.g., severe scarring, ossification), protective steps taken, and intraoperative management.",
                "Do NOT send text messages, emails, or WhatsApp messages to colleagues discussing the case—plaintiff attorneys subpoena physician cell phones directly.",
                "Notify your malpractice carrier's Risk Management hotline immediately as a 'Potential Event Report' to lock in attorney-client privilege from Day 1."
            ],
            verbatimScript: "\"I am deeply sorry that your loved one experienced this serious complication. During the procedure, we encountered severe anatomical adherence along the [structure]. Here is what we know right now and the exact clinical steps we are taking in the ICU to support their recovery.\"",
            statutoryAnchor: "RCW 5.64.010 (Apology Shield) & RCW 70.41.200 (CQIP Privilege)"
        ),
        CrisisPlaybook(
            id: "crisis-summons-served",
            badge: "SCENARIO 3 • MALPRACTICE LITIGATION",
            title: "Served With a Summons & Complaint or Notice of Intent to Sue",
            icon: "doc.badge.Alert".lowercased(),
            urgencyWindow: "FIRST 24 HOURS (20-DAY DEFAULT CLOCK)",
            fatalTrap: "Opening the patient's electronic medical record in Epic/Cerner out of curiosity after being served (which leaves an indelible audit-trail timestamp that plaintiff counsel uses at trial to accuse you of chart snooping/tampering), or assuming Hospital Risk Management represents you personally.",
            first60MinutesSteps: [
                "DO NOT OPEN THE PATIENT'S CHART IN THE EMR. Every click, hover, and view after service of process is logged in the federal audit trail and subpoenaed.",
                "Record the exact date, time, and manner of service—in Washington State (CR 4 / CR 12), you have strictly 20 days to file a formal Notice of Appearance and Answer before default judgment.",
                "Transmit the summons immediately to your malpractice insurance claims department and request an experienced medical malpractice trial partner.",
                "Create a private file marked 'CONFIDENTIAL — ATTORNEY-CLIENT PRIVILEGED PREPARED FOR DEFENSE COUNSEL' and store nothing inside the hospital EMR."
            ],
            verbatimScript: "\"I have just been served with legal process regarding [Case/Date]. Please confirm immediate assignment of my personal defense counsel and ensure a Notice of Appearance is entered well before the 20-day statutory deadline.\"",
            statutoryAnchor: "RCW 7.70.100 & Wash. Super. Ct. Civ. R. 12(a)"
        ),
        CrisisPlaybook(
            id: "crisis-fact-witness-subpoena",
            badge: "SCENARIO 4 • SUBPOENA / DEPOSITION TRAP",
            title: "Subpoenaed as a 'Non-Party Treating Physician' or Fact Witness",
            icon: "person.crop.circle.badge.exclamationmark",
            urgencyWindow: "BEFORE ANY ATTORNEY PHONE CALL",
            fatalTrap: "Agreeing to an 'informal 15-minute phone chat' with a plaintiff's lawyer or testifying at a deposition without your own defense lawyer because 'I'm not the one being sued.' Over 35% of unrepresented treating physicians are added as named defendants right after their fact-witness deposition.",
            first60MinutesSteps: [
                "Never speak informally to a plaintiff's attorney or outside investigator—doing so without patient authorization or court order also violates HIPAA and RCW 70.02 (Berger v. Sonneland).",
                "Forward the subpoena to your malpractice insurer immediately; your policy covers providing an attorney to represent and prepare you at any deposition arising from your clinical care.",
                "Demand expert/professional witness preparation and have your attorney limit examination strictly to your documented dates of care.",
                "Refuse to offer standard-of-care criticisms against co-treating physicians on the record."
            ],
            verbatimScript: "\"Pursuant to HIPAA (45 C.F.R. § 164.512) and Washington health care confidentiality law (RCW 70.02 / Berger v. Sonneland), I cannot discuss any patient's care informally. Please direct all subpoenas and scheduling requests to my legal counsel.\"",
            statutoryAnchor: "RCW 70.02.020 & Berger v. Sonneland, 144 Wash. 2d 91"
        ),
        CrisisPlaybook(
            id: "crisis-fitness-for-duty",
            badge: "SCENARIO 5 • WEAPONIZED WELLNESS",
            title: "Coerced 'Fitness for Duty' / Psychiatric or Cognitive Evaluation",
            icon: "brain.head.profile",
            urgencyWindow: "WITHIN 48 HOURS OF DIRECTIVE",
            fatalTrap: "Blindly submitting to an administration-selected psychiatric evaluation in response to a disagreement over OR block time, nursing staffing, or whistleblowing—allowing the hospital to sideline you indefinitely without granting a Fair Hearing under the Bylaws.",
            first60MinutesSteps: [
                "Demand in writing the specific, objective, witnessed clinical impairment behaviors required by the Medical Staff Bylaws to trigger a Fitness for Duty evaluation.",
                "If the referral followed your escalation of patient safety or staffing concerns, formally invoke Washington Whistleblower Protection (RCW 70.41.200 / RCW 43.70.075) in writing.",
                "Never sign an unrestricted HIPAA release allowing an evaluator to hand raw psychological test notes directly to hospital executives.",
                "Negotiate via legal counsel for any evaluation to be conducted by a mutually agreed, independent academic center with strict confidentiality boundaries."
            ],
            verbatimScript: "\"Through counsel, I request the specific written factual basis and Medical Staff Bylaw provision authorizing this referral. Please note that on [Date], I formally escalated patient safety concerns regarding OR staffing, and any retaliatory misuse of wellness procedures violates RCW 70.41.200.\"",
            statutoryAnchor: "42 U.S.C. § 12112(d)(4)(A) (ADA) & RCW 70.41.200"
        ),
        CrisisPlaybook(
            id: "crisis-ip-invention-seizure",
            badge: "SCENARIO 6 • PHYSICIAN INVENTOR & IP RIGHTS",
            title: "Hospital Claiming Ownership of Your Medical Device, Software, or App",
            icon: "cpu.fill",
            urgencyWindow: "BEFORE SIGNING OR DISCLOSING IP",
            fatalTrap: "Signing an employment agreement or conflict disclosure that assigns 'all healthcare-related software, algorithms, or medical devices conceived during the Period of Employment' to the health system.",
            first60MinutesSteps: [
                "Invoke Washington RCW 49.44.140: By statute, any employment provision requiring you to assign an invention developed entirely on your own time without using hospital equipment, supplies, or trade secrets is VOID AND UNENFORCEABLE unless it relates directly to the hospital's actual R&D.",
                "Build, code, and test all personal medical apps, AI tools, and device CAD files strictly on personal hardware, personal Wi-Fi/cellular, and outside scheduled clinical hours.",
                "Attach a mandatory 'Schedule A — Excluded Prior & Independent Inventions' exhibit to your employment contract.",
                "Require the hospital to provide the statutory written notification mandated by RCW 49.44.140(3)."
            ],
            verbatimScript: "\"Pursuant to Washington RCW 49.44.140, any software, educational platform, or device developed entirely on my personal time and personal equipment without Hospital resources remains my exclusive intellectual property and is excluded from Section [X].\"",
            statutoryAnchor: "Washington RCW 49.44.140 (Employee Inventions Statute)"
        )
    ]
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
            id: "wa-rcw-49-44-140",
            code: "RCW 49.44.140",
            jurisdiction: "WA",
            title: "Physician & Employee Invention Protection Act",
            summary: "Protects physician-inventors and software creators from overreaching hospital intellectual property seizure clauses.",
            keyProvisions: [
                "RCW 49.44.140(1): Any employment contract provision requiring an employee to assign rights to an invention for which no employer equipment, supplies, facilities, or trade secret information was used, and which was developed entirely on the employee's own time, is AGAINST PUBLIC POLICY AND VOID.",
                "RCW 49.44.140(3): Employer must provide written notice at the time of contracting that the agreement does not apply to inventions protected under RCW 49.44.140."
            ],
            clinicalImpact: "Shields physicians who build independent medical apps, surgical instruments, or clinical algorithms on their own time and personal devices from hospital IP confiscation."
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
            id: "wa-rcw-5-64-010",
            code: "RCW 5.64.010",
            jurisdiction: "WA",
            title: "Benevolent Gestures & Apology Inadmissibility Shield",
            summary: "Governs post-complication communications with patients and families within 30 days of discovery.",
            keyProvisions: [
                "RCW 5.64.010(1): Statements, affirmations, gestures, or conduct expressing apology, fault, sympathy, commiseration, condolence, compassion, or benevolence made by a health care provider to a patient or family within 30 days are INADMISSIBLE as evidence of liability in a civil action."
            ],
            clinicalImpact: "Allows physicians to communicate empathetically and humanely with patients and families immediately after an unanticipated surgical complication without creating a trial admission."
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
