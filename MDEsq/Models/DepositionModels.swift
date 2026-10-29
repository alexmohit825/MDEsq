import Foundation

// MARK: - Deposition Rule
struct DepositionRule: Identifiable, Hashable {
    let id: String
    let number: Int
    let title: String
    let subtitle: String
    let trapExample: String
    let badResponse: String
    let masterResponse: String
    let takeaway: String
}

// MARK: - Reptile Theory Countermeasure
struct ReptileCountermeasure: Identifiable, Hashable {
    let id: String
    let reptileQuestion: String
    let psychologicalTrap: String
    let pivotFormula: String
}

// MARK: - Mock Deposition Simulator Models
struct MockDepositionOption: Identifiable, Hashable {
    let id: String
    let label: String
    let grade: String
    let isBest: Bool
    let critique: String
}

struct MockDepositionScenario: Identifiable, Hashable {
    let id: String
    let number: Int
    let category: String
    let plaintiffQuestion: String
    let trapAnalysis: String
    let options: [MockDepositionOption]
}

// MARK: - Deposition Database
struct DepositionDatabase {
    static let cardinalRules: [DepositionRule] = [
        DepositionRule(
            id: "depo-rule-1",
            number: 1,
            title: "Defeat the 'Reptile Theory' Safety Rule Trap",
            subtitle: "Never agree to absolute, context-free 'patient safety rules'",
            trapExample: "\"Doctor, wouldn't you agree that a prudent surgeon must ALWAYS avoid needlessly endangering a patient?\"",
            badResponse: "\"Yes, of course, I agree with that.\"",
            masterResponse: "\"Medicine and surgery are not governed by one-size-fits-all absolutes. Every surgical intervention carries inherent anatomical risks that must be weighed against the patient's specific pathology, comorbidities, and the risk of untreated disease within the standard of care.\"",
            takeaway: "Once you agree to a simplistic 'Always/Never' safety rule, plaintiff's counsel equates any recognized complication with a rule violation."
        ),
        DepositionRule(
            id: "depo-rule-2",
            number: 2,
            title: "Neutralize the 'Authoritative Textbook' Ambush",
            subtitle: "Never declare any textbook, article, or guideline 'authoritative'",
            trapExample: "\"Doctor, you trained with Greenberg's Handbook of Neurosurgery and Youmans—you consider Youmans an authoritative treatise in your field, correct?\"",
            badResponse: "\"Yes, Youmans is the bible of neurosurgery.\"",
            masterResponse: "\"It is one of many general reference texts available, but no single textbook or article is 'authoritative' or controls clinical judgment for an individual patient. Textbooks are often outdated by the time they are printed and cannot substitute for intraoperative assessment.\"",
            takeaway: "Under ER 803(18), calling a text 'reliable authority' allows opposing counsel to read cherry-picked sentences directly to the jury as substantive evidence against you."
        ),
        DepositionRule(
            id: "depo-rule-3",
            number: 3,
            title: "The 'If It Wasn't Charted, It Wasn't Done' Fallacy",
            subtitle: "Anchor unrecorded routine steps in 'Invariable Custom and Practice'",
            trapExample: "\"Your clinic note doesn't list every single cranial nerve—so you didn't actually test cranial nerves III, IV, and VI that morning, did you?\"",
            badResponse: "\"Well, if I didn't write it down, I guess I can't prove I did it.\"",
            masterResponse: "\"That is incorrect. A medical chart is a clinical communication tool, not a courtroom transcript of every second of a 30-minute encounter. Based on my invariable custom and routine practice recorded as 'CN II-XII intact,' I performed the complete examination.\"",
            takeaway: "Under Washington ER 406, testimony of a physician's invariable habit and routine practice is legally admissible to prove conduct on a specific occasion."
        ),
        DepositionRule(
            id: "depo-rule-4",
            number: 4,
            title: "Enforce the Mandatory 5-Second Pause",
            subtitle: "Break plaintiff counsel's cadence and give your attorney time to object",
            trapExample: "Rapid-fire 'Yes or No' questions designed to get you nodding rhythmically before slipping in a fatal concession.",
            badResponse: "Answering within 0.5 seconds or interrupting the lawyer before the last word is spoken.",
            masterResponse: "[Inhale slowly for 5 full seconds after the question ends. Process the exact wording, let your counsel state any form objection, deliver a concise answer, and stop talking.]",
            takeaway: "Video transcripts do not penalize a thoughtful 5-second pause—in fact, juries view a calm, deliberate surgeon as far more credible than a defensive, rapid-fire witness."
        ),
        DepositionRule(
            id: "depo-rule-5",
            number: 5,
            title: "Reject False Dichotomies ('Yes or No, Doctor!')",
            subtitle: "Never let counsel force a misleading binary answer to a complex clinical question",
            trapExample: "\"Doctor, it's a simple yes or no question: did your scalpel cut the dura during the laminectomy—yes or no?\"",
            badResponse: "\"Yes, I guess so.\"",
            masterResponse: "\"That question cannot be answered accurately with a simple yes or no because it mischaracterizes the surgical anatomy. During microsurgical dissection of severely adherent, ossified scar tissue from the thecal sac, a 2-millimeter incidental durotomy occurred, which is a well-recognized anatomical risk of decompression and was repaired primarily.\"",
            takeaway: "No judge in America will force a physician to answer 'Yes or No' when doing so would be clinically misleading."
        ),
        DepositionRule(
            id: "depo-rule-6",
            number: 6,
            title: "Hindsight Bias vs. Prospective Standard of Care",
            subtitle: "Lock every question to what was known PROSPECTIVELY at the bedside",
            trapExample: "\"Knowing now that the patient developed a spinal epidural abscess 5 days later, wouldn't ordering an MRI on Day 1 have prevented his paralysis?\"",
            badResponse: "\"In hindsight, yes, an MRI on Day 1 would have caught it.\"",
            masterResponse: "\"Standard of care is evaluated prospectively based on the clinical signs and symptoms present at the time of the encounter—not in hindsight. On Day 1, the patient was afebrile with normal white blood cell count, normal ESR/CRP, and a 5/5 neurological examination, where an urgent MRI was not clinically indicated.\"",
            takeaway: "Always verbally insert the words 'prospectively at the time of the evaluation' into your answer whenever counsel argues backward from the outcome."
        ),
        DepositionRule(
            id: "depo-rule-7",
            number: 7,
            title: "Never Speculate Beyond Personal Knowledge or the Record",
            subtitle: "Do not guess what another physician, nurse, or family member thought",
            trapExample: "\"Why do you think the night-shift resident waited three hours to call you about the blood pressure drop?\"",
            badResponse: "\"He was probably overwhelmed in the ER and forgot.\"",
            masterResponse: "\"I was not present for the resident's internal decision-making during that window, so it would be speculation for me to guess. What I can tell you from personal knowledge is that the moment I was notified at 03:15, I issued immediate orders.\"",
            takeaway: "Every time you guess or speculate about another provider's actions, you create an evidentiary conflict that plaintiff's counsel will exploit against the defense team."
        ),
        DepositionRule(
            id: "depo-rule-8",
            number: 8,
            title: "Never Volunteer, Teach, or Fill Dead Air",
            subtitle: "A deposition is an extraction of adverse admissions—not Grand Rounds",
            trapExample: "Plaintiff's attorney stares at you in silence for 10 seconds after you finish a two-sentence answer, hoping you will keep talking to fill the awkward silence.",
            badResponse: "\"And let me explain more about how we usually handle those cases in our department...\"",
            masterResponse: "[Answer the exact question asked in 1 to 2 precise sentences, fold your hands, look calmly at the questioner, and remain completely silent until the next question is asked.]",
            takeaway: "You cannot win your case at your deposition, but you can lose it by volunteering new avenues of cross-examination."
        )
    ]

