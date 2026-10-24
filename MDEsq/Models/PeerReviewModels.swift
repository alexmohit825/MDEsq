import Foundation

// MARK: - Sham Peer Review Factor
struct ShamFactor: Identifiable, Hashable {
    let id: String
    let title: String
    let weight: Int
    let category: String
    let description: String
    let statutoryRef: String
    let evidenceRequired: String
    var isSelected: Bool = false
}

// MARK: - Summary Suspension Phase (30-Day HCQIA Cliff)
struct SummarySuspensionPhase: Identifiable, Hashable {
    let id: String
    let dayRange: String
    let title: String
    let urgencyLevel: String
    let legalReality: String
    let mandatoryAction: String
}

// MARK: - NPDB Reportability Matrix Item
struct NPDBMatrixItem: Identifiable, Hashable {
    let id: String
    let scenario: String
    let reportableStatus: String
    let statutoryRule: String
    let strategicGuidance: String
}

// MARK: - Washington Medical Commission (WMC) Models
struct WMCPhase: Identifiable, Hashable {
    let id: String
    let phaseNumber: Int
    let title: String
    let timeline: String
    let statutoryRef: String
    let description: String
    let physicianDirective: String
}

struct WMCResponseRule: Identifiable, Hashable {
    let id: String
    let ruleNumber: Int
    let title: String
    let fatalMistake: String
    let executiveRule: String
}

struct WMCPhraseDisrupter: Identifiable, Hashable {
    let id: String
    let context: String
    let toxicPhrase: String
    let masterPhrase: String
    let whyItWorks: String
}

struct WMCSanctionItem: Identifiable, Hashable {
    let id: String
    let tierName: String
    let citation: String
    let npdbReportable: Bool
    let publicRecord: Bool
    let description: String
}

// MARK: - Peer Review & WMC Database
struct PeerReviewDatabase {
    static let shamFactors: [ShamFactor] = [
        ShamFactor(
            id: "sham-competitor-voting",
            title: "Direct Economic Competitors on MEC / Review Panel",
            weight: 15,
            category: "Economic Conflict & Antitrust",
            description: "Physicians in direct economic competition with you initiated the complaint, selected the reviewer, or sat as voting members on the ad-hoc committee.",
            statutoryRef: "42 U.S.C. § 11112(b)(3)(A)(ii)-(iii) / Patrick v. Burget",
            evidenceRequired: "MEC attendance rosters, committee minutes, and subspecialty call/referral overlap logs."
        ),
        ShamFactor(
            id: "sham-summary-suspension-no-danger",
            title: "Summary Suspension Without 'Imminent Danger'",
            weight: 15,
            category: "HCQIA Emergency Abuse",
            description: "Summary suspension invoked over historical chart reviews, administrative friction, or non-acute issues where no patient faces imminent physical danger.",
            statutoryRef: "42 U.S.C. § 11112(c)(2)",
            evidenceRequired: "Timeline showing weeks/months elapsed between the index case and the 'emergency' suspension notice."
        ),
        ShamFactor(
            id: "sham-no-notice-charges",
            title: "Vague Charges / Denial of Medical Chart Access",
            weight: 12,
            category: "Procedural Due Process Breach",
            description: "Accused of 'poor clinical judgment' or 'disruptive behavior' without specific patient MRNs, or locked out of the EMR so you cannot review the index charts.",
            statutoryRef: "42 U.S.C. § 11112(b)(1)(A)",
            evidenceRequired: "Written Notice of Action lacking specific case identifiers + IT termination timestamps."
        ),
        ShamFactor(
            id: "sham-bylaw-violation",
            title: "Material Deviation from Medical Staff Bylaws",
            weight: 12,
            category: "Contractual Breach",
            description: "Administration bypassed informal collegial intervention, skipped department chair review, or ignored mandatory timeline ceilings in the Medical Staff Bylaws.",
            statutoryRef: "Medical Staff Bylaws / WA Contract Law",
            evidenceRequired: "Side-by-side comparison of the hospital's Fair Hearing Plan steps vs. actual dates and notices."
        ),
        ShamFactor(
            id: "sham-whistleblower-retaliation",
            title: "Retaliation Following Patient Safety Escalation",
            weight: 10,
            category: "Statutory Whistleblower Retaliation",
            description: "Peer review investigation opened within 90 days of you reporting unsafe OR staffing, defective implants, EMTALA violations, or administrative pressure.",
            statutoryRef: "RCW 70.41.200 / RCW 43.70.075",
            evidenceRequired: "Prior dated emails, safety incident reports, or texts to leadership raising patient safety concerns."
        ),
        ShamFactor(
            id: "sham-cherry-picked-cases",
            title: "Statistical Cherry-Picking & Disparate Treatment",
            weight: 10,
            category: "Bad Faith Fact-Finding",
            description: "Reviewing 3 complications out of 500 complex cases while ignoring identical or higher complication rates among favored or employed peers.",
            statutoryRef: "42 U.S.C. § 11112(a)(2) (Reasonable Effort to Obtain Facts)",
            evidenceRequired: "Full surgeon volume/outcome denominator logs and OPPE/FPPE comparative benchmarks."
        ),
        ShamFactor(
            id: "sham-ex-parte-review",
            title: "Secret External Review Without Physician Input",
            weight: 8,
            category: "Ex Parte Manipulation",
            description: "Hospital hired an outside reviewer using a curated, incomplete packet of records without allowing you to submit an operative narrative or speak to the reviewer.",
            statutoryRef: "42 U.S.C. § 11112(a)(2)",
            evidenceRequired: "Cover letter/instructions sent by hospital counsel to the external review organization."
        ),
        ShamFactor(
            id: "sham-coerced-resignation",
            title: "'Resign Quietly Today or We Report You to NPDB'",
            weight: 8,
            category: "Constructive Coercion & NPDB Trap",
            description: "CMO or VPMA pressures you to resign privileges or take a leave of absence while an investigation is pending—which triggers an automatic permanent NPDB report.",
            statutoryRef: "45 C.F.R. § 60.12(a)(1)(ii)",
            evidenceRequired: "Contemporaneous memo of conversation or email offering 'quiet resignation' during open review."
        ),
        ShamFactor(
            id: "sham-stacked-hearing-officer",
            title: "Biased Hearing Officer Tied to Hospital Defense Firm",
            weight: 5,
            category: "Tribunal Bias",
            description: "The appointed Fair Hearing Officer has an ongoing financial relationship with the hospital system or its outside counsel.",
            statutoryRef: "42 U.S.C. § 11112(b)(3)(A)(i)",
            evidenceRequired: "Voir dire disclosures and prior retention history of the appointed Hearing Officer."
        ),
        ShamFactor(
            id: "sham-weaponized-wellness",
            title: "Weaponized 'Fitness for Duty' / Psychiatric Referral",
            weight: 5,
            category: "Administrative Intimidation",
            description: "Ordering an invasive neurocognitive or psychiatric evaluation in response to legitimate clinical or operational disagreements.",
            statutoryRef: "ADA / Medical Staff Wellness Policy Abuse",
            evidenceRequired: "Referral directive lacking objective clinical impairment observations."
        )
    ]

