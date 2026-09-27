import Foundation

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
            title: "Medical Practice Act & Licensing Standards",
            category: "Licensing & Discipline",
            summary: "Governs the licensing, scope of practice, and unprofessional conduct definitions for physicians in Washington State under the Washington Medical Commission.",
            keyProvisions: [
                "Defines unauthorized practice and unprofessional conduct standards under RCW 18.130.180.",
                "Mandates 200 hours of CME every 4 years and mandatory reporting of peer discipline.",
                "Empowers WMC to investigate patient complaints, malpractice settlements, and hospital suspensions."
            ],
            physicianTakeaway: "Never provide unsworn narrative statements to WMC investigators without healthcare counsel representation."
        ),
        StatuteItem(
            id: "rcw-7-70",
            code: "RCW 7.70",
            title: "Actions for Injuries Resulting from Health Care",
            category: "Malpractice Defense",
            summary: "Establishes standard of care, informed consent requirements, expert witness rules, and affirmative defenses in civil malpractice lawsuits.",
            keyProvisions: [
                "RCW 7.70.040: Plaintiff must prove physician failed to exercise that degree of care, skill, and learning expected of a reasonably prudent health care provider.",
                "RCW 7.70.050: Informed consent requires disclosure of material risks, non-operative alternatives, and anticipated success rates.",
                "RCW 7.70.060: Recognizing recognized complications does not create a presumption of negligence."
            ],
            physicianTakeaway: "Complications that are known material risks (e.g. incidental dural tear) are non-negligent if informed consent and corrective techniques are charted contemporaneously."
        ),
        StatuteItem(
            id: "rcw-49-62",
            code: "RCW 49.62",
            title: "Non-Competition Covenants & Physician Mobility",
            category: "Contracts & Employment",
            summary: "Strictly curtails restrictive covenants for employed healthcare providers in Washington.",
            keyProvisions: [
                "Non-competes are void against employees earning less than the annual inflation-adjusted statutory threshold ($120,559+).",
                "Maximum 18-month duration presumption; geographic restrictions must be strictly reasonable.",
                "Employer attempting to enforce an unlawful non-compete owes mandatory statutory damages of $5,000+ plus actual damages and full attorney fees."
            ],
            physicianTakeaway: "Hospital employers often include unenforceable 25-mile radius non-competes. Demand immediate replacement with reasonable patient non-solicitation."
        ),
        StatuteItem(
            id: "rcw-70-41-200",
            code: "RCW 70.41.200",
            title: "Hospital Quality Improvement & Peer Review Privilege",
            category: "Peer Review Shield",
            summary: "Protects quality improvement discussions, morbidity & mortality (M&M) conferences, and peer review records from civil subpoena discovery.",
            keyProvisions: [
                "All proceedings, records, and committee findings are strictly confidential and immune from civil discovery.",
                "Immunity does not protect raw underlying clinical medical records.",
                "Voluntarily disclosing QA discussions outside privileged channels waives statutory protection."
            ],
            physicianTakeaway: "Never reference incident reports or QA committee discussions inside the patient's permanent electronic health record."
        )
    ]
    
    public static let federalRegulations: [FederalRegulation] = [
        FederalRegulation(
            id: "stark-law",
            name: "Physician Self-Referral Law (Stark Law)",
            citation: "42 U.S.C. § 1395nn / 42 CFR § 411.350",
            summary: "Prohibits physicians from referring Medicare/Medicaid patients for designated health services (DHS) to entities with which the physician has a financial relationship, unless a specific safe harbor exception applies.",
            penalty: "Civil monetary penalties up to $27,750+ per claim, refund of all payments, and False Claims Act treble damages.",
            defenseSafeHarbor: "Fair Market Value (FMV) Exception: Compensation must reflect commercial reasonableness for actual services rendered (25th-75th percentile) and cannot take into account volume or value of downstream surgical referrals."
        ),
        FederalRegulation(
            id: "hcqia",
            name: "Health Care Quality Improvement Act of 1986",
            citation: "42 U.S.C. § 11101 / 45 CFR Part 60",
            summary: "Grants hospital peer review committees conditional civil immunity while establishing the National Practitioner Data Bank (NPDB) reporting mandate for adverse privilege actions exceeding 30 days.",
            penalty: "Loss of HCQIA immunity for bad-faith or discriminatory peer review; lifetime adverse reporting to NPDB.",
            defenseSafeHarbor: "Due Process Standard (§ 11112): Physician must receive written notice, list of specific clinical cases, right to legal counsel, right to cross-examine witnesses, and hearing before an impartial panel."
        )
    ]
}