    static let reptileCountermeasures: [ReptileCountermeasure] = [
        ReptileCountermeasure(
            id: "reptile-1",
            reptileQuestion: "\"Doctor, a surgeon is never allowed to take an unnecessary risk with a patient's spine, right?\"",
            psychologicalTrap: "Equates 'accepted surgical risk' with 'unnecessary risk' so any complication looks reckless.",
            pivotFormula: "\"All surgery involves balancing inherent anatomical risks against the risk of leaving the patient's pathology untreated. My obligation under the standard of care is to exercise reasonable clinical judgment tailored to the specific patient.\""
        ),
        ReptileCountermeasure(
            id: "reptile-2",
            reptileQuestion: "\"Wouldn't you agree that when a differential diagnosis includes a life-threatening condition, you must ALWAYS rule it out first with a test?\"",
            psychologicalTrap: "Turns every non-indicated CT/MRI into a mandatory requirement regardless of pretest probability.",
            pivotFormula: "\"Diagnostic workups are governed by clinical presentation, physical examination findings, and pretest probability at the time of the encounter—not by ordering every conceivable test on every patient regardless of clinical findings.\""
        ),
        ReptileCountermeasure(
            id: "reptile-3",
            reptileQuestion: "\"Patient safety must always be the #1 priority above all else, correct?\"",
            psychologicalTrap: "Sets up a binary trap where any conservative clinical choice or resource allocation is framed as 'putting something above safety.'",
            pivotFormula: "\"Patient safety is central to everything we do, and achieving safe care in a complex clinical setting requires exercising sound medical judgment based on the totality of the patient's clinical picture.\""
        )
    ]