    static let suspensionPhases: [SummarySuspensionPhase] = [
        SummarySuspensionPhase(
            id: "phase-days-0-3",
            dayRange: "DAYS 0 – 3",
            title: "Immediate Triage & Anti-Resignation Freeze",
            urgencyLevel: "CRITICAL — DO NOT RESIGN",
            legalReality: "Resigning privileges or taking an 'administrative leave' while under investigation (or to avoid one) is permanently reportable to the NPDB under 45 C.F.R. § 60.12 with zero right to a Fair Hearing.",
            mandatoryAction: "1. Refuse any verbal or written request to resign.\n2. Retain specialized medical staff counsel immediately.\n3. Demand in writing the exact patient MRNs, the specific 'imminent danger' justification under 42 U.S.C. § 11112(c)(2), and read-only EMR access to review the index charts."
        ),
        SummarySuspensionPhase(
            id: "phase-days-4-14",
            dayRange: "DAYS 4 – 14",
            title: "Bylaws Audit & Voluntary Abeyance Negotiation",
            urgencyLevel: "HIGH — NEGOTIATE ABEYANCE WINDOW",
            legalReality: "Clinical privileges restrictions only become reportable to the NPDB once they remain in effect for MORE than 30 consecutive days. Days 4–14 are your prime window to lift the suspension before day 30.",
            mandatoryAction: "1. Propose lifting the summary suspension before Day 25 in exchange for a non-reportable collegial proctoring plan or independent external peer review while retaining active privileges.\n2. Serve formal written demand preserving all Fair Hearing rights under the Medical Staff Bylaws."
        ),
        SummarySuspensionPhase(
            id: "phase-days-15-29",
            dayRange: "DAYS 15 – 29",
            title: "Pre-NPDB Cliff & Injunctive Preparation",
            urgencyLevel: "SEVERE — 30-DAY NPDB CLIFF IMMINENT",
            legalReality: "On Day 31 of a summary suspension, the hospital is federally mandated to file an Adverse Action Report with the NPDB—even if a Fair Hearing has not yet taken place and even if you are later exonerated.",
            mandatoryAction: "1. Obtain independent board-certified academic expert reviews refuting the 'imminent danger' allegation.\n2. Prepare a Motion for Temporary Restraining Order (TRO) in Superior Court if the hospital violated its own Medical Staff Bylaws or lacked any imminent patient safety threat."
        ),
        SummarySuspensionPhase(
            id: "phase-days-30-plus",
            dayRange: "DAY 30+",
            title: "Fair Hearing Record & NPDB Dispute Subject Statement",
            urgencyLevel: "LITIGATION RECORD BUILDING",
            legalReality: "Once Day 30 passes, an NPDB report is filed. Your objective shifts to winning the Fair Hearing to force a Void/Revision of the NPDB report, and building an administrative record for court.",
            mandatoryAction: "1. Conduct formal voir dire of every Hearing Panel member and the Hearing Officer on the record.\n2. File a 4,000-character Subject Statement and Secretarial Review Dispute in the NPDB if the action violated reporting rules."
        )
    ]

