/**
 * MDEsq - Physician Employment Contract Analysis & Redline Engine
 * Curated clause detection patterns, statutory benchmark rules (RCW 49.62, Stark, Anti-Kickback),
 * and attorney-vetted replacement language with negotiation scripts.
 */

export const SAMPLE_HOSPITAL_CONTRACT = `PHYSICIAN EMPLOYMENT AGREEMENT

This Physician Employment Agreement ("Agreement") is entered into by and between Regional Medical Center ("Hospital") and Physician ("Employee").

1. DUTIES AND EXCLUSIVITY
Employee shall devote full-time professional efforts exclusively to Hospital. Employee shall not engage in any other professional medical activities, moonlighting, consulting, or telemedicine without the prior express written consent of Hospital, which may be withheld in Hospital's sole discretion.

2. COMPENSATION AND WRVU PRODUCTION
Hospital shall pay Employee a base salary of $650,000 per annum. Employee shall achieve a minimum annual threshold of 10,500 wRVUs. In the event Employee fails to achieve the annual wRVU threshold, Hospital reserves the right to retroactively adjust and claw back base compensation in subsequent quarters.

3. EMERGENCY CALL COVERAGE
Employee shall participate in unassigned emergency department on-call coverage for up to 10 days per month (including weekends and holidays) as assigned by the Department Chair. Call coverage is deemed included within Employee's base salary and shall receive no separate daily stipend or hourly compensation.

4. TERM AND TERMINATION
(a) Either party may terminate this Agreement without cause upon giving thirty (30) days prior written notice to the other party.
(b) Hospital may terminate this Agreement immediately for cause upon written notice.

5. PROFESSIONAL LIABILITY INSURANCE AND TAIL COVERAGE
Hospital shall maintain claims-made professional liability insurance during the Term of this Agreement. Upon termination of this Agreement for any reason, Employee shall be solely responsible for purchasing and paying 100% of the cost of an extended reporting endorsement ("Tail Insurance Coverage").

6. RESTRICTIVE COVENANTS AND NON-COMPETITION
For a period of twenty-four (24) months following the termination of this Agreement for any reason, Employee shall not directly or indirectly practice medicine, perform surgical procedures, or provide clinical consulting within a radius of twenty-five (25) miles of any hospital, clinic, outpatient surgery center, or medical office owned or operated by Hospital.

7. UNILATERAL AMENDMENT OF POLICIES AND BYLAWS
Hospital reserves the right to modify, amend, or alter clinical productivity targets, call rosters, and administrative policies from time to time via updates to Medical Staff Bylaws or Administrative Handbooks, and Employee agrees to be bound by all such updates without requiring a formal written amendment to this Agreement.

8. INDEMNIFICATION
Employee agrees to defend, indemnify, and hold harmless Hospital, its directors, officers, and agents from any and all claims, liabilities, damages, or malpractice expenses arising out of Employee's clinical services.`;

