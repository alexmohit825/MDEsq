import Foundation
import SwiftUI

enum StarkComplianceState: String {
    case undercompensated = "UNDERCOMPENSATED (<P25)"
    case commercialNorm = "FMV COMPLIANT (P25–P75)"
    case premiumDefensible = "PREMIUM TIER (P75–P90)"
    case starkAuditZone = "STARK AUDIT ZONE (>P90)"
}

@MainActor
final class FMVCalculatorViewModel: ObservableObject {
    @Published var selectedSpecialty: SpecialtyBenchmark
    @Published var offeredBaseSalary: Double
    @Published var offeredWrvuTarget: Double
    @Published var offeredConversionFactor: Double
    @Published var unassignedCallDaysPerMonth: Double = 6
    @Published var offeredCallStipendPerShift: Double = 0
    @Published var copiedToast: String? = nil

    init() {
        let defaultSpec = SpecialtyDatabase.allSpecialties[0] // Neurological Surgery
        self.selectedSpecialty = defaultSpec
        self.offeredBaseSalary = Double(defaultSpec.compP50)
        self.offeredWrvuTarget = Double(defaultSpec.wrvuP50)
        self.offeredConversionFactor = defaultSpec.conversionFactorMedian
        self.offeredCallStipendPerShift = 0
    }

    func selectSpecialty(_ spec: SpecialtyBenchmark) {
        MDEsqHaptics.selection()
        selectedSpecialty = spec
        offeredBaseSalary = Double(spec.compP50)
        offeredWrvuTarget = Double(spec.wrvuP50)
        offeredConversionFactor = spec.conversionFactorMedian
    }

    // MARK: - Quantitative FMV & Call Burden Metrics
    var annualCallShifts: Int {
        Int((unassignedCallDaysPerMonth * 12.0).rounded())
    }

    var annualOfferedCallComp: Int {
        Int(Double(annualCallShifts) * offeredCallStipendPerShift)
    }

    var marketAnnualCallValue: Int {
        annualCallShifts * selectedSpecialty.callStipend24hMedian
    }

    var uncompensatedCallSubsidyLoss: Int {
        max(0, marketAnnualCallValue - annualOfferedCallComp)
    }

    var totalAnnualOfferedComp: Int {
        Int(offeredBaseSalary) + annualOfferedCallComp
    }

    var effectiveDollarPerWrvu: Double {
        guard offeredWrvuTarget > 0 else { return 0 }
        return Double(totalAnnualOfferedComp) / offeredWrvuTarget
    }

    var compPercentile: Int {
        Self.interpolatePercentile(
            value: Double(totalAnnualOfferedComp),
            p25: Double(selectedSpecialty.compP25),
            p50: Double(selectedSpecialty.compP50),
            p75: Double(selectedSpecialty.compP75),
            p90: Double(selectedSpecialty.compP90)
        )
    }

    var wrvuPercentile: Int {
        Self.interpolatePercentile(
            value: offeredWrvuTarget,
            p25: Double(selectedSpecialty.wrvuP25),
            p50: Double(selectedSpecialty.wrvuP50),
            p75: Double(selectedSpecialty.wrvuP75),
            p90: Double(selectedSpecialty.wrvuP90)
        )
    }

    /// Positive means physician is generating higher wRVU percentile than salary percentile (underpaid for volume)
    var productivityAlignmentGap: Int {
        wrvuPercentile - compPercentile
    }

    var starkComplianceState: StarkComplianceState {
        if totalAnnualOfferedComp > selectedSpecialty.starkHighRiskThreshold {
            return .starkAuditZone
        } else if compPercentile >= 75 {
            return .premiumDefensible
        } else if compPercentile < 25 {
            return .undercompensated
        } else {
            return .commercialNorm
        }
    }