    static let npdbMatrix: [NPDBMatrixItem] = [
        NPDBMatrixItem(
            id: "npdb-1",
            scenario: "Summary Suspension lifted on Day 28",
            reportableStatus: "NON-REPORTABLE",
            statutoryRule: "45 C.F.R. § 60.12(a)(1)(i)",
            strategicGuidance: "Adverse clinical privilege actions must last MORE than 30 days to be reportable. Lifting a suspension on or before Day 30 avoids an NPDB report entirely."
        ),
        NPDBMatrixItem(
            id: "npdb-2",
            scenario: "Resignation or non-renewal of privileges during an open investigation",
            reportableStatus: "MANDATORY REPORT (PERMANENT)",
            statutoryRule: "45 C.F.R. § 60.12(a)(1)(ii)",
            strategicGuidance: "Never resign, let privileges lapse, or restrict your own clinical scope while an investigation is pending—even if an administrator promises 'we won't report you.' Federal law overrides verbal promises."
        ),
        NPDBMatrixItem(
            id: "npdb-3",
            scenario: "Concurrent proctoring where proctor has NO veto power and need not be present before surgery",
            reportableStatus: "NON-REPORTABLE",
            statutoryRule: "NPDB Guidebook Ch. E (Clinical Privileges)",
            strategicGuidance: "If you can still operate independently without prior approval or mandatory physical presence of a proctor (e.g., retrospective chart review or observation), your privileges are not restricted."
        ),
        NPDBMatrixItem(
            id: "npdb-4",
            scenario: "Mandatory proctoring requiring pre-approval or physical presence before performing a procedure for >30 days",
            reportableStatus: "MANDATORY REPORT",
            statutoryRule: "NPDB Guidebook Ch. E",
            strategicGuidance: "Requiring another surgeon's sign-off or physical presence restricts your independent exercise of privileges and is reportable if imposed for >30 days."
        ),
        NPDBMatrixItem(
            id: "npdb-5",
            scenario: "Medical malpractice settlement paid by corporate entity (Hospital/Group) where physician is dismissed prior to settlement",
            reportableStatus: "NON-REPORTABLE (Corporate Shield)",
            statutoryRule: "45 C.F.R. § 60.7",
            strategicGuidance: "If the individual physician is unconditionally dismissed from the lawsuit before settlement and is not named in the settlement release/payment made solely on behalf of the corporate hospital, no NPDB report is filed against the physician."
        ),
        NPDBMatrixItem(
            id: "npdb-6",
            scenario: "Washington Medical Commission STID (Stipulation to Informal Disposition)",
            reportableStatus: "STATE BOARD REPORT (NO ADMISSION OF MISCONDUCT)",
            statutoryRule: "RCW 18.130.172",
            strategicGuidance: "An STID resolves a WMC investigation informally without a finding of unprofessional conduct, avoiding formal Statement of Charges under RCW 18.130.090."
        )
    ]