export const CONTRACT_CLAUSE_RULES = [
  {
    id: "clause-non-compete",
    name: "Non-Competition & Geographic Restriction",
    category: "Restrictive Covenants",
    riskSeverity: "High",
    statutoryBasis: "Washington RCW 49.62 & FTC Non-Compete Guidance",
    keywords: ["non-competition", "non-compete", "shall not directly or indirectly practice", "radius of", "miles of any hospital", "twenty-four (24) months", "restrictive covenant"],
    detectPattern: /(non-compete|shall not.*practice|radius of.*miles|twenty-four.*months|restrictive covenant)/i,
    riskExplanation: "The 24-month duration and 25-mile radius around all hospital-affiliated facilities is overly broad and anticompetitive. In Washington (RCW 49.62), non-competes are rebuttably presumed unreasonable if they exceed 18 months, and broad radius definitions covering any satellite facility effectively exclude surgeons from entire metropolitan regions.",
    legalStandard: "Under RCW 49.62.020, non-competes are void against employees unless earnings exceed statutory thresholds, duration is ≤18 months, and geographic scope is strictly limited to the primary physical hospital of practice. Attempting to enforce an invalid covenant triggers mandatory attorney fees against the hospital (RCW 49.62.080).",
    recommendedRedline: `RECOMMENDED REDLINE REPLACEMENT:
"6. NON-SOLICITATION OF PATIENTS (STRIKE NON-COMPETE):
During the Term and for a period of twelve (12) months following termination, Physician shall not actively solicit Hospital's established patients for whom Physician did not provide direct medical care. Nothing in this Agreement shall restrict Physician from practicing medicine, performing surgery, or establishing a clinical practice in any geographic area post-termination, in strict accordance with Washington RCW 49.62. Physician shall retain full rights to notify Physician's active patient panel of Physician's new practice location."`,
    negotiationScript: `"Our state statute (RCW 49.62) and patient continuity-of-care standards strongly disfavor post-employment practice bans for surgical specialists. A 25-mile radius around every hospital outpatient clinic is unreasonable and restricts community access to specialized surgical care. We need to strike the geographic non-compete and replace it with standard, reasonable non-solicitation language."`
  },
  {
    id: "clause-tail-insurance",
    name: "Professional Liability Tail Insurance Allocation",
    category: "Malpractice Insurance",
    riskSeverity: "Critical",
    statutoryBasis: "Industry Fair Market Practice / Healthcare Contracting Norms",
    keywords: ["tail insurance", "extended reporting endorsement", "claims-made", "solely responsible for purchasing", "100% of the cost of"],
    detectPattern: /(tail insurance|extended reporting|solely responsible.*tail|100%.*cost of.*tail)/i,
    riskExplanation: "Forcing the physician to pay 100% of tail insurance upon termination (which can cost $50,000 to $150,000+ for surgical subspecialties like Neurosurgery or Orthopedic Spine) operates as a massive financial penalty for leaving, effectively trapping the physician in the position.",
    legalStandard: "Fair market medical contracting requires the hospital to fund 100% of tail coverage if the hospital terminates without cause, if the physician terminates for hospital material breach, or after continuous service vesting (e.g. 2-3 years).",
    recommendedRedline: `RECOMMENDED REDLINE REPLACEMENT:
"5. PROFESSIONAL LIABILITY & TAIL COVERAGE:
Hospital shall provide and maintain claims-made professional liability insurance coverage for Physician. Upon termination of this Agreement, Hospital shall pay one hundred percent (100%) of the cost of Physician's extended reporting endorsement ('Tail Insurance') if: (i) Hospital terminates this Agreement without cause, (ii) Physician terminates this Agreement for Hospital's material breach, (iii) Physician terminates after twenty-four (24) months of continuous service, or (iv) termination occurs due to Physician's death or permanent disability."`,
    negotiationScript: `"Surgical tail insurance is a major financial obligation. Requiring the surgeon to pay 100% of tail if the hospital decides to terminate without cause creates an unacceptable financial hazard. Standard hospital contracting provides that the health system covers 100% of tail if termination is without cause or after two years of service."`
  },
  {
    id: "clause-without-cause-notice",
    name: "Without-Cause Termination Window",
    category: "Employment Security",
    riskSeverity: "High",
    statutoryBasis: "Hospital Credentialing Timelines & Medical Staff Continuity",
    keywords: ["thirty (30) days", "30 days prior written notice", "without cause upon giving thirty", "terminate without cause"],
    detectPattern: /(thirty\s*\(30\)\s*days.*without cause|terminate.*without cause.*thirty\s*\(30\)\s*days)/i,
    riskExplanation: "A 30-day without-cause termination notice period is hazardous for surgeons. Hospital credentialing, surgical scheduling, and state medical board privilege transfers require a minimum of 90 to 120 days.",
    legalStandard: "Surgical and specialty physician contracts customarily provide 90 to 120 days mutual written notice for termination without cause, paired with pay continuation during any garden leave period.",
    recommendedRedline: `RECOMMENDED REDLINE REPLACEMENT:
"4(a). TERMINATION WITHOUT CAUSE:
Either party may terminate this Agreement without cause upon giving not less than ninety (90) days prior written notice to the other party. During such notice period, Physician shall continue to receive full base salary, benefits, and pro-rata productivity incentive compensation, regardless of whether Hospital requests Physician to continue clinical duties."`,
    negotiationScript: `"Surgical credentialing at any regional medical center requires 90 to 120 days. A 30-day notice period creates a severe gap in patient care continuity and credentialing. We need to adjust the mutual without-cause notice period to 90 days with guaranteed pay continuation."`
  },
  {
    id: "clause-uncompensated-call",
    name: "Uncompensated Emergency Department Call",
    category: "Compensation & FMV",
    riskSeverity: "High",
    statutoryBasis: "EMTALA (42 U.S.C. § 1395dd) & Stark Law Commercial Reasonableness",
    keywords: ["emergency call", "on-call coverage", "included within employee's base", "no separate daily stipend", "10 days per month"],
    detectPattern: /(on-call.*included within.*base|no separate.*daily stipend|call.*without.*compensation)/i,
    riskExplanation: "Requiring up to 10 days of unrestricted 24-hour emergency trauma/call coverage without dedicated stipends depresses the effective $/wRVU conversion rate and exposes the physician to uncompensated medical liability under EMTALA.",
    legalStandard: "Commercial reasonableness under Stark Law (42 U.S.C. § 1395nn) supports dedicated call coverage per diems ($1,200 - $3,500/24h for surgical subspecialties) for shifts exceeding standard medical staff emergency roster obligations.",
    recommendedRedline: `RECOMMENDED REDLINE REPLACEMENT:
"3. EMERGENCY CALL COVERAGE & STIPENDS:
Physician shall participate in equitable, rotating unassigned specialty call coverage not to exceed five (5) days per month (including no more than one weekend). For all unassigned emergency call coverage, Hospital shall pay Physician a dedicated call coverage stipend of $1,800 per 24-hour weekday shift and $2,500 per 24-hour weekend/holiday shift, paid monthly in addition to Physician's base compensation."`,
    negotiationScript: `"Unassigned emergency trauma call carries substantial liability and clinical burden. Under national FMV benchmarks, surgical subspecialty call coverage requires dedicated daily stipends above base salary rather than uncompensated mandatory days."`
  },
  {
    id: "clause-unilateral-amendment",
    name: "Unilateral Policy & Bylaw Amendments",
    category: "Governance & Contract Parity",
    riskSeverity: "Critical",
    statutoryBasis: "Contract Law / Mutuality of Obligation",
    keywords: ["unilateral amendment", "modify, amend, or alter", "updates to medical staff bylaws", "administrative handbooks", "without requiring a formal written amendment"],
    detectPattern: /(modify.*without requiring.*written amendment|bound by all such updates|unilateral.*bylaws|reserves the right to modify.*policies)/i,
    riskExplanation: "Allows the hospital to unilaterally cut wRVU conversion factors, increase call requirements, or alter clinical schedules simply by issuing an 'updated administrative policy' or bylaw amendment without your signed consent.",
    legalStandard: "Material terms of physician employment (compensation, clinical hours, call requirements, vacation) must require mutual written amendment signed by both parties.",
    recommendedRedline: `RECOMMENDED REDLINE REPLACEMENT:
"7. MUTUAL WRITTEN AMENDMENT REQUIRED:
This Agreement contains the entire understanding between the parties. No amendment, modification, or change to compensation formulas, productivity expectations, clinical hours, or call coverage obligations shall be valid or binding unless set forth in a formal written amendment executed and signed by both Physician and an authorized executive of Hospital."`,
    negotiationScript: `"A binding employment contract cannot permit one party to unilaterally alter compensation metrics or clinical expectations through administrative handbook updates. All changes to material terms must require mutual signed written agreement."`
  },
  {
    id: "clause-indemnification",
    name: "Physician Indemnification of Hospital",
    category: "Liability & Risk Shifting",
    riskSeverity: "Critical",
    statutoryBasis: "Employer Vicarious Liability & Respondeat Superior",
    keywords: ["defend, indemnify, and hold harmless", "indemnification", "indemnify hospital", "arising out of employee's clinical"],
    detectPattern: /(defend,\s*indemnify|indemnify.*hospital|hold harmless.*hospital.*clinical)/i,
    riskExplanation: "Attempts to shift corporate vicarious liability, hospital billing errors, and defense costs from the health system onto the individual employed physician.",
    legalStandard: "Under the doctrine of Respondeat Superior, the hospital employer is vicariously liable for the acts of its employed physicians within the scope of employment. Individual indemnification clauses must be struck entirely.",
    recommendedRedline: `RECOMMENDED REDLINE REPLACEMENT:
"8. MUTUAL INDEMNITY / SCOPE OF EMPLOYMENT:
[STRIKE ENTIRELY PHYSICIAN INDEMNIFICATION].
Hospital shall defend, indemnify, and hold harmless Physician from and against any and all claims, liabilities, judgments, and legal expenses arising out of Physician's provision of clinical services within the authorized scope of employment under this Agreement."`,
    negotiationScript: `"As an employed physician, the health system carries vicarious liability for clinical services under standard respondeat superior principles. Employed physicians do not indemnify their hospital employers. This clause must be stricken in its entirety."`
  },
  {
    id: "clause-clawback",
    name: "Retroactive Base Salary Clawbacks",
    category: "Compensation Security",
    riskSeverity: "High",
    statutoryBasis: "Wage Payment Laws (Washington RCW 49.48) & Stark Law",
    keywords: ["retroactively adjust", "claw back", "clawback", "fails to achieve the annual wrvu threshold"],
    detectPattern: /(claw\s*back|retroactively adjust.*salary|fails to achieve.*wrvu.*claw)/i,
    riskExplanation: "Allows the hospital to retroactively reduce or demand repayment of guaranteed base compensation if hospital volumes or OR availability prevent meeting high wRVU targets.",
    legalStandard: "Guaranteed base compensation should not be subject to retroactive clawbacks due to external factors (OR delays, staffing shortages, referral changes). Production shortfalls should adjust prospective bonuses only.",
    recommendedRedline: `RECOMMENDED REDLINE REPLACEMENT:
"2. BASE SALARY SECURITY & INCENTIVE COMPENSATION:
Hospital shall pay Physician a guaranteed base salary of $650,000 per annum, paid in bi-weekly installments, which shall not be subject to reduction or retroactive clawback. For all wRVUs performed in excess of 8,500 wRVUs per annum, Hospital shall pay Physician an incentive bonus of $91.50 per wRVU, reconciled and paid quarterly."`,
    negotiationScript: `"Base salary represents the guaranteed baseline for clinical availability. Production variations caused by OR staffing or bed shortages should impact incentive bonuses only, never subject base salary to retroactive clawbacks."`
  }
];

