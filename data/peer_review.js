/**
 * MDEsq - Hospital Peer Review, Credentialing & Summary Suspension Defense
 * Health Care Quality Improvement Act (HCQIA - 42 U.S.C. § 11101),
 * Washington RCW 70.41.200 QA privilege, and Sham Peer Review detection.
 */

export const PEER_REVIEW_DEFENSE_GUIDE = [
  {
    topic: "Emergency Summary Suspension Protocol",
    urgency: "Immediate (Day 1)",
    statutoryBasis: "HCQIA 42 U.S.C. § 11112(c) / Hospital Medical Staff Bylaws",
    protocol: [
      "1. Immediate Privilege Check: Confirm whether suspension is 'precautionary' (<14 days) or formal summary suspension.",
      "2. 14-Day Mandatory Due Process Window: Under standard bylaws and HCQIA, the hospital must provide an evidentiary hearing or review within 14-30 days.",
      "3. Beware of Voluntary Resignation: NEVER resign or relinquish clinical privileges while under investigation or suspension. Resignation while under investigation triggers MANDATORY adverse reporting to the National Practitioner Data Bank (NPDB) that permanently impacts medical licensing in all 50 states.",
      "4. Demand Complete Patient Chart: Secure complete unredacted certified EMR files and nursing records for the cases in question.",
      "5. Retain Independent Healthcare Counsel: Hospital-assigned attorneys represent the hospital corporation, NOT you."
    ]
  },
  {
    topic: "Sham / Bad Faith Peer Review Identification",
    urgency: "High Vigilance",
    statutoryBasis: "Antitrust / Tortious Interference / Breach of Medical Staff Bylaws",
    protocol: [
      "Economic Retaliation Flag: Did the peer review start shortly after you complained about unsafe hospital staffing, surgical instrument sterilization, or started a competing surgical center?",
      "Competitor Bias: Are the reviewing committee members direct economic competitors in your same subspecialty in the same geographic catchment area?",
      "Procedural Violations: Did administration bypass the Medical Staff Bylaws, deny you the right to introduce expert rebuttal testimony, or refuse to disclose the identity of the complaining party?",
      "External Independent Review: Demand that all clinical charts be evaluated by an independent, out-of-state, academic specialist rather than local competitors."
    ]
  },
  {
    topic: "Medical Records Subpoena vs. HIPAA Protocol",
    urgency: "Legal Compliance",
    statutoryBasis: "HIPAA 45 CFR § 164.512 / RCW 70.02 (Washington Healthcare Information Act)",
    protocol: [
      "Attorney Subpoena != Court Order: An ordinary subpoena signed by a plaintiff/defense attorney is NOT sufficient under HIPAA to disclose psychotherapy notes, substance abuse, or full medical charts without a signed patient HIPAA release or a formal Protective Order.",
      "Judge-Signed Court Order: A subpoena signed by a Judge or Administrative Law Judge mandates compliance, but only to the 'Minimum Necessary' scope defined in the order.",
      "Grand Jury / Law Enforcement: Requires verification of valid investigative authority before disclosure.",
      "Action Step: Immediately route all third-party records requests to your malpractice carrier's risk management or your healthcare counsel."
    ]
  }
];
