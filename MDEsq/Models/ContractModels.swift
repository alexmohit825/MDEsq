import Foundation

public struct ContractClauseRule: Identifiable, Hashable {
    public let id: String
    public let name: String
    public let riskSeverity: String // Critical, High, Moderate
    public let keywords: [String]
    public let predatorySnippetExample: String
    public let statutoryBasis: String
    public let problemSummary: String
    public let recommendedRedline: String
    public let negotiationScript: String
    
    public init(id: String, name: String, riskSeverity: String, keywords: [String], predatorySnippetExample: String, statutoryBasis: String, problemSummary: String, recommendedRedline: String, negotiationScript: String) {
        self.id = id
        self.name = name
        self.riskSeverity = riskSeverity
        self.keywords = keywords
        self.predatorySnippetExample = predatorySnippetExample
        self.statutoryBasis = statutoryBasis
        self.problemSummary = problemSummary
        self.recommendedRedline = recommendedRedline
        self.negotiationScript = negotiationScript
    }
}

public struct FlaggedClause: Identifiable, Hashable {
    public var id: String { rule.id }
    public let rule: ContractClauseRule
    public let matchedTextSnippet: String
    public let lineEstimate: Int
}

public struct ContractAnalysisResult {
    public let totalClausesAnalyzed: Int
    public let flaggedClauses: [FlaggedClause]
    public let overallGrade: String // A, B, C, D, F
    public let gradeDescription: String
}

public struct ContractDatabase {
    public static let rules: [ContractClauseRule] = [
        ContractClauseRule(
            id: "clause-non-compete",
            name: "Geographic Non-Compete Practice Ban",
            riskSeverity: "Critical",
            keywords: ["non-compete", "covenant not to compete", "restrictive covenant", "miles of hospital", "radius of the hospital", "shall not engage in the practice"],
            predatorySnippetExample: "Physician agrees that for 24 months post-termination, Physician shall not practice medicine within 25 miles of any Hospital facility.",
            statutoryBasis: "Washington RCW 49.62 / AMA Code of Medical Ethics 9.63",
            problemSummary: "Restricts physician mobility, creates severe relocation hardship, and deprives established patients of clinical continuity.",
            recommendedRedline: "STRIKE NON-COMPETE IN ITS ENTIRETY. Insert: 'Following termination, Physician shall not actively solicit Hospital's patients or employees for twelve (12) months. Nothing herein shall restrict Physician from opening an independent clinic or accepting employment at any location.'",
            negotiationScript: "Under Washington law (RCW 49.62), overly broad geographic non-competes on specialized surgical physicians trigger mandatory statutory damages and attorney fees. I am striking the 25-mile radius and substituting standard patient non-solicitation."
        ),
        ContractClauseRule(
            id: "clause-tail-insurance",
            name: "100% Physician Malpractice Tail Liability",
            riskSeverity: "Critical",
            keywords: ["tail insurance", "extended reporting period", "cost of tail", "physician's sole expense", "claims-made policy"],
            predatorySnippetExample: "Upon termination for any reason, Physician shall purchase and maintain extended reporting period (tail) coverage at Physician's sole cost.",
            statutoryBasis: "Customary MGMA Standard / Stark Law FMV Safe Harbor (42 CFR § 411.357)",
            problemSummary: "Exposes physician to $40,000–$150,000+ out-of-pocket tail premium expenses upon departure, even if terminated without cause.",
            recommendedRedline: "Replace with: 'Hospital shall pay 100% of the cost of extended reporting period (tail) malpractice coverage if Physician is terminated without Cause, or upon completion of twenty-four (24) months of service. If Physician terminates without Cause prior to 24 months, the cost of tail shall be shared equally (50/50).'",
            negotiationScript: "It is standard medical industry practice for the health system to provide occurrence-type protection or fund tail coverage after 2 years of vesting or in any without-cause separation."
        ),
        ContractClauseRule(
            id: "clause-indemnification",
            name: "One-Sided Physician Indemnification",
            riskSeverity: "High",
            keywords: ["indemnify and hold harmless", "indemnification", "defend, indemnify", "loss or damage arising from physician"],
            predatorySnippetExample: "Physician agrees to indemnify, defend, and hold harmless Hospital and its affiliates against any and all claims, lawsuits, liabilities, or losses.",
            statutoryBasis: "Respondeat Superior Common Law / Insurance Policy Exclusion",
            problemSummary: "Shifts hospital institutional liability onto the physician individually, which standard professional liability insurance will NOT cover.",
            recommendedRedline: "STRIKE ENTIRE INDEMNIFICATION SECTION. Insert: 'Each party shall be responsible solely for its own negligent acts or omissions pursuant to applicable state law. Neither party shall be required to indemnify the other for ordinary clinical operations covered by malpractice insurance.'",
            negotiationScript: "Standard malpractice insurance policies explicitly exclude coverage for contractually assumed indemnity liabilities. Requiring me to indemnify the health system violates standard underwriting rules."
        ),
        ContractClauseRule(
            id: "clause-uncompensated-call",
            name: "Mandatory Uncompensated Emergency Call",
            riskSeverity: "High",
            keywords: ["unassigned call", "emergency department call", "call without additional compensation", "take call as assigned", "all required call"],
            predatorySnippetExample: "Physician shall provide emergency department on-call coverage as assigned by Chief of Staff with no additional per-diem stipend.",
            statutoryBasis: "EMTALA (42 U.S.C. § 1395dd) / Stark Law Commercial Reasonableness",
            problemSummary: "Imposes heavy uncompensated night/weekend liability burden without fair market stipend.",
            recommendedRedline: "Insert: 'Physician shall provide up to four (4) days of emergency call per month as part of base duties. All emergency call days exceeding four (4) per month shall be compensated at the fair market rate of $2,500.00 per 24-hour shift.'",
            negotiationScript: "Subspecialty emergency call carries substantial medicolegal risk and sleep disruption. Providing call beyond 4 shifts per month without an FMV stipend creates Stark Law and fairness concerns."
        )
    ]
}