    static let wmcPhases: [WMCPhase] = [
        WMCPhase(
            id: "wmc-1",
            phaseNumber: 1,
            title: "Intake & Case Management Team (CMT) Triage",
            timeline: "Weeks 1 – 4",
            statutoryRef: "RCW 18.130.080",
            description: "A patient, peer, hospital, or malpractice insurer files a report. A 3-member CMT (including a WMC clinician) reviews whether the allegation, if true, violates the Uniform Disciplinary Act (RCW 18.130.180). Over 65% of complaints are closed at intake.",
            physicianDirective: "You typically do not know a complaint is at CMT unless authorized for investigation. Never contact a complaining patient."
        ),
        WMCPhase(
            id: "wmc-2",
            phaseNumber: 2,
            title: "The 14-Day Letter of Cooperation (LOC)",
            timeline: "14-Day Statutory Response Window",
            statutoryRef: "RCW 18.130.180(8)",
            description: "The WMC Investigator sends a formal Letter of Cooperation requesting your written narrative and complete medical records within 14 days (or 21 days for malpractice self-reports). Failure to cooperate is itself a separate statutory violation.",
            physicianDirective: "Immediately notify your malpractice carrier's administrative defense benefit and request a 14-to-30 day extension via legal counsel before writing a single word."
        ),
        WMCPhase(
            id: "wmc-3",
            phaseNumber: 3,
            title: "Reviewing Commission Member (RCM) Presentation",
            timeline: "Months 2 – 5",
            statutoryRef: "RCW 18.130.050",
            description: "A clinician Reviewing Commission Member (often in your specialty or an adjacent field) evaluates the investigator's file, your written LOC response, and the complete medical records, then presents the case to a WMC Panel.",
            physicianDirective: "Your written response must read like a peer-reviewed academic M&M presentation backed by PubMed citations and objective timeline tables—because it is being read by a fellow physician on the Commission."
        ),
        WMCPhase(
            id: "wmc-4",
            phaseNumber: 4,
            title: "Panel Disposition: Closure vs. STID vs. Charges",
            timeline: "Months 4 – 8",
            statutoryRef: "RCW 18.130.172 / RCW 18.130.090",
            description: "The WMC Panel votes to either: (1) Close the case with No Action, (2) Offer a Stipulation to Informal Disposition (STID) under RCW 18.130.172, or (3) Issue a formal Statement of Charges.",
            physicianDirective: "Proactively implementing a clinic/operative protocol improvement and completing targeted Category 1 CME before the Panel meets frequently secures an outright closure."
        ),
        WMCPhase(
            id: "wmc-5",
            phaseNumber: 5,
            title: "Formal Adjudicative Proceeding / Settlement",
            timeline: "Months 8 – 14",
            statutoryRef: "RCW 34.05 (Administrative Procedure Act)",
            description: "If a Statement of Charges is issued, the case proceeds to formal discovery, expert witness exchange, and a hearing before a Health Law Judge and WMC Panel, or resolves via an Agreed Order.",
            physicianDirective: "Engage top-tier specialty academic experts early to establish that your clinical judgment fell squarely within the standard of care."
        )
    ]

    static let wmcRules: [WMCResponseRule] = [
        WMCResponseRule(
            id: "wmc-rule-1",
            ruleNumber: 1,
            title: "Never Reply Unrepresented in an Emotional Email",
            fatalMistake: "Typing a defensive, angry, or rambling response the night you open the WMC envelope.",
            executiveRule: "Your malpractice policy almost always includes $25,000–$50,000 in free Disciplinary Defense coverage. Call your carrier Day 1, retain a specialized Washington health-law attorney, and have counsel request a routine extension."
        ),
        WMCResponseRule(
            id: "wmc-rule-2",
            ruleNumber: 2,
            title: "Never Alter, Backdate, or 'Clean Up' the EMR",
            fatalMistake: "Opening the patient's electronic chart after receiving a WMC letter to add missing details without a clear 'Late Entry' header.",
            executiveRule: "WMC investigators routinely subpoena raw EMR audit logs showing every keystroke, view, and timestamp. An undisclosed chart alteration turns a defensible clinical case into an indefensible fraud charge under RCW 18.130.180(1)."
        ),
        WMCResponseRule(
            id: "wmc-rule-3",
            ruleNumber: 3,
            title: "Anchor Every Clinical Decision to Peer-Reviewed Literature",
            fatalMistake: "Saying 'In my 20 years of experience, I always do it this way.'",
            executiveRule: "Attach 2–3 landmark peer-reviewed society guidelines (e.g., AANS/CNS, AAOS, ACOG, ACEP) demonstrating that your diagnostic or operative choice is a recognized school of thought."
        ),
        WMCResponseRule(
            id: "wmc-rule-4",
            ruleNumber: 4,
            title: "Demonstrate 'Insight & Systemic Remediation' Without Admitting Negligence",
            fatalMistake: "Blaming the nurse, the resident, or the patient, which convinces the WMC you are a recurring risk.",
            executiveRule: "The WMC's statutory mandate is public protection, not punishment. Show that while your care met the standard of care, you have voluntarily enhanced your post-op discharge instructions or handoff checklist so the communication gap can never recur."
        ),
        WMCResponseRule(
            id: "wmc-rule-5",
            ruleNumber: 5,
            title: "Strict Chronological Precision Table",
            fatalMistake: "Writing a dense 6-page wall of prose that buries the critical vitals and timestamps.",
            executiveRule: "Open your clinical narrative with a clean 1-page Chronological Matrix (Date | Exact Time | Clinical Objective Data | Physician Action) so the Reviewing Commission Member can verify your diligence in 60 seconds."
        )
    ]

