/**
 * MDEsq - Deposition & Trial Testimony Masterclass
 * Tactical defense strategies, Reptile Theory countermeasures, and interactive cross-examination scenarios.
 */

export const DEPOSITION_CARDINAL_RULES = [
  {
    num: 1,
    title: "Answer ONLY the Question Asked — Zero Volunteering",
    summary: "A deposition is not a medical grand rounds or a chance to educate the plaintiff attorney. Every unprompted word gives opposing counsel free discovery and creates new lines of attack.",
    rule: "If asked 'Do you know what time it is?', the only accurate answer is 'Yes' — not 'It is 2:15 PM'.",
    tactics: "Keep answers to 'Yes', 'No', 'I don't recall', or short factual statements. Stop speaking immediately once the question is answered."
  },
  {
    num: 2,
    title: "The Mandatory 3-Second Pause",
    summary: "Always wait 3 full seconds before speaking after opposing counsel finishes asking a question.",
    rule: "This allows you to formulate a precise answer and gives your defense attorney time to formulate and voice legal objections (e.g. 'Objection, form', 'Objection, calls for speculation').",
    tactics: "Take a breath, look at your defense attorney, make sure they do not object, then answer calmly."
  },
  {
    num: 3,
    title: "Never Guess, Speculate, or Estimate",
    summary: "You are testifying under penalty of perjury. Speculation will be weaponized against you at trial as a factual admission.",
    rule: "If you do not remember an event from 3 years ago, 'I do not recall independently, but my custom and practice is reflected in my note' is legally bulletproof.",
    tactics: "Never say 'Probably', 'I guess so', or 'It might have been'. If you don't know, state: 'I do not know' or 'I do not recall'."
  },
  {
    num: 4,
    title: "Defeating the 'Reptile Theory' Safety Trap",
    summary: "Plaintiff attorneys attempt to force you into agreeing with broad, absolutist safety rules to make any complication look like negligence.",
    rule: "Never agree that medical care has 'absolute safety rules' or that a surgeon's primary duty is to 'eliminate all possible risk'. Medicine is a balance of risks vs. benefits for an individual patient.",
    tactics: "Counter broad safety questions with: 'It depends on the individual patient's clinical presentation, anatomy, and the specific surgical circumstances.'"
  },
  {
    num: 5,
    title: "Beware of Hypothetical & Strawman Scenarios",
    summary: "Opposing counsel will ask you to assume hypothetical facts that differ slightly from the actual patient case.",
    rule: "You are a treating physician/defendant, not an uncompensated expert witness on hypothetical patients.",
    tactics: "Respond: 'I cannot answer a hypothetical in the abstract without evaluating the complete clinical context of that specific patient.'"
  },
  {
    num: 6,
    title: "Do NOT Bring Your Own Notes or Unvetted Files",
    summary: "Anything you bring into the deposition room or look at to refresh your memory is subject to immediate subpoena and inspection by the plaintiff attorney.",
    rule: "Review only the defense binder curated by your defense counsel. Never write notes on the margins of medical records.",
    tactics: "Leave personal notebooks, smartphones, and unvetted literature outside the deposition room."
  },
  {
    num: 7,
    title: "Do NOT Argue, Lose Your Temper, or Act Arrogant",
    summary: "Plaintiff attorneys intentionally bait surgeons to see if they will appear combative or unsympathetic before a jury.",
    rule: "A calm, dignified, compassionate physician is impossible for a plaintiff attorney to dismantle.",
    tactics: "When the opposing attorney is aggressive or sarcastic, lower your volume, slow your cadence, and answer with quiet precision."
  },
  {
    num: 8,
    title: "The Medical Record is Your Primary Anchor",
    summary: "If a detail is in your contemporaneous operative note, stand by it firmly. If it is not in the chart, explain standard practice.",
    rule: "'My custom and practice at that stage of surgery is to always verify hemostasis before closure, which is consistent with my operative note.'",
    tactics: "If handed a medical record, read the entire page silently before answering a single question about it."
  }
];

