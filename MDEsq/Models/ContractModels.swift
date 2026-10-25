import Foundation

public enum ClauseSeverity: String, Hashable, CaseIterable {
    case critical = "Critical"
    case high = "High"
    case moderate = "Moderate"
}

public struct ContractClauseRule: Identifiable, Hashable {
    public let id: String
    public let title: String
    public let category: String
    public let severity: ClauseSeverity
    public let riskPoints: Int
    public let statutoryCitation: String
    public let triggerKeywords: [String]
    public let legalAnalysis: String
    public let recommendedRedline: String
    public let negotiationScript: String
    
    // Backwards-compatible aliases
    public var name: String { title }
    public var riskSeverity: String { severity.rawValue }
    public var keywords: [String] { triggerKeywords }
    public var statutoryBasis: String { statutoryCitation }
    public var problemSummary: String { legalAnalysis }
    public var legalStandard: String { legalAnalysis }
    
    public init(
        id: String,
        title: String,
        category: String,
        severity: ClauseSeverity,
        riskPoints: Int,
        statutoryCitation: String,
        triggerKeywords: [String],
        legalAnalysis: String,
        recommendedRedline: String,
        negotiationScript: String
    ) {
        self.id = id
        self.title = title
        self.category = category
        self.severity = severity
        self.riskPoints = riskPoints
        self.statutoryCitation = statutoryCitation
        self.triggerKeywords = triggerKeywords
        self.legalAnalysis = legalAnalysis
        self.recommendedRedline = recommendedRedline
        self.negotiationScript = negotiationScript
    }
}

public struct FlaggedClause: Identifiable, Hashable {
    public let id: String
    public let title: String
    public let category: String
    public let severity: ClauseSeverity
    public let riskPoints: Int
    public let statutoryCitation: String
    public let sectionOrPageLabel: String
    public let matchedTriggerTokens: [String]
    public let actualMatchedExcerpt: String
    public let legalAnalysis: String
    public let recommendedRedline: String
    public let negotiationScript: String
    
    // Backwards-compatible aliases
    public var matchedTextSnippet: String { actualMatchedExcerpt }
    
    public init(
        id: String,
        title: String,
        category: String,
        severity: ClauseSeverity,
        riskPoints: Int,
        statutoryCitation: String,
        sectionOrPageLabel: String,
        matchedTriggerTokens: [String],
        actualMatchedExcerpt: String,
        legalAnalysis: String,
        recommendedRedline: String,
        negotiationScript: String
    ) {
        self.id = id
        self.title = title
        self.category = category
        self.severity = severity
        self.riskPoints = riskPoints
        self.statutoryCitation = statutoryCitation
        self.sectionOrPageLabel = sectionOrPageLabel
        self.matchedTriggerTokens = matchedTriggerTokens
        self.actualMatchedExcerpt = actualMatchedExcerpt
        self.legalAnalysis = legalAnalysis
        self.recommendedRedline = recommendedRedline
        self.negotiationScript = negotiationScript
    }
}

public struct ContractAnalysisResult {
    public let totalClausesAnalyzed: Int
    public let flaggedClauses: [FlaggedClause]
    public let overallGrade: String
    public let gradeDescription: String
    
    public init(totalClausesAnalyzed: Int, flaggedClauses: [FlaggedClause], overallGrade: String, gradeDescription: String) {
        self.totalClausesAnalyzed = totalClausesAnalyzed
        self.flaggedClauses = flaggedClauses
        self.overallGrade = overallGrade
        self.gradeDescription = gradeDescription
    }
}

