import Foundation
import Combine

@MainActor
public class FMVCalculatorViewModel: ObservableObject {
    @Published public var selectedSpecialty: SpecialtyBenchmark = SpecialtyDatabase.allBenchmarks[0]
    @Published public var baseSalary: Double = 890000
    @Published public var targetWrvus: Double = 9400
    @Published public var conversionFactor: Double = 94.50
    @Published public var callDays: Double = 30
    
    public init() {}
    
    public var calculatedProductionComp: Double {
        return targetWrvus * conversionFactor
    }
    
    public var totalEstimatedComp: Double {
        return max(baseSalary, calculatedProductionComp)
    }
    
    public var fmvStatusTitle: String {
        if totalEstimatedComp < selectedSpecialty.compP25 {
            return "Below 25th Percentile (Severe Undercompensation)"
        } else if totalEstimatedComp <= selectedSpecialty.compP75 {
            return "Standard FMV Corridor (25th–75th Percentile)"
        } else if totalEstimatedComp <= selectedSpecialty.compP90 {
            return "Upper FMV Corridor (75th–90th Percentile)"
        } else {
            return "Stark Law Regulatory Risk (>90th Percentile)"
        }
    }
    
    public var fmvStatusColor: String {
        if totalEstimatedComp < selectedSpecialty.compP25 {
            return "orange"
        } else if totalEstimatedComp <= selectedSpecialty.compP75 {
            return "green"
        } else if totalEstimatedComp <= selectedSpecialty.compP90 {
            return "blue"
        } else {
            return "red"
        }
    }
}