    var executiveVerdictSummary: String {
        if productivityAlignmentGap >= 15 {
            return "PRODUCTIVITY MISALIGNMENT ALERT: Your contractual wRVU workload sits at the \(wrvuPercentile)th percentile, while your total cash compensation is anchored at the \(compPercentile)th percentile. You are subsidizing the hospital by \(productivityAlignmentGap) percentile points of uncompensated clinical volume."
        } else if starkComplianceState == .starkAuditZone {
            return "STARK LAW 90TH PERCENTILE AUDIT ZONE: Total compensation exceeds the P90 threshold ($\(selectedSpecialty.starkHighRiskThreshold.formatted())). Under 42 C.F.R. § 411.357(c) & (p), ensure the file contains an independent valuation or proof of commensurate wRVU productivity (\(wrvuPercentile)th percentile) and trauma/call scarcity."
        } else if uncompensatedCallSubsidyLoss > 25_000 {
            return "UNCOMPENSATED CALL DILUTION: While base compensation sits near the \(compPercentile)th percentile, absorbing \(annualCallShifts) annual 24-hour call shifts below the $\(selectedSpecialty.callStipend24hMedian.formatted())/shift specialty median represents $\(uncompensatedCallSubsidyLoss.formatted())/year in uncompensated coverage."
        } else {
            return "COMMENSURATE COMMERCIAL REASONABLENESS: Compensation (\(compPercentile)th percentile) and wRVU expectations (\(wrvuPercentile)th percentile) are well-aligned within 42 C.F.R. § 411.357 Fair Market Value safe harbor norms."
        }
    }

    static func interpolatePercentile(value: Double, p25: Double, p50: Double, p75: Double, p90: Double) -> Int {
        if value <= p25 {
            let ratio = max(0.05, value / max(1, p25))
            return max(1, Int((ratio * 25.0).rounded()))
        } else if value <= p50 {
            let fraction = (value - p25) / max(1, (p50 - p25))
            return Int((25.0 + fraction * 25.0).rounded())
        } else if value <= p75 {
            let fraction = (value - p50) / max(1, (p75 - p50))
            return Int((50.0 + fraction * 25.0).rounded())
        } else if value <= p90 {
            let fraction = (value - p75) / max(1, (p90 - p75))
            return Int((75.0 + fraction * 15.0).rounded())
        } else {
            let excess = (value - p90) / max(1, (p90 * 0.25))
            return min(99, Int((90.0 + excess * 9.0).rounded()))
        }
    }

    func generateFMVNegotiationBrief() -> String {
        """
        ====================================================================
        MD ESQ. — STARK LAW & FAIR MARKET VALUE COMPENSATION AUDIT BRIEF
        ====================================================================
        Specialty Benchmark: \(selectedSpecialty.name)
        Statutory Authority: 42 U.S.C. § 1395nn (Stark Law) | 42 C.F.R. § 411.357(c) & (p) | 42 U.S.C. § 1320a-7b(b) (AKS)

        1. COMPENSATION & PRODUCTIVITY ALIGNMENT
        • Offered Base Compensation: $\(Int(offeredBaseSalary).formatted())
        • Offered Annual Call Stipend (\(annualCallShifts) shifts/yr): $\(annualOfferedCallComp.formatted())
        • Total Annual Cash Compensation: $\(totalAnnualOfferedComp.formatted()) (\(compPercentile)th Percentile)
        • Target Annual wRVU Volume: \(Int(offeredWrvuTarget).formatted()) wRVUs (\(wrvuPercentile)th Percentile)
        • Offered Conversion Factor: $\(String(format: "%.2f", offeredConversionFactor))/wRVU (Market P25–P75: $\(Int(selectedSpecialty.conversionFactorLow))–$\(Int(selectedSpecialty.conversionFactorHigh))/wRVU)
        • Effective Blended Rate: $\(String(format: "%.2f", effectiveDollarPerWrvu))/wRVU

        2. NATIONAL COMPOSITE BENCHMARK DISTRIBUTION (\(selectedSpecialty.name.uppercased()))
        • 25th Percentile: $\(selectedSpecialty.compP25.formatted()) (\(selectedSpecialty.wrvuP25.formatted()) wRVUs)
        • 50th Percentile (Median): $\(selectedSpecialty.compP50.formatted()) (\(selectedSpecialty.wrvuP50.formatted()) wRVUs)
        • 75th Percentile: $\(selectedSpecialty.compP75.formatted()) (\(selectedSpecialty.wrvuP75.formatted()) wRVUs)
        • 90th Percentile (Stark Threshold): $\(selectedSpecialty.compP90.formatted()) (\(selectedSpecialty.wrvuP90.formatted()) wRVUs)

        3. ON-CALL STIPEND VALUATION
        • Specialty 24h Call Stipend Median: $\(selectedSpecialty.callStipend24hMedian.formatted())/shift
        • Fair Market Value of \(annualCallShifts) Annual Shifts: $\(marketAnnualCallValue.formatted())/year
        • Uncompensated Call Subsidy Gap: $\(uncompensatedCallSubsidyLoss.formatted())/year

        4. EXECUTIVE AUDIT VERDICT
        \(executiveVerdictSummary)
        ====================================================================
        """
    }
}