    static let mockScenarios: [MockDepositionScenario] = [
        MockDepositionScenario(
            id: "mock-1",
            number: 1,
            category: "The Reptile Theory 'Safety Rule' Trap",
            plaintiffQuestion: "\"Doctor, before we even look at this patient's chart, can we at least agree on a basic safety rule: a reasonably prudent surgeon should NEVER injure an adjacent nerve root while decompressing a lumbar disc?\"",
            trapAnalysis: "Classic Reptile opener. If you say 'Yes,' you have just testified under oath that any nerve root retraction injury or neuropraxia equals a breach of the standard of care (strict liability).",
            options: [
                MockDepositionOption(
                    id: "m1-a",
                    label: "\"Yes, obviously our goal is never to injure a nerve root.\"",
                    grade: "D",
                    isBest: false,
                    critique: "Dangerous concession. Plaintiff's counsel will clip the first word ('Yes') and play it in opening statement alongside the post-op EMG showing radiculopathy."
                ),
                MockDepositionOption(
                    id: "m1-b",
                    label: "\"No, sometimes we injure nerve roots during surgery.\"",
                    grade: "F",
                    isBest: false,
                    critique: "Catastrophic soundbite on video. Sounds cavalier and indifferent to patient injury."
                ),
                MockDepositionOption(
                    id: "m1-c",
                    label: "\"While every surgeon strives to protect neural structures, nerve root irritation or injury is a recognized anatomical risk of decompressing a severely stenotic canal that can occur even when the procedure is performed with the highest degree of skill within the standard of care.\"",
                    grade: "A+",
                    isBest: true,
                    critique: "Masterclass response. Affirms care for neural structures while legally severing 'known anatomical complication' from 'negligence' under RCW 7.70.040."
                )
            ]
        ),
        MockDepositionScenario(
            id: "mock-2",
            number: 2,
            category: "The 'Learned Treatise / Authoritative Textbook' Trap",
            plaintiffQuestion: "\"Doctor, you have Rothman-Simeone The Spine on your office bookshelf right behind you. You rely on Rothman-Simeone as an authoritative text in spine surgery, don't you?\"",
            trapAnalysis: "Under Evidence Rule 803(18), the magic word is 'authoritative' or 'reliable authority.' Once you concede that label, counsel can read isolated sentences from a 2,000-page book to impeach you.",
            options: [
                MockDepositionOption(
                    id: "m2-a",
                    label: "\"Yes, Rothman-Simeone is one of the most respected authoritative textbooks in spine surgery.\"",
                    grade: "F",
                    isBest: false,
                    critique: "Trap sprung. You just unlocked the entire two-volume textbook for opposing counsel to read cherry-picked sentences to the jury."
                ),
                MockDepositionOption(
                    id: "m2-b",
                    label: "\"It is a useful general reference book among many in the literature, but I do not consider any single textbook to be 'authoritative' because textbooks represent individual authors' views at the time of publication and cannot govern intraoperative clinical judgment for a specific patient.\"",
                    grade: "A+",
                    isBest: true,
                    critique: "Masterclass response. Blocks ER 803(18) foundation completely while sounding scholarly and clinically grounded."
                ),
                MockDepositionOption(
                    id: "m2-c",
                    label: "\"I never read textbooks anymore; I just rely on my own experience.\"",
                    grade: "C-",
                    isBest: false,
                    critique: "Avoids the evidentiary rule but makes you sound arrogant and disconnected from current medical literature."
                )
            ]
        ),
        MockDepositionScenario(
            id: "mock-3",
            number: 3,
            category: "The 'Uncharted Clinical Step' Trap",
            plaintiffQuestion: "\"Doctor, look at Exhibit 4, your post-op Day 1 progress note. Nowhere on this page did you write the words 'calf soft, negative Homan's sign.' That means you never examined the patient's lower extremities for DVT that morning, correct?\"",
            trapAnalysis: "Attempts to equate brevity in a progress note with a failure to examine the patient.",
            options: [
                MockDepositionOption(
                    id: "m3-a",
                    label: "\"That is incorrect. My progress note documents 'Extremities: warm, well-perfused, no edema, motor 5/5.' Based on my invariable daily post-operative rounding routine, that examination includes palpating the calves and assessing for lower-extremity tenderness.\"",
                    grade: "A+",
                    isBest: true,
                    critique: "Masterclass response. Points to the actual chart entry and invokes admissible habit/routine practice under ER 406."
                ),
                MockDepositionOption(
                    id: "m3-b",
                    label: "\"Well, if it's not written there, I can't say for sure three years later whether I checked his calves.\"",
                    grade: "D",
                    isBest: false,
                    critique: "Gives plaintiff's counsel an uncontested admission that you failed to examine the extremity."
                ),
                MockDepositionOption(
                    id: "m3-c",
                    label: "\"The nurses check the calves every shift anyway, so I didn't need to write it.\"",
                    grade: "F",
                    isBest: false,
                    critique: "Sounds like you abdicated your personal duty as the attending physician."
                )
            ]
        ),
        MockDepositionScenario(
            id: "mock-4",
            number: 4,
            category: "The 'Hospital Nursing Policy = Standard of Care' Trap",
            plaintiffQuestion: "\"Doctor, Hospital Policy #402.1 states that post-laminectomy neuro checks are to be logged every 30 minutes for the first 2 hours. Because one check was logged at 48 minutes, you agree the legal standard of care was breached, correct?\"",
            trapAnalysis: "Plaintiff's counsel tries to convert an internal administrative nursing guideline into the statutory physician standard of care under RCW 7.70.040.",
            options: [
                MockDepositionOption(
                    id: "m4-a",
                    label: "\"Yes, hospital policies are the rules we have to follow, so missing the 30-minute mark is a breach.\"",
                    grade: "F",
                    isBest: false,
                    critique: "Fatal legal concession. You just elevated an internal hospital nursing goal into strict malpractice liability."
                ),
                MockDepositionOption(
                    id: "m4-b",
                    label: "\"Internal hospital administrative policies are aspirational operational guidelines for nursing staff—they do not define the legal standard of care for a physician under Washington law. Clinically, the patient's neurological examination remained stable and 5/5 throughout recovery.\"",
                    grade: "A+",
                    isBest: true,
                    critique: "Masterclass response. Separates internal administrative bylaws/policies from the statutory standard of care (RCW 7.70.040) and pivots to lack of proximate causation."
                ),
                MockDepositionOption(
                    id: "m4-c",
                    label: "\"That's a nursing failure, not my fault—you should ask the PACU nurse why she was 18 minutes late.\"",
                    grade: "D",
                    isBest: false,
                    critique: "Finger-pointing at hospital nurses alienates the jury and invites hospital co-defendant cross-claims against you."
                )
            ]
        ),
        MockDepositionScenario(
            id: "mock-5",
            number: 5,
            category: "The 'EMR Audit Log / 42-Second MRI Review' Telemetry Trap",
            plaintiffQuestion: "\"Doctor, we subpoenaed the Epic & PACS access audit trail. It shows you opened the lumbar MRI on your clinic computer for only 44 seconds before signing your note. You rushed through this patient's scan, didn't you?\"",
            trapAnalysis: "Modern plaintiff attorneys subpoena raw EMR clickstream logs and mischaracterize a quick note-signing refresh as your only review of the imaging.",
            options: [
                MockDepositionOption(
                    id: "m5-a",
                    label: "\"I can read a spine MRI in 44 seconds; I've looked at ten thousand of them.\"",
                    grade: "D-",
                    isBest: false,
                    critique: "Sounds dismissive and arrogant to a lay jury when a patient suffered a severe complication."
                ),
                MockDepositionOption(
                    id: "m5-b",
                    label: "\"An EMR login timestamp on a single terminal does not capture the totality of my imaging review. Prior to and during the encounter, I reviewed the multi-planar sagittal and axial sequences on the PACS workstation, correlated them directly with the patient's dermatomal exam, and reviewed the key slices again at the bedside with the patient.\"",
                    grade: "A+",
                    isBest: true,
                    critique: "Masterclass response. Exposes the technical artificiality of single-terminal EMR audit logs and anchors your care in thorough clinical correlation."
                ),
                MockDepositionOption(
                    id: "m5-c",
                    label: "\"The Epic computer clock must be broken or inaccurate.\"",
                    grade: "F",
                    isBest: false,
                    critique: "Easily disproven by IT testimony and destroys your credibility on all other electronic records."
                )
            ]
        ),
        MockDepositionScenario(
            id: "mock-6",
            number: 6,
            category: "The 'Captain of the Ship / Vicarious Liability' Trap",
            plaintiffQuestion: "\"Doctor, as the lead attending surgeon in Operating Room 4, you are the 'Captain of the Ship' and personally responsible for every action taken by the anesthesiologist and circulating staff in that room, aren't you?\"",
            trapAnalysis: "Tries to trick your ego into accepting personal legal liability for independent specialists (anesthesia) or hospital employees.",
            options: [
                MockDepositionOption(
                    id: "m6-a",
                    label: "\"Yes, it's my operating room and the buck stops with me.\"",
                    grade: "F",
                    isBest: false,
                    critique: "Your chivalry just made you personally liable for an anesthesia airway or medication error you didn't commit."
                ),
                MockDepositionOption(
                    id: "m6-b",
                    label: "\"Modern surgery is performed by distinct, specialized professionals. As the attending neurosurgeon, I direct and am responsible for the neurosurgical procedure at the operative field, while the board-certified anesthesiologist independently manages anesthesia and hemodynamic monitoring within their distinct specialty.\"",
                    grade: "A+",
                    isBest: true,
                    critique: "Masterclass response. Respectfully delineates legal and clinical scopes of practice under Washington law (Kemalyan v. Henderson)."
                ),
                MockDepositionOption(
                    id: "m6-c",
                    label: "\"I have zero control over anyone else in the operating room.\"",
                    grade: "C-",
                    isBest: false,
                    critique: "Overstates the point and can be impeached if you gave intraoperative positioning or antibiotic directives."
                )
            ]
        )
    ]
}