public struct ContractDatabase {
    public static let sampleHospitalContract: String = """
    PHYSICIAN EMPLOYMENT AGREEMENT
    
    This Physician Employment Agreement ("Agreement") is entered into by and between Regional Medical Center ("Hospital") and Physician ("Employee").
    
    1. DUTIES AND EXCLUSIVITY
    Employee shall devote full-time professional efforts exclusively to Hospital. Employee shall not engage in any other professional medical activities, moonlighting, consulting, or expert witness work without the prior express written consent of Hospital, which may be withheld in Hospital's sole discretion.
    
    2. COMPENSATION AND WRVU PRODUCTION CLAWBACK
    Hospital shall pay Employee a base salary of $650,000 per annum. Employee shall achieve a minimum annual threshold of 10,500 wRVUs. In the event Employee fails to achieve the annual wRVU threshold, Hospital reserves the right to retroactively adjust and claw back base compensation in subsequent quarters.
    
    3. EMERGENCY DEPARTMENT CALL COVERAGE
    Employee shall participate in unassigned emergency department on-call coverage for up to 10 days per month (including weekends and holidays) as assigned by the Department Chair. Call coverage is deemed included within Employee's base salary and shall receive no separate daily stipend or hourly compensation.
    
    4. TERM AND TERMINATION WITHOUT CAUSE
    (a) Either party may terminate this Agreement without cause upon giving thirty (30) days prior written notice to the other party.
    (b) Hospital may terminate this Agreement immediately for cause upon written notice.
    
    5. PROFESSIONAL LIABILITY INSURANCE AND TAIL COVERAGE
    Hospital shall maintain claims-made professional liability insurance during the Term of this Agreement. Upon termination of this Agreement for any reason, Employee shall be solely responsible for purchasing and paying 100% of the cost of an extended reporting endorsement ("Tail Insurance Coverage").
    
    6. RESTRICTIVE COVENANTS AND NON-COMPETITION
    For a period of twenty-four (24) months following the termination of this Agreement for any reason, Employee shall not directly or indirectly practice medicine, perform surgical procedures, or provide clinical consulting within a radius of twenty-five (25) miles of any hospital, clinic, outpatient surgery center, or medical office owned or operated by Hospital.
    
    7. UNILATERAL AMENDMENT OF POLICIES AND BYLAWS
    Hospital reserves the right to modify, amend, or alter clinical productivity targets, call rosters, and administrative policies from time to time via updates to Medical Staff Bylaws or Administrative Handbooks, and Employee agrees to be bound by all such updates without requiring a formal written amendment to this Agreement.
    
    8. PHYSICIAN INDEMNIFICATION OF HOSPITAL
    Employee agrees to defend, indemnify, and hold harmless Hospital, its directors, officers, and agents from any and all claims, liabilities, damages, or malpractice expenses arising out of Employee's clinical services.
    """
    
    public static var rules: [ContractClauseRule] { clauseRules }
    
