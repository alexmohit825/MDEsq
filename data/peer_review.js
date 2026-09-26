/**
 * MDEsq - Comprehensive Hospital Peer Review & Summary Suspension Defense Hub
 * Health Care Quality Improvement Act (HCQIA - 42 U.S.C. § 11101),
 * Washington RCW 70.41.200 QA privilege, Sham Peer Review 10-Factor Index,
 * and 30-Day Emergency Suspension Playbook.
 */

export const SHAM_PEER_REVIEW_FACTORS = [
  {
    id: "factor-whistleblower",
    title: "1. Prior Protected Quality/Safety Whistleblowing",
    weight: 15,
    description: "Did the peer review investigation initiate within 12 months after you raised patient safety concerns, surgical instrument defects, or inadequate hospital staffing?",
    evidenceRequired: "Contemporaneous emails, incident logs, or staff meeting minutes documenting your safety complaints prior to the peer review."
  },
  {
    id: "factor-competitor-bias",
    title: "2. Economic Competitor on Review Committee",
    weight: 15,
    description: "Are members of the ad hoc peer review committee or Medical Executive Committee (MEC) direct economic competitors in your surgical subspecialty in the same local geographic catchment area?",
    evidenceRequired: "Medical staff roster showing specialty overlap and referral competition."
  },
  {
    id: "factor-procedural-bypass",
    title: "3. Bylaws & Progressive Discipline Bypassed",
    weight: 10,
    description: "Did hospital administration bypass intermediate remedies (proctoring, focused review, informal meeting) and proceed directly to summary suspension or hostile investigation?",
    evidenceRequired: "Hospital Medical Staff Bylaws showing mandatory step-by-step disciplinary escalation was skipped."
  },
  {
    id: "factor-record-denial",
    title: "4. Denial of Complete Medical Records & EMR Audit Trail",
    weight: 10,
    description: "Did the hospital deny or delay your access to the complete, unredacted medical charts, nursing notes, and EMR audit trail for the cases under scrutiny?",
    evidenceRequired: "Formal written requests for charts and hospital refusal or delayed responses."
  },
  {
    id: "factor-external-denial",
    title: "5. Refusal of Independent External Academic Review",
    weight: 10,
    description: "Did the MEC refuse your request to submit the clinical cases to an independent, out-of-state academic specialist, insisting only on local or anonymous internal reviews?",
    evidenceRequired: "Written request for external independent review and committee rejection."
  },
  {
    id: "factor-disparate-treatment",
    title: "6. Selective Enforcement & Disparate Treatment",
    weight: 10,
    description: "Are other hospital-employed or administration-favored physicians with identical or higher complication rates not subjected to peer review scrutiny?",
    evidenceRequired: "Hospital-wide surgical morbidity/mortality statistics or department quality dashboards."
  },
  {
    id: "factor-ex-parte",
    title: "7. Secret Ex-Parte Communications with Administration / C-Suite",
    weight: 10,
    description: "Are hospital corporate administrators (CEO, COO, General Counsel) actively directing or attending peer review committee deliberations behind closed doors?",
    evidenceRequired: "Meeting minutes, attendance logs, and administrative directives."
  },
  {
    id: "factor-metric-shift",
    title: "8. Mid-Cycle Alteration of Credentialing / FPPE Metrics",
    weight: 5,
    description: "Were volume thresholds, proctoring requirements, or FPPE/OPPE criteria modified mid-cycle specifically to target your surgical practice?",
    evidenceRequired: "Previous credentialing criteria vs. newly enacted retroactive thresholds."
  },
  {
    id: "factor-resignation-coercion",
    title: "9. Coercion to 'Voluntarily Resign' (NPDB Trap)",
    weight: 10,
    description: "Did department chairs or administrators suggest you 'quietly resign' your privileges to make the matter go away, without warning that resignation under inquiry triggers mandatory federal NPDB reporting?",
    evidenceRequired: "Documented conversations, emails, or separation proposals from hospital leadership."
  },
  {
    id: "factor-counsel-denial",
    title: "10. Denial of Legal Representation or Court Reporter at Fair Hearing",
    weight: 5,
    description: "Did the hospital attempt to prohibit your healthcare defense attorney from participating or refuse to allow a certified court reporter to transcribe the Fair Hearing?",
    evidenceRequired: "Notice of hearing restricting counsel role or prohibiting official transcription."
  }
];

