import Foundation

public struct DepositionRule: Identifiable, Hashable {
    public let id: Int
    public let title: String
    public let principle: String
    public let explanation: String
    public let fatalMistake: String
    public let masterScript: String
}

public struct DepositionDatabase {
    public static let rules: [DepositionRule] = [
        DepositionRule(
            id: 1,
            title: "1. The 5-Second Pause Mandate",
            principle: "Listen. Stop. Pause for 5 full seconds before answering every single question.",
            explanation: "Gives your defense counsel time to object, slows down the plaintiff attorney's rhythm, and prevents reactive emotional admissions.",
            fatalMistake: "Answering immediately or interrupting opposing counsel.",
            masterScript: "[Listen to complete question] -> [Count 1, 2, 3, 4, 5 silently] -> [Answer only what was asked]."
        ),
        DepositionRule(
            id: 2,
            title: "2. The Reptile Theory Neutralizer",
            principle: "Never agree to broad, generalized 'Safety Rules' or 'Never Events'.",
            explanation: "Plaintiff attorneys try to trap physicians with 'Doctor, isn't patient safety always your number one priority?' and 'A prudent doctor never cuts a nerve, correct?'",
            fatalMistake: "Answering 'Yes' to broad safety generalizations.",
            masterScript: "'Medicine cannot be reduced to broad generalizations. Every clinical situation involves balancing complex patient-specific risks and anatomical variations under the specific clinical circumstances at that moment.'"
        ),
        DepositionRule(
            id: 3,
            title: "3. Never Speculate or Guess",
            principle: "If you do not recall or it is outside your memory, say 'I do not recall.'",
            explanation: "A deposition is an interrogation under oath, not an oral board exam. Guessing or reconstructing memories without chart corroboration destroys defense credibility.",
            fatalMistake: "Guessing what you 'probably' or 'must have' done.",
            masterScript: "'I do not have an independent recollection of that specific conversation, and my operative note accurately reflects what occurred.'"
        )
    ]
}
