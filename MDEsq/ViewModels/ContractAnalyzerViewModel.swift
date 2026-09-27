import Foundation
import Combine

@MainActor
public class ContractAnalyzerViewModel: ObservableObject {
    @Published public var rawContractText: String = ""
    @Published public var flaggedClauses: [FlaggedClause] = []
    @Published public var overallGrade: String = "N/A"
    @Published public var gradeColor: String = "gray"
    @Published public var gradeNarrative: String = "Enter or upload a physician contract to audit predatory clauses."
    @Published public var isAnalyzing: Bool = false
    
    public init() {}
    
    public func analyzeText(_ text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            flaggedClauses = []
            overallGrade = "N/A"
            gradeColor = "gray"
            gradeNarrative = "No text provided."
            return
        }
        
        var matches: [FlaggedClause] = []
        let lower = trimmed.lowercased()
        
        for rule in ContractDatabase.rules {
            for kw in rule.keywords {
                if lower.contains(kw.lowercased()) {
                    let snippet = rule.predatorySnippetExample
                    matches.append(FlaggedClause(rule: rule, matchedTextSnippet: snippet, lineEstimate: 1))
                    break
                }
            }
        }
        
        self.flaggedClauses = matches
        let count = matches.count
        
        if count >= 3 {
            overallGrade = "F"
            gradeColor = "red"
            gradeNarrative = "Severe Institutional Risk: \(count) predatory trap clauses identified. Substantial tail and non-compete liabilities."
        } else if count == 2 {
            overallGrade = "D"
            gradeColor = "orange"
            gradeNarrative = "High Risk: \(count) flagged clauses requiring mandatory redlines."
        } else if count == 1 {
            overallGrade = "C"
            gradeColor = "yellow"
            gradeNarrative = "Moderate Exposure: 1 clause flagged for adjustment."
        } else {
            overallGrade = "A"
            gradeColor = "green"
            gradeNarrative = "Optimal / Clean Contract: Zero standard predatory trap clauses detected."
        }
    }
    
    public func loadSampleContract() {
        self.rawContractText = """
        PHYSICIAN EMPLOYMENT AGREEMENT
        1. RESTRICTIVE COVENANTS: Physician agrees that for a period of twenty-four (24) months following termination of employment, Physician shall not engage in the practice of medicine or surgery within twenty-five (25) miles of Hospital or any affiliated facility.
        2. PROFESSIONAL LIABILITY TAIL: Upon termination for any reason, Physician shall purchase and maintain extended reporting period (tail) malpractice insurance coverage at Physician's sole expense.
        3. INDEMNIFICATION: Physician agrees to defend, indemnify, and hold harmless Hospital from and against any and all claims, liabilities, or losses arising out of Physician's acts.
        4. EMERGENCY CALL: Physician shall provide emergency department call as assigned without additional compensation.
        """
        analyzeText(self.rawContractText)
    }
}
