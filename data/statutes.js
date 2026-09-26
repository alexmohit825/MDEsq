/**
 * MDEsq - Curated Statutory & Case Law Database
 * Washington State Medical Practice Act, Tort Reform, Non-Competes & Federal Statutes
 */

export const JURISDICTIONS = {
  WA: {
    name: "Washington State",
    abbr: "WA",
    medicalBoard: "Washington Medical Commission (WMC)",
    medicalBoardUrl: "https://wmc.wa.gov",
    nonCompeteStatus: "Statutory Ceiling & Salary Threshold (RCW 49.62)",
    tortCapStatus: "None for Non-Economic Damages (Sofie v. Fibreboard Corp. 1989)",
    informedConsentStandard: "Material Risk / Reasonable Patient Standard (RCW 7.70.050)",
    statuteOfLimitations: "3 years from act/omission OR 1 year from discovery, max 8 years (RCW 7.70.020)",
    statutes: [
      {
        id: "rcw-18-71",
        code: "RCW 18.71",
        title: "Physicians and Surgeons (Medical Practice Act)",
        category: "Licensing & Practice",
        summary: "Defines the scope of medical practice, licensure requirements, retired active licenses, and fundamental obligations of licensed physicians in Washington.",
        url: "https://app.leg.wa.gov/rcw/default.aspx?cite=18.71",
        keyTakeaway: "Establishes the authority of the Washington Medical Commission and grounds for mandatory license maintenance."
      },
      {
        id: "rcw-18-130",
        code: "RCW 18.130",
        title: "Uniform Disciplinary Act (UDA)",
        category: "Board Defense",
        summary: "Governs all disciplinary investigations, summary suspensions, standard of proof, and sanction protocols across Washington health professions.",
        url: "https://app.leg.wa.gov/rcw/default.aspx?cite=18.130",
        keyTakeaway: "Defines unprofessional conduct (§ 18.130.180) and specifies procedural due process rights for physicians facing board complaints."
      },
      {
        id: "wac-246-919",
        code: "WAC 246-919",
        title: "Washington Medical Commission Regulations",
        category: "Administrative Rules",
        summary: "Detailed administrative rules for physician supervision, CME requirements, pain management standards, chaperone guidelines, and office-based surgical anesthesia.",
        url: "https://app.leg.wa.gov/wac/default.aspx?cite=246-919",
        keyTakeaway: "Mandates exact compliance standards for clinical documentation, prescribing protocols, and physician-PA delegation agreements."
      },
      {
        id: "rcw-7-70",
        code: "RCW 7.70",
        title: "Actions for Injuries Resulting from Health Care",
        category: "Medical Malpractice",
        summary: "Washington's exclusive statutory vehicle for medical malpractice claims, defining standard of care, proximate cause, and informed consent.",
        url: "https://app.leg.wa.gov/rcw/default.aspx?cite=7.70",
        keyTakeaway: "Section 7.70.040 establishes that standard of care is that of an ordinarily prudent health care provider in Washington in the same field."
      },
      {
        id: "rcw-7-70-050",
        code: "RCW 7.70.050",
        title: "Failure to Secure Informed Consent",
        category: "Medical Malpractice",
        summary: "Statutory 4-part test for informed consent claims: duty to disclose material facts, alternative treatments, patient would have chosen differently, and injury resulted.",
        url: "https://app.leg.wa.gov/rcw/default.aspx?cite=7.70.050",
        keyTakeaway: "Requires documenting discussion of recognized material risks and viable alternative treatments; blanket consent forms are legally insufficient."
      },
      {
        id: "rcw-49-62",
        code: "RCW 49.62",
        title: "Non-competition Covenants",
        category: "Contracts & Employment",
        summary: "Strict statutory restrictions on non-compete agreements in Washington. Void unless employee earnings exceed statutory threshold (adjusted annually for inflation), max 18-month duration presumption, and moonlighting protections.",
        url: "https://app.leg.wa.gov/rcw/default.aspx?cite=49.62",
        keyTakeaway: "If an employer enforces an invalid non-compete, the physician is statutorily entitled to statutory damages plus mandatory attorney fees (RCW 49.62.080)."
      },
      {
        id: "rcw-70-41-200",
        code: "RCW 70.41.200",
        title: "Hospital Quality Improvement & Peer Review Privilege",
        category: "Peer Review",
        summary: "Confers robust statutory privilege and confidentiality on hospital peer review proceedings and quality improvement committee records.",
        url: "https://app.leg.wa.gov/rcw/default.aspx?cite=70.41.200",
        keyTakeaway: "Peer review committee files and deliberations are immune from discovery in civil malpractice actions, protecting candid internal reviews."
      }
    ],
    landmarkCases: [
      {
        citation: "Sofie v. Fibreboard Corp., 112 Wn.2d 636 (1989)",
        topic: "Tort Reform / Damage Caps",
        holding: "Washington Supreme Court struck down statutory non-economic damages caps as an unconstitutional violation of the right to jury trial under Article I, Section 21 of the WA Constitution.",
        significance: "Washington has no statutory ceiling on pain and suffering / non-economic damages in medical malpractice cases."
      },
      {
        citation: "Keogan v. Holy Family Hospital, 95 Wn.2d 306 (1980)",
        topic: "Informed Consent & Diagnostic Testing",
        holding: "Physicians have a duty to inform patients of diagnostic tests available to rule out suspected life-threatening conditions (e.g. cardiac ischemia).",
        significance: "Documenting recommendations for diagnostic testing and patient declinations is legally mandatory."
      },
      {
        citation: "Miller v. Kennedy, 11 Wn. App. 272 (1974) / RCW 7.70.050",
        topic: "Informed Consent Standard",
        holding: "Established the 'prudent patient' standard for informed consent disclosure rather than purely what other physicians customary disclose.",
        significance: "Physicians must disclose what a reasonable person in the patient's position would attach significance to in making a treatment decision."
      }
    ]
  },
  CA: {
    name: "California",
    abbr: "CA",
    medicalBoard: "Medical Board of California (MBC)",
    medicalBoardUrl: "https://www.mbc.ca.gov",
    nonCompeteStatus: "100% Void & Unenforceable (Cal. Bus. & Prof. Code § 16600 & AB 1076 / SB 699)",
    tortCapStatus: "MICRA AB 35 Modified Cap: $350k (non-death, rising to $750k) / $500k (wrongful death, rising to $1M)",
    informedConsentStandard: "Cobbs v. Grant Reasonable Patient Standard",
    statuteOfLimitations: "3 years from injury or 1 year from discovery (CCP § 340.5)"
  },
  TX: {
    name: "Texas",
    abbr: "TX",
    medicalBoard: "Texas Medical Board (TMB)",
    medicalBoardUrl: "https://www.tmb.state.tx.us",
    nonCompeteStatus: "Enforceable only with statutory buyout clause & patient list access (Tex. Bus. & Com. Code § 15.50(b))",
    tortCapStatus: "Statutory Cap: $250k per physician / $500k per institution (Tex. Civ. Prac. & Rem. Code § 74.301)",
    informedConsentStandard: "Texas Medical Disclosure Panel (TMDP) Lists A & B",
    statuteOfLimitations: "2 years from occurrence (Tex. Civ. Prac. & Rem. Code § 74.251)"
  },
  FL: {
    name: "Florida",
    abbr: "FL",
    medicalBoard: "Florida Board of Medicine",
    medicalBoardUrl: "https://flboardofmedicine.gov",
    nonCompeteStatus: "Enforceable under Fla. Stat. § 542.335; rural county exceptions apply",
    tortCapStatus: "Caps struck down as unconstitutional (North Broward Hospital District v. Kalitan)",
    informedConsentStandard: "Florida Medical Consent Law (Fla. Stat. § 766.103)",
    statuteOfLimitations: "2 years from discovery, max 4 years statute of repose (Fla. Stat. § 95.11(4)(b))"
  },
  NY: {
    name: "New York",
    abbr: "NY",
    medicalBoard: "Office of Professional Medical Conduct (OPMC)",
    medicalBoardUrl: "https://www.health.ny.gov/professionals/doctors/conduct/",
    nonCompeteStatus: "Strict judicial scrutiny (BDO Seidman standard; must be reasonable in time/area)",
    tortCapStatus: "No statutory caps on damages",
    informedConsentStandard: "N.Y. Pub. Health Law § 2805-d (Reasonable medical practitioner standard)",
    statuteOfLimitations: "2.5 years from act or end of continuous treatment (CPLR § 214-a)"
  }
};