    public static let clauseRules: [ContractClauseRule] = [
        ContractClauseRule(
            id: "clause-non-compete",
            title: "Geographic Non-Compete Practice Ban",
            category: "Restrictive Covenants",
            severity: .high,
            riskPoints: 20,
            statutoryCitation: "Washington RCW 49.62 & AMA Ethics Opinion 9.6.3",
            triggerKeywords: ["non-competition", "non-compete", "covenant not to compete", "restrictive covenant", "miles of any hospital", "radius of", "shall not directly or indirectly practice", "twenty-four (24) months"],
            legalAnalysis: "A 24-month duration and 25-mile radius around all hospital satellite facilities effectively banishes a specialist from an entire metropolitan region. Under RCW 49.62.020, covenants exceeding 18 months are rebuttably presumed unreasonable and void. Enforcing an overbroad covenant triggers mandatory $5,000+ statutory damages plus full attorney fees against the employer (RCW 49.62.080).",
            recommendedRedline: """
            6. NON-SOLICITATION OF PATIENTS [STRIKE GEOGRAPHIC NON-COMPETE]:
            "During the Term and for twelve (12) months following termination, Physician shall not actively solicit Hospital's established patients for whom Physician did not provide direct medical care. Nothing in this Agreement shall restrict Physician from practicing medicine or performing surgery in any geographic location post-termination pursuant to RCW 49.62. Physician retains full right to notify Physician's active surgical panel of Physician's new practice address."
            """,
            negotiationScript: "Under Washington RCW 49.62, post-employment non-competes exceeding 18 months or radiating from every satellite clinic are presumptively unreasonable and expose the hospital to statutory fee shifting. We are striking the geographic practice ban and substituting standard 12-month patient non-solicitation."
        ),
        ContractClauseRule(
            id: "clause-tail-insurance",
            title: "100% Physician Malpractice Tail Liability",
            category: "Malpractice Insurance",
            severity: .critical,
            riskPoints: 25,
            statutoryCitation: "MGMA Contracting Standard & Stark Law FMV (42 CFR § 411.357)",
            triggerKeywords: ["tail insurance", "extended reporting", "cost of tail", "solely responsible for purchasing", "100% of the cost", "physician's sole expense", "claims-made"],
            legalAnalysis: "Forces the surgeon to pay $50,000–$150,000+ out-of-pocket for claims-made tail coverage upon departure—even if the hospital terminates the surgeon without cause. Industry fair market contracting requires the hospital employer to fund 100% of tail insurance if the hospital terminates without cause, if the physician terminates for hospital breach, or after 24 months of service vesting.",
            recommendedRedline: """
            5. PROFESSIONAL LIABILITY & TAIL COVERAGE ALLOCATION:
            "Hospital shall maintain claims-made professional liability coverage. Upon termination, Hospital shall pay one hundred percent (100%) of the cost of Physician's extended reporting endorsement ('Tail Insurance') if: (i) Hospital terminates this Agreement without Cause, (ii) Physician terminates for Hospital's material breach, (iii) Physician completes twenty-four (24) months of continuous service, or (iv) termination occurs due to death or disability. Prior to 24 months in a voluntary departure without cause, tail cost shall vest 50% per year."
            """,
            negotiationScript: "Surgical tail coverage costs upwards of $80,000+. Requiring me to pay 100% of tail if the hospital terminates me without cause is an uninsurable financial hazard. Standard health system contracts cover 100% of tail for any without-cause termination or after 24 months of vesting."
        ),
        ContractClauseRule(
            id: "clause-indemnification",
            title: "One-Sided Physician Indemnification of Hospital",
            category: "Liability & Risk Shifting",
            severity: .critical,
            riskPoints: 25,
            statutoryCitation: "Respondeat Superior Common Law & Malpractice Policy Exclusions",
            triggerKeywords: ["defend, indemnify, and hold harmless", "indemnify hospital", "indemnification", "hold harmless hospital", "arising out of employee's clinical"],
            legalAnalysis: "Shifts corporate vicarious liability and hospital defense costs onto the individual physician personally—a liability that malpractice policies explicitly exclude as 'contractually assumed liability'. Under Respondeat Superior, the hospital employer is vicariously liable for acts of employed physicians within the scope of employment. One-sided physician indemnification clauses must be struck in their entirety.",
            recommendedRedline: """
            8. SCOPE OF EMPLOYMENT & MUTUAL RESPONSIBILITY [STRIKE INDEMNIFICATION]:
            "[STRIKE PHYSICIAN INDEMNIFICATION IN ITS ENTIRETY]. Each party shall be responsible for its own acts and omissions pursuant to applicable state law. Hospital shall defend, indemnify, and hold harmless Physician from and against any and all claims, liabilities, and legal expenses arising out of Physician's authorized clinical services within the scope of employment."
            """,
            negotiationScript: "Malpractice insurance policies contain a strict 'contractual liability exclusion' and do not cover liabilities assumed via corporate indemnification clauses. Under respondeat superior, an employed physician never indemnifies the hospital employer. Section 8 must be stricken."
        ),
        ContractClauseRule(
            id: "clause-unilateral-amendment",
            title: "Unilateral Policy & Compensation Amendments",
            category: "Governance & Contract Parity",
            severity: .critical,
            riskPoints: 20,
            statutoryCitation: "Contract Mutuality of Obligation & Washington Wage Law",
            triggerKeywords: ["unilateral amendment", "modify, amend, or alter", "without requiring a formal written amendment", "updates to medical staff bylaws", "administrative handbooks", "reserves the right to modify"],
            legalAnalysis: "Allows hospital executives to unilaterally slash $/wRVU rates, hike production targets, or double call duties simply by updating an internal handbook without your signature. Core employment terms (compensation formulas, wRVU thresholds, call caps, clinical schedule) must require a formal written amendment signed by both Physician and Hospital.",
            recommendedRedline: """
            7. MUTUAL WRITTEN AMENDMENT REQUIREMENT:
            "This Agreement constitutes the entire agreement between the parties. No modification, amendment, or alteration to Physician's compensation formula, wRVU thresholds, call obligations, or clinical schedule shall be valid or binding unless set forth in a formal written amendment manually executed by both Physician and Hospital. In the event of any conflict between this Agreement and any Hospital policy or handbook, the terms of this Agreement shall control."
            """,
            negotiationScript: "A bilateral employment contract cannot allow one party to alter wRVU targets or call obligations through unilateral policy updates. Any change to material terms must require a mutual signed amendment, and this Agreement must control over conflicting administrative handbooks."
        ),
        ContractClauseRule(
            id: "clause-uncompensated-call",
            title: "Uncompensated Mandatory Emergency Call",
            category: "Compensation & FMV",
            severity: .high,
            riskPoints: 15,
            statutoryCitation: "EMTALA (42 U.S.C. § 1395dd) & Stark Law Commercial Reasonableness",
            triggerKeywords: ["emergency department on-call", "on-call coverage", "included within employee's base", "no separate daily stipend", "unassigned call", "call coverage is deemed included"],
            legalAnalysis: "Mandating 10 days/month of uncompensated 24-hour trauma/ED call dilutes the surgeon's $/wRVU rate and imposes massive uncompensated EMTALA risk. Stark Law FMV standards support dedicated per-diem stipends ($1,500–$3,500/24h for surgical subspecialties) for call coverage exceeding baseline medical staff citizenship (typically 4–5 days/month).",
            recommendedRedline: """
            3. EMERGENCY CALL COVERAGE & FMV STIPENDS:
            "Physician shall participate in equitable rotating unassigned emergency call not to exceed four (4) days per month (including no more than one weekend). For any unassigned call shift exceeding four (4) days per month, Hospital shall pay Physician a dedicated Fair Market Value call stipend of $2,000 per 24-hour weekday shift and $2,500 per 24-hour weekend/holiday shift, paid monthly in addition to base salary."
            """,
            negotiationScript: "Ten days a month of uncompensated trauma call is well above standard medical staff citizenship (1-in-7 or 4 days/month). We need a hard cap of 4 baseline call shifts per month, with dedicated FMV per-diem stipends for any additional shifts."
        ),
        ContractClauseRule(
            id: "clause-without-cause-notice",
            title: "Hazardous 30-Day Without-Cause Termination Window",
            category: "Employment Security",
            severity: .high,
            riskPoints: 15,
            statutoryCitation: "Hospital Credentialing Timelines & Patient Abandonment Rules",
            triggerKeywords: ["thirty (30) days prior written notice", "30 days prior written notice", "without cause upon giving thirty", "terminate this agreement without cause", "without cause"],
            legalAnalysis: "A 30-day termination window leaves a surgeon with zero income while waiting 90–120 days for hospital privileges and payer credentialing at a new institution. Specialty physician agreements require a minimum of 90 to 120 days mutual written notice for without-cause termination, paired with full salary and benefits continuation.",
            recommendedRedline: """
            4(a). MUTUAL 90-DAY TERMINATION WITHOUT CAUSE:
            "Either party may terminate this Agreement without cause upon giving not less than ninety (90) days prior written notice to the other party. During such 90-day notice window, Physician shall continue to receive full base salary, benefits, and accrued wRVU productivity bonuses, regardless of whether Hospital elects to place Physician on paid administrative garden leave."
            """,
            negotiationScript: "Hospital credentialing and surgical block transitions take a minimum of 90 to 120 days. A 30-day without-cause termination window disrupts surgical continuity and creates a credentialing gap. Let's make Section 4(a) a mutual 90-day notice window."
        ),
        ContractClauseRule(
            id: "clause-clawback",
            title: "Retroactive Base Salary wRVU Clawback",
            category: "Compensation Security",
            severity: .high,
            riskPoints: 15,
            statutoryCitation: "Washington Wage Rebate Act (RCW 49.52.050) & RCW 49.48",
            triggerKeywords: ["retroactively adjust", "claw back", "clawback", "fails to achieve the annual wrvu threshold", "claw back base compensation"],
            legalAnalysis: "Subjects guaranteed base salary to retroactive forfeiture if hospital OR block time, anesthesia staffing shortages, or nursing shortages limit surgical volume. Guaranteed base salary represents payment for clinical availability and must never be subject to retroactive clawbacks. Productivity targets should govern upside incentive bonuses only.",
            recommendedRedline: """
            2. GUARANTEED BASE SALARY & UPSIDE WRVU INCENTIVES [STRIKE CLAWBACK]:
            "Hospital shall pay Physician a guaranteed base salary of $650,000 per annum, which shall not be subject to downward reduction or retroactive clawback during the Initial Term. For all wRVUs personally performed in excess of 8,500 wRVUs per contract year, Hospital shall pay Physician an incentive bonus of $92.50 per wRVU, reconciled and paid within thirty (30) days after each calendar quarter."
            """,
            negotiationScript: "Surgeons cannot control hospital OR staffing, anesthesia availability, or inpatient bed closures. Base salary must be a true floor without retroactive clawbacks, while wRVU thresholds govern quarterly upside bonus distributions."
        )
    ]
}