export const SUMMARY_SUSPENSION_PLAYBOOK = [
  {
    dayRange: "Day 0 – 3: The Immediate Crisis Phase",
    phaseTitle: "Privilege Preservation & Record Locking",
    color: "rose",
    criticalActions: [
      "1. Verify Precautionary vs. Summary: Obtain written confirmation whether suspension is a brief precautionary pause (<14 days) or formal summary suspension.",
      "2. DO NOT RESIGN: Resigning privileges while under investigation or suspension results in mandatory federal NPDB reporting that permanently blemishes your license in all 50 states.",
      "3. Secure Medical Records: Demand an immediate certified electronic copy of all charts, operative logs, radiology, and EMR audit trails before your hospital IT credentials are deactivated.",
      "4. Retain Independent Healthcare Counsel: Retain private counsel experienced in Medical Staff Bylaws and HCQIA. Hospital legal counsel represents the corporate entity, not the physician."
    ]
  },
  {
    dayRange: "Day 4 – 14: The Due Process & Hearing Demand Phase",
    phaseTitle: "Invoking HCQIA 14-Day Hearing Rights",
    color: "amber",
    criticalActions: [
      "1. Timely Demand for Fair Hearing: Deliver formal written demand for a hearing under the Medical Staff Bylaws within the strict window (typically 14-30 days).",
      "2. Challenge Hearing Panel Bias: Scrutinize the proposed hearing panel for economic competitors, personal animus, or subordinate hospital employees.",
      "3. Request Immediate Retraction / Modification: Submit a formal defense memorandum showing why continuation of summary suspension lacks clinical basis of 'imminent danger' under HCQIA 42 U.S.C. § 11112(c).",
      "4. Engage Out-of-State Independent Expert: Commission an expedited blind peer review from a board-certified academic subspecialist."
    ]
  },
  {
    dayRange: "Day 15 – 29: The 30-Day NPDB Reporting Cliff",
    phaseTitle: "Avoiding the Federal 30-Day Reporting Trigger",
    color: "purple",
    criticalActions: [
      "1. The 30-Day Federal Mandate: Under 45 CFR Part 60 and HCQIA, any professional review action that restricts clinical privileges for MORE THAN 30 DAYS must be reported to the NPDB.",
      "2. Negotiate Non-Reportable Interim Resolution: Before Day 30, negotiate a temporary leave of absence for CME/training or voluntary proctoring agreement WITHOUT restriction of privileges.",
      "3. Conduct the Evidentiary Hearing: Present expert testimony, clinical literature, and cross-examine hospital witnesses before the hearing panel."
    ]
  },
  {
    dayRange: "Day 30+: Post-Hearing & Superior Court Injunction",
    phaseTitle: "Appellate Review & Judicial Injunctions",
    color: "blue",
    criticalActions: [
      "1. Hearing Panel Findings: Review the written report of the Hearing Committee; if favorable, demand immediate MEC reinstatement.",
      "2. Appellate Review to Board of Trustees: If adverse, file immediate appeal to the hospital Board of Trustees alleging material procedural violations.",
      "3. Superior Court Injunction: File an emergency motion for Temporary Restraining Order (TRO) and Preliminary Injunction in Washington Superior Court for breach of medical staff contract/bylaws."
    ]
  }
];

export const NPDB_REPORTING_MATRIX = [
  {
    action: "Hospital Summary Suspension lasting >30 Days",
    reportable: true,
    authority: "HCQIA § 423 / 45 CFR § 60.12",
    consequence: "Permanent federal record accessible by all state licensing boards, credentialing committees, and health plans."
  },
  {
    action: "Voluntary Resignation or Surrender of Privileges while under Investigation",
    reportable: true,
    authority: "HCQIA § 423(a)(1)(B)",
    consequence: "Reported as an adverse action for surrender while under inquiry; severe red flag on all future credentialing."
  },
  {
    action: "Medical Malpractice Settlement or Jury Verdict (Any Dollar Amount)",
    reportable: true,
    authority: "45 CFR § 60.7",
    consequence: "Mandatory report filed by malpractice insurance carrier within 30 days of payment."
  },
  {
    action: "Precautionary Suspension Lifted or Resolved in <30 Days",
    reportable: false,
    authority: "NPDB Guidebook Chapter E",
    consequence: "NO NPDB REPORT required. Privileges restored without national blemish."
  },
  {
    action: "Voluntary Proctoring or Second-Opinion Agreement (No Loss of Privileges)",
    reportable: false,
    authority: "NPDB Guidebook Chapter E",
    consequence: "NO NPDB REPORT as long as the physician retains the legal authority to exercise full privileges."
  },
  {
    action: "WMC Letter of Concern or Non-Disciplinary Educational Notice",
    reportable: false,
    authority: "RCW 18.130.172 / NPDB Chapter E",
    consequence: "NO NPDB REPORT. Retains confidential non-disciplinary status."
  }
];