export const FEDERAL_REGULATIONS = [
  {
    id: "stark-law",
    title: "The Stark Law (Physician Self-Referral)",
    citation: "42 U.S.C. § 1395nn / 42 CFR § 411.350",
    category: "Federal Healthcare Compliance",
    summary: "Prohibits physicians from referring Medicare/Medicaid patients for Designated Health Services (DHS) to entities with which the physician has a financial relationship, unless an exception (e.g., bona fide employment) is met.",
    keyTakeaway: "Compensation must be set in advance, consistent with Fair Market Value (FMV), commercially reasonable, and NOT take into account volume or value of referrals."
  },
  {
    id: "aks",
    title: "Federal Anti-Kickback Statute (AKS)",
    citation: "42 U.S.C. § 1320a-7b(b)",
    category: "Federal Healthcare Compliance",
    summary: "Criminal statute prohibiting knowing and willful payment or receipt of remuneration to induce or reward patient referrals or generate business involving federal healthcare programs.",
    keyTakeaway: "Strict Safe Harbors exist (e.g. Employment Safe Harbor). Any compensation arrangement exceeding FMV raises severe AKS liability."
  },
  {
    id: "npdb",
    title: "National Practitioner Data Bank (NPDB) Reporting",
    citation: "Title IV of Public Law 99-660 (HCQIA) / 45 CFR Part 60",
    category: "Board & Hospital Credentialing",
    summary: "Federal repository tracking adverse licensure actions, clinical privilege restrictions >30 days resulting from peer review, and medical malpractice payments made on behalf of practitioners.",
    keyTakeaway: "Any hospital suspension lasting >30 days or any monetary malpractice settlement (regardless of amount) triggers mandatory federal NPDB reporting."
  },
  {
    id: "emergency-emtala",
    title: "EMTALA (Emergency Medical Treatment & Active Labor Act)",
    citation: "42 U.S.C. § 1395dd",
    category: "Emergency & On-Call Obligations",
    summary: "Requires Medicare-participating hospitals with emergency departments to provide medical screening exams and stabilizing treatment regardless of ability to pay.",
    keyTakeaway: "On-call specialist physicians listed on the hospital call roster must respond within hospital bylaws timeframes; failure to respond can result in individual physician civil monetary penalties ($119k+ per violation)."
  }
];
