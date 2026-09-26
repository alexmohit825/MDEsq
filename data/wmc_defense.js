/**
 * MDEsq - Washington Medical Commission (WMC) Defense & Due Process Hub
 * Washington Uniform Disciplinary Act (RCW 18.130), Medical Practice Act (RCW 18.71),
 * WAC 246-919, Letter of Cooperation Response Protocol, and STID Protection.
 */

export const WMC_PHASES = [
  {
    phase: 1,
    title: "Complaint Intake & 14-Day Initial Assessment",
    duration: "Day 0 – 14",
    leadEntity: "WMC Case Management Committee (CMC)",
    description: "Every complaint received by the Commission is reviewed by a panel of commissioners (physicians and public members) to determine if the allegations, if true, would constitute a violation of the Uniform Disciplinary Act (RCW 18.130.180).",
    potentialOutcomes: [
      "Immediate Closure (No jurisdictional violation or frivolous)",
      "Authorization of Formal Investigation & Subpoena"
    ],
    tacticalPriority: "Do not contact the complainant or patient. Contact your malpractice carrier immediately to assign experienced healthcare regulatory defense counsel."
  },
  {
    phase: 2,
    title: "Formal Investigation & Letter of Cooperation",
    duration: "Month 1 – 6",
    leadEntity: "WMC Staff Investigator & Clinical Consultant",
    description: "An investigator is assigned to interview witnesses, subpoena complete medical records, and obtain a formal written response (Letter of Cooperation) from the physician under RCW 18.130.230.",
    potentialOutcomes: [
      "Submission of comprehensive physician narrative and medical records",
      "Independent clinical review by a WMC proctor/consultant"
    ],
    tacticalPriority: "Demand the complete certified chart, nursing notes, and imaging before writing a single word. NEVER submit an unvetted narrative or speculative recollection."
  },
  {
    phase: 3,
    title: "CMC Threshold Review & Disposition Determination",
    duration: "Month 4 – 8",
    leadEntity: "WMC Reviewing Panel",
    description: "The investigating panel reviews the completed investigation report, physician response, and expert consultant assessment to make a formal threshold determination.",
    potentialOutcomes: [
      "1. Case Closed (No violation found)",
      "2. Letter of Concern (Non-disciplinary advisory notice; NOT reportable to NPDB)",
      "3. Authorization of Formal Disciplinary Charges (Statement of Charges)"
    ],
    tacticalPriority: "If non-severe issues are noted, defense counsel advocates aggressively for closure with a Letter of Concern or informal educational resolution."
  },
  {
    phase: 4,
    title: "Stipulation to Informal Disposition (STID) Settlement",
    duration: "Month 6 – 10",
    leadEntity: "Physician Counsel & Commission Staff Attorney",
    description: "Under RCW 18.130.172, if minor practice deficiencies are identified, the physician and Commission may negotiate a Stipulation to Informal Disposition (STID).",
    potentialOutcomes: [
      "Agreed targeted CME, chart proctoring, or ethics course",
      "NON-DISCIPLINARY resolution — Not considered a disciplinary finding of unprofessional conduct"
    ],
    tacticalPriority: "Ensure the STID does NOT contain any practice restrictions to prevent mandatory adverse reporting to the National Practitioner Data Bank (NPDB)."
  },
  {
    phase: 5,
    title: "Statement of Charges & OAH Administrative Hearing",
    duration: "Month 9 – 18+",
    leadEntity: "Office of Administrative Hearings (ALJ) & WMC Panel",
    description: "If settlement fails or severe allegations exist (e.g. boundary violations, gross incompetence, substance impairment), the Commission files a public Statement of Charges. A formal evidentiary trial is conducted before an Administrative Law Judge (ALJ).",
    potentialOutcomes: [
      "Dismissal of Charges / Exoneration",
      "Final Order with Sanctions (Probation, Suspension, Revocation)"
    ],
    tacticalPriority: "Under Washington law, the Commission carries the heavy legal burden of proving unprofessional conduct by Clear, Cogent, and Convincing Evidence."
  }
];

