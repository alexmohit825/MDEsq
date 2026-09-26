/**
 * MDEsq - Medical Malpractice Litigation Lifecycle & Insurance Strategy
 * Stages of litigation, Consent-to-Settle vs Hammer Clause, and trial defense tactics.
 */

export const MALPRACTICE_LITIGATION_STAGES = [
  {
    step: 1,
    stage: "Notice of Intent to Sue / Pre-Suit Demand",
    duration: "Day 0 – Month 2",
    description: "Plaintiff's attorney sends a formal letter or records request signaling intent to file a lawsuit. In Washington, RCW 7.70.100 voluntary mediation notice is often served.",
    physicianAction: "Notify malpractice carrier immediately in writing. Do NOT contact the patient, family, or plaintiff counsel. Preserve all operative videos, intraop imaging, and EMR audit logs."
  },
  {
    step: 2,
    stage: "Summons & Complaint Filed in Superior Court",
    duration: "Month 1 – Month 3",
    description: "Lawsuit is formally filed alleging breach of standard of care (RCW 7.70.040), failure of informed consent (RCW 7.70.050), and damages.",
    physicianAction: "Defense counsel is appointed by your carrier. File a formal Answer denying negligence. Insist on a preliminary case conference to review allegations."
  },
  {
    step: 3,
    stage: "Written Discovery & Interrogatories",
    duration: "Month 3 – Month 9",
    description: "Exchange of written interrogatories, requests for production of medical records, emails, billing logs, and requests for admission.",
    physicianAction: "Carefully review all written responses with defense counsel before signing verification. Verify all dates, CME credentials, and billing records."
  },
  {
    step: 4,
    stage: "Depositions (Fact Witnesses & Treating Doctors)",
    duration: "Month 8 – Month 15",
    description: "Oral testimony under oath of the defendant physician, plaintiff, nurses, surgical techs, and consulting specialists.",
    physicianAction: "Engage in extensive mock deposition preparation with defense counsel. Master the 10 Cardinal Deposition Rules and Reptile Theory defenses."
  },
  {
    step: 5,
    stage: "Expert Witness Disclosure & Standard of Care Reports",
    duration: "Month 12 – Month 18",
    description: "Both sides disclose retained expert witnesses (in Washington, experts must be licensed healthcare providers in the same or related field under RCW 7.70.040).",
    physicianAction: "Assist defense counsel in reviewing the plaintiff expert witness's CV, past trial transcripts, and medical literature to expose factual flaws."
  },
  {
    step: 6,
    stage: "Mediation & Mandatory Settlement Conference",
    duration: "Month 16 – Month 22",
    description: "Non-binding negotiation before a retired judge or experienced malpractice mediator to explore resolution.",
    physicianAction: "Evaluate carrier's settlement posture vs. trial risk. Review 'Consent to Settle' provisions in your policy."
  },
  {
    step: 7,
    stage: "Jury Trial in Superior Court",
    duration: "Month 18 – Month 30+",
    description: "Voir dire, opening statements, direct/cross examinations, expert testimony, closing arguments, and jury verdict.",
    physicianAction: "Maintain daily courtroom presence, professional demeanor, attentive non-verbal cues, and complete confidence in standard of care delivered."
  }
];

export const MALPRACTICE_INSURANCE_TACTICS = [
  {
    topic: "Consent to Settle Clause vs. The Hammer Clause",
    analysis: "A true 'Consent to Settle' clause prevents your malpractice carrier from settling a claim without your written permission. However, beware of the 'Hammer Clause' (or Pride Clause). If the carrier recommends a settlement that you reject, and a subsequent trial verdict exceeds that settlement amount, you may be personally liable for the difference! Always verify your exact policy language."
  },
  {
    topic: "Claims-Made vs. Occurrence Policies",
    analysis: "Occurrence policies cover any incident that happened while the policy was active, regardless of when the lawsuit is filed. Claims-made policies ONLY cover incidents if the policy is active both when the event happened AND when the lawsuit is filed — necessitating 'Tail Insurance' (Extended Reporting Endorsement) when you leave an employer."
  },
  {
    topic: "Independent / Personal Cumis Counsel",
    analysis: "If the malpractice insurer issues a 'Reservation of Rights' letter (indicating potential denial of coverage for certain claims), you may have the legal right under state insurance law to retain independent 'Cumis' counsel paid for by the insurer to protect your personal interests."
  }
];