export function analyzeContractText(rawText) {
  if (!rawText || rawText.trim().length === 0) {
    return {
      totalClausesAnalyzed: 0,
      flaggedClauses: [],
      overallGrade: "N/A",
      riskSummary: "No contract text provided."
    };
  }

  const flagged = [];

  CONTRACT_CLAUSE_RULES.forEach(rule => {
    let isMatched = false;
    if (rule.detectPattern && rule.detectPattern.test(rawText)) {
      isMatched = true;
    } else if (rule.keywords && rule.keywords.some(kw => rawText.toLowerCase().includes(kw.toLowerCase()))) {
      isMatched = true;
    }

    if (isMatched) {
      flagged.push({
        id: rule.id,
        name: rule.name,
        category: rule.category,
        riskSeverity: rule.riskSeverity,
        statutoryBasis: rule.statutoryBasis,
        riskExplanation: rule.riskExplanation,
        legalStandard: rule.legalStandard,
        recommendedRedline: rule.recommendedRedline,
        negotiationScript: rule.negotiationScript
      });
    }
  });

  let overallGrade = "A";
  let gradeColor = "emerald";
  let riskSummary = "Contract contains favorable physician-protective terms with minimal regulatory traps.";

  const criticalCount = flagged.filter(f => f.riskSeverity === "Critical").length;
  const highCount = flagged.filter(f => f.riskSeverity === "High").length;

  if (criticalCount >= 2 || (criticalCount >= 1 && highCount >= 2)) {
    overallGrade = "F";
    gradeColor = "rose";
    riskSummary = `Severe Contract Vulnerability: ${flagged.length} major red flags identified including ${criticalCount} critical traps (e.g. 100% tail liability, indemnification, or unilateral changes). Comprehensive redline renegotiation mandatory before signing.`;
  } else if (criticalCount === 1 || highCount >= 2) {
    overallGrade = "C-";
    gradeColor = "amber";
    riskSummary = `Moderate Risk Exposure: ${flagged.length} significant clauses require renegotiation (tail allocation, non-compete scope, or notice window parity).`;
  } else if (highCount === 1) {
    overallGrade = "B";
    gradeColor = "blue";
    riskSummary = "Minor Contract Adjustments Recommended: Contract is generally solid but contains 1-2 standard clauses that should be refined for optimal physician protection.";
  }

  return {
    totalClausesAnalyzed: CONTRACT_CLAUSE_RULES.length,
    flaggedCount: flagged.length,
    flaggedClauses: flagged,
    overallGrade,
    gradeColor,
    riskSummary
  };
}