    static let wmcPhraseDisrupters: [WMCPhraseDisrupter] = [
        WMCPhraseDisrupter(
            id: "phrase-1",
            context: "Addressing a Complication or Unanticipated Outcome",
            toxicPhrase: "\"This complaint is meritless. The patient was non-compliant and obese, and everybody knows dural tears happen.\"",
            masterPhrase: "\"The patient presented with high-grade canal stenosis and ossified ligamentum flavum—well-established anatomical risk factors in neurosurgical literature for incidental durotomy (cite). Primary microsurgical repair and Valsalva verification were performed intraoperatively in strict accordance with standard neurosurgical protocol.\"",
            whyItWorks: "Replaces defensive hostility with objective anatomical terminology and peer-reviewed standard-of-care grounding."
        ),
        WMCPhraseDisrupter(
            id: "phrase-2",
            context: "Addressing a Communication or Documentation Gap",
            toxicPhrase: "\"I definitely told the patient about the risk of nerve injury, even if my PA didn't type it in the clinic note.\"",
            masterPhrase: "\"In accordance with my invariable pre-operative practice and signed statutory consent (Exhibit B, p. 4), material neurovascular risks were reviewed. To further strengthen clinic documentation moving forward, our practice has implemented a standardized specialty-specific pre-operative risk SmartPhrase across all providers.\"",
            whyItWorks: "Invokes admissible 'habit and custom' corroborated by the signed hospital consent while proving proactive systems improvement."
        ),
        WMCPhraseDisrupter(
            id: "phrase-3",
            context: "Addressing Delayed Follow-Up or Handoff Friction",
            toxicPhrase: "\"Nursing never paged me about the post-op neurological change until Monday morning.\"",
            masterPhrase: "\"Upon receiving the first direct notification of altered motor exam at 06:42 on [Date], I ordered stat MRI imaging within 8 minutes and was at the bedside at 07:15. Following this event, I worked with unit leadership to institute a mandatory red-flag escalation protocol requiring direct attending surgeon telephone contact for any post-spine motor delta.\"",
            whyItWorks: "Establishes your rapid personal response once notified via objective timestamps, and turns a hospital systems failure into evidence of your clinical leadership."
        )
    ]

    static let wmcSanctionTiers: [WMCSanctionItem] = [
        WMCSanctionItem(
            id: "tier-1",
            tierName: "Tier 1: Case Closure / Notice of Decision (No Action)",
            citation: "RCW 18.130.080",
            npdbReportable: false,
            publicRecord: false,
            description: "The WMC concludes the evidence does not support a violation of the Uniform Disciplinary Act, or that any minor concern has already been remediated. Confidential and non-reportable."
        ),
        WMCSanctionItem(
            id: "tier-2",
            tierName: "Tier 2: Stipulation to Informal Disposition (STID)",
            citation: "RCW 18.130.172",
            npdbReportable: true,
            publicRecord: true,
            description: "An informal settlement containing NO finding and NO admission of unprofessional conduct. Typically involves CME, a paper, or a practice review and small cost reimbursement ($1,000–$3,000)."
        ),
        WMCSanctionItem(
            id: "tier-3",
            tierName: "Tier 3: Agreed Order (Formal Disciplinary Action)",
            citation: "RCW 18.130.160",
            npdbReportable: true,
            publicRecord: true,
            description: "A formal disciplinary settlement following a Statement of Charges. Contains formal Conclusions of Law finding unprofessional conduct, and may impose probation, practice monitoring, or fines."
        ),
        WMCSanctionItem(
            id: "tier-4",
            tierName: "Tier 4: Final Order After Adjudicative Hearing",
            citation: "RCW 18.130.160 / RCW 34.05",
            npdbReportable: true,
            publicRecord: true,
            description: "Issued by a WMC Hearing Panel after a contested trial. Can impose practice restrictions, oversight, substantial fines, or license suspension."
        ),
        WMCSanctionItem(
            id: "tier-5",
            tierName: "Tier 5: Summary Suspension / Restriction of License",
            citation: "RCW 18.130.050(8) / RCW 34.05.479",
            npdbReportable: true,
            publicRecord: true,
            description: "Emergency pre-hearing license suspension or restriction invoked only when the Commission finds an immediate danger to the public health, safety, or welfare."
        )
    ]
}