export const REPTILE_THEORY_COUNTERMEASURES = [
  {
    id: "rep-1",
    plaintiffTrap: "Doctor, would you agree that a surgeon should never needlessly endanger a patient?",
    whyItIsATrap: "Appears harmless, but sets a trap to define any known complication as 'needless endangerment'.",
    flawedAnswer: "Of course, I agree.",
    masterDefenseResponse: "Every surgical procedure carries inherent, unavoidable risks and potential complications. A surgeon's duty is to exercise reasonable judgment and skill to balance those risks against the medical benefits for that specific patient.",
    keyPrinciple: "Reject the absolutist framing; ground the response in risk/benefit clinical judgment."
  },
  {
    id: "rep-2",
    plaintiffTrap: "Doctor, isn't it true that patient safety is always the highest priority and standard of care?",
    whyItIsATrap: "Sets up the argument that if a bad outcome occurred, 'safety' was violated.",
    flawedAnswer: "Yes, safety is always first.",
    masterDefenseResponse: "Patient care involves delivering appropriate, evidence-based treatment tailored to the individual patient's pathology, which inherently involves managing unavoidable procedural risks.",
    keyPrinciple: "Pivot from the abstract slogan 'safety is first' to individualized clinical evidence and standard of care."
  },
  {
    id: "rep-3",
    plaintiffTrap: "Doctor, if a surgeon can take a simple step to prevent a fatal or severe injury, they are obligated to do so, correct?",
    whyItIsATrap: "Forces the doctor to agree that an omitted test or maneuver was 'simple' and mandatory in hindsight.",
    flawedAnswer: "Yes, if it prevents injury.",
    masterDefenseResponse: "In surgical decision-making, no step is evaluated in isolation. Every diagnostic test or surgical maneuver has its own risks, benefits, and indications based on real-time intraoperative findings and patient stability.",
    keyPrinciple: "Defeat 20/20 hindsight bias by emphasizing real-time clinical context."
  }
];

export const MOCK_DEPOSITION_SCENARIOS = [
  {
    id: "dep-scen-1",
    specialty: "Spine / Orthopedic / Neurosurgery",
    context: "Post-operative epidural hematoma resulting in delayed motor deficit after an L4-L5 lumbar decompression.",
    question: "Doctor, if you had re-examined the patient at 2:00 AM when the nurse noted numbness instead of 6:00 AM on morning rounds, this permanent weakness could have been completely avoided, couldn't it?",
    options: [
      {
        id: "opt-a",
        text: "You might be right, looking back I probably should have gone in at 2 AM.",
        rating: "Catastrophic Concession",
        grade: "F",
        analysis: "This admits proximate causation and breach of standard of care, effectively destroying your defense at trial."
      },
      {
        id: "opt-b",
        text: "The nurse didn't tell me it was that bad, so it's the hospital nursing staff's fault, not mine.",
        rating: "Blame Shifting / Toxic",
        grade: "D",
        analysis: "Creates hostility with co-defendants, alienates the jury, and makes you look unaccountable."
      },
      {
        id: "opt-c",
        text: "I cannot speculate on hypothetical timing. Based on the mild sensory changes reported in the clinical context at 2:00 AM with stable motor function, the orders and monitoring plan were appropriate and consistent with the standard of care.",
        rating: "Master Defense Response",
        grade: "A+",
        analysis: "Refuses to speculate in hindsight, anchors on objective contemporary charting, and reinforces standard of care under RCW 7.70."
      }
    ]
  },
  {
    id: "dep-scen-2",
    specialty: "General Surgery / Surgical Oncology",
    context: "Bowel perforation diagnosed 4 days following a laparoscopic cholecystectomy / lysis of adhesions.",
    question: "Doctor, a bowel perforation does not occur during routine laparoscopic surgery unless the surgeon's instrument strays from the surgical field, correct?",
    options: [
      {
        id: "opt-a",
        text: "Yes, a careful surgeon should not perforate the bowel.",
        rating: "Fatal Res Ipsa Concession",
        grade: "F",
        analysis: "Concedes negligence as a matter of law. Bowel injury is a recognized, unavoidable risk of thermal spread and dense adhesions."
      },
      {
        id: "opt-b",
        text: "No, that is medically incorrect. Thermal injury, delayed necrosis, and micro-perforation in dense adhesion tissue are well-recognized, documented risks of this procedure that can occur even with meticulous surgical technique.",
        rating: "Master Defense Response",
        grade: "A+",
        analysis: "Educates the record factually, cites recognized medical literature, and refutes the premise that complications equal negligence."
      },
      {
        id: "opt-c",
        text: "I don't remember this surgery at all so I can't say.",
        rating: "Weak / Evasive",
        grade: "C-",
        analysis: "Leaves the plaintiff's false assertion unrebutted on the written deposition transcript."
      }
    ]
  }
];