export const WMC_RESPONSE_RULES = [
  {
    ruleNum: 1,
    title: "The Certified Record Pre-Condition",
    summary: "Never write or submit an initial response to a WMC Letter of Cooperation based purely on memory from a case that occurred months or years ago.",
    rationale: "Discrepancies between your memory and the electronic medical record audit trail will be cited by the investigator as proof of dishonesty or deficient charting under RCW 18.130.180(1)."
  },
  {
    ruleNum: 2,
    title: "Objective Chronological Narrative",
    summary: "Structure your response as a calm, objective, chronological narrative anchored strictly to timestamped entries in the medical record.",
    rationale: "Avoid defensive prose, sarcasm, or emotional attacks on the patient or family. The reviewing commissioners respect professional, dignified clinical explanations."
  },
  {
    ruleNum: 3,
    title: "Standard of Care Affirmation (RCW 18.71)",
    summary: "Explicitly articulate the clinical rationale for each diagnostic and surgical decision, tying your choices directly to established clinical guidelines and standard of care.",
    rationale: "Demonstrates that the clinical outcome was a recognized, unavoidable risk of a complex pathology rather than a failure of medical judgment."
  },
  {
    ruleNum: 4,
    title: "Remediation & Quality Improvement Reflection",
    summary: "If a documentation ambiguity or minor system delay occurred, describe the proactive quality improvement steps or CME you have completed since the incident.",
    rationale: "The Commission's primary mandate is patient safety and remediation. Demonstrating proactive professional growth frequently converts potential charges into a confidential Letter of Concern."
  },
  {
    ruleNum: 5,
    title: "Mandatory Counsel Clearance",
    summary: "Every paragraph of your written submission must be reviewed, edited, and approved by healthcare legal counsel experienced before the Washington Medical Commission.",
    rationale: "Initial written statements to the WMC constitute binding party admissions that cannot be retracted in subsequent administrative or civil proceedings."
  }
];

export const WMC_PHRASE_DISRUPTER = [
  {
    fatalPhrase: "I admit I was rushed that day because the hospital operating rooms were running behind schedule.",
    whyFatal: "Direct admission of compromised standard of care and negligence under RCW 18.130.180(4).",
    masterResponse: "The surgical procedure was performed following standard preoperative verification and safety checks, with meticulous attention to surgical hemostasis and patient stability throughout the case."
  },
  {
    fatalPhrase: "The floor nurses failed to inform me of the patient's deteriorating condition.",
    whyFatal: "Blaming nursing staff without documentation makes the surgeon appear unaccountable to the Commission panel.",
    masterResponse: "Based on the vital signs, sensory checks, and clinical data communicated to me during the post-operative window, the clinical presentation remained stable and consistent with the established recovery protocol."
  },
  {
    fatalPhrase: "I usually perform this step during surgery, even if I forgot to dictate it in the operative note.",
    whyFatal: "Concedes a documentation violation under WAC 246-919-601 and invites the Commission to assume the step was omitted.",
    masterResponse: "My customary surgical practice is reflected in the contemporaneous clinical record, which documents patient tolerance and immediate post-operative neurological status."
  }
];

export const WMC_SANCTION_HIERARCHY = [
  {
    sanction: "Closure with No Action",
    severity: "None (Exoneration)",
    publicRecord: "No (Confidential)",
    npdbReportable: false,
    clinicalImpact: "Complete dismissal of complaint with zero licensure impact."
  },
  {
    sanction: "Letter of Concern (LOC)",
    severity: "Advisory / Non-Disciplinary",
    publicRecord: "No (Confidential)",
    npdbReportable: false,
    clinicalImpact: "Non-disciplinary educational guidance. License remains 100% unencumbered and clean."
  },
  {
    sanction: "Stipulation to Informal Disposition (STID)",
    severity: "Informal Remediation",
    publicRecord: "Yes (WMC Website)",
    npdbReportable: false,
    clinicalImpact: "Non-disciplinary agreement (RCW 18.130.172). Targeted CME or chart review; protects from NPDB report."
  },
  {
    sanction: "Agreed Order / Formal Reprimand",
    severity: "Formal Disciplinary Action",
    publicRecord: "Yes (Public Discipline)",
    npdbReportable: true,
    clinicalImpact: "Formal finding of unprofessional conduct. Triggers NPDB report, hospital re-credentialing scrutiny, and interstate board notifications."
  },
  {
    sanction: "Summary Suspension / License Revocation",
    severity: "Maximum Disciplinary Sanction",
    publicRecord: "Yes (Immediate Public Order)",
    npdbReportable: true,
    clinicalImpact: "Immediate cessation of clinical practice. Requires Washington Superior Court emergency appeal or formal OAH trial."
  }
];
