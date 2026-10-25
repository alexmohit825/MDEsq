import SwiftUI
import Charts

struct FMVCalculatorView: View {
    @StateObject private var viewModel = FMVCalculatorViewModel()

    private struct PercentileBarMark: Identifiable {
        let id = UUID()
        let label: String
        let amount: Int
        let isOfferedPin: Bool
    }

    private var chartData: [PercentileBarMark] {
        let s = viewModel.selectedSpecialty
        return [
            PercentileBarMark(label: "P25", amount: Int(s.compP25), isOfferedPin: false),
            PercentileBarMark(label: "P50 (Median)", amount: Int(s.compP50), isOfferedPin: false),
            PercentileBarMark(label: "Your Offer", amount: viewModel.totalAnnualOfferedComp, isOfferedPin: true),
            PercentileBarMark(label: "P75", amount: Int(s.compP75), isOfferedPin: false),
            PercentileBarMark(label: "P90 (Stark)", amount: Int(s.compP90), isOfferedPin: false)
        ]
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                MDEsqTheme.obsidian.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        headerBanner
                        specialtySelectorCard
                        swiftChartsDistributionCard
                        interactiveSlidersCard
                        callStipendAuditCard
                        executiveVerdictCard
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    .padding(.bottom, 40)
                }

                if let toast = viewModel.copiedToast {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.seal.fill")
                        Text(toast)
                            .font(.caption.weight(.bold))
                    }
                    .foregroundStyle(MDEsqTheme.obsidian)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(MDEsqTheme.gold)
                    .clipShape(Capsule())
                    .padding(.bottom, 16)
                }
            }
            .navigationTitle("FMV & Stark Law Auditor")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    ShareLink(
                        item: viewModel.generateFMVNegotiationBrief(),
                        subject: Text("FMV & Stark Law Compensation Brief — \(viewModel.selectedSpecialty.name)")
                    ) {
                        HStack(spacing: 4) {
                            Image(systemName: "square.and.arrow.up")
                            Text("Export")
                                .font(.caption.weight(.semibold))
                        }
                        .foregroundStyle(MDEsqTheme.gold)
                    }
                }
            }
        }
    }

    private var headerBanner: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Label("42 C.F.R. § 411.357 • STARK & AKS SAFE HARBOR", systemImage: "chart.bar.xaxis")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundStyle(MDEsqTheme.gold)
                Spacer()
                Text("13 SPECIALTIES")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundStyle(MDEsqTheme.goldLight)
            }
            Text("Physician FMV, wRVU & Call Burden Visualizer")
                .font(.system(size: 21, weight: .bold, design: .serif))
                .foregroundStyle(MDEsqTheme.ivory)
            Text("Compare your offered base salary, wRVU productivity target, and 24-hour call stipends against national P25–P90 composite benchmarks.")
                .font(.footnote)
                .foregroundStyle(MDEsqTheme.slateMuted)
        }
        .padding(16)
        .background(MDEsqTheme.navyCard)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var specialtySelectorCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("SELECT SURGICAL OR MEDICAL SUBSPECIALTY")
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .foregroundStyle(MDEsqTheme.gold)

            Menu {
                ForEach(SpecialtyDatabase.allSpecialties) { spec in
                    Button {
                        viewModel.selectSpecialty(spec)
                    } label: {
                        HStack {
                            Text(spec.name)
                            if spec.id == viewModel.selectedSpecialty.id {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(viewModel.selectedSpecialty.name)
                            .font(.system(size: 17, weight: .bold, design: .serif))
                            .foregroundStyle(MDEsqTheme.ivory)
                        Text("Median: $\(viewModel.selectedSpecialty.compP50.formatted()) • \(viewModel.selectedSpecialty.wrvuP50.formatted()) wRVUs • $\(String(format: "%.0f", viewModel.selectedSpecialty.conversionFactorMedian))/wRVU")
                            .font(.system(size: 11, design: .monospaced))
                            .foregroundStyle(MDEsqTheme.goldLight)
                    }
                    Spacer()
                    Image(systemName: "chevron.up.chevron.down")
                        .foregroundStyle(MDEsqTheme.gold)
                }
                .padding(14)
                .background(MDEsqTheme.navyElevated)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(16)
        .background(MDEsqTheme.navyCard)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    // MARK: - Native Swift Charts Percentile Distribution Visualizer (Pillar III)
    private var swiftChartsDistributionCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("NATIONAL PERCENTILE DISTRIBUTION (SWIFT CHARTS)")
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .foregroundStyle(MDEsqTheme.gold)
                    Text("Total Cash Comp vs. Stark P90 Ceiling")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(MDEsqTheme.ivory)
                }
                Spacer()
                Text("\(viewModel.compPercentile)th %ile")
                    .font(.system(size: 20, weight: .black, design: .monospaced))
                    .foregroundStyle(viewModel.starkComplianceState == .starkAuditZone ? MDEsqTheme.crimson : MDEsqTheme.emerald)
                    .contentTransition(.numericText())
            }

            Chart {
                ForEach(chartData) { item in
                    BarMark(
                        x: .value("Tier", item.label),
                        y: .value("Compensation", item.amount)
                    )
                    .foregroundStyle(
                        item.isOfferedPin
                            ? (viewModel.starkComplianceState == .starkAuditZone ? MDEsqTheme.crimson : MDEsqTheme.emerald)
                            : MDEsqTheme.gold.opacity(0.65)
                    )
                    .cornerRadius(6)
                    .annotation(position: .top) {
                        Text("$\(item.amount / 1000)k")
                            .font(.system(size: 9, weight: .bold, design: .monospaced))
                            .foregroundStyle(item.isOfferedPin ? MDEsqTheme.ivory : MDEsqTheme.slateMuted)
                    }
                }

                RuleMark(y: .value("Stark P90 Threshold", viewModel.selectedSpecialty.starkHighRiskThreshold))
                    .lineStyle(StrokeStyle(lineWidth: 1.5, dash: [5, 4]))
                    .foregroundStyle(MDEsqTheme.crimson)
                    .annotation(position: .top, alignment: .trailing) {
                        Text("Stark P90 Audit Line")
                            .font(.system(size: 9, weight: .bold, design: .monospaced))
                            .foregroundStyle(MDEsqTheme.crimson)
                    }
            }
            .frame(height: 210)
            .chartYAxis {
                AxisMarks(position: .leading) { value in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                        .foregroundStyle(MDEsqTheme.borderSubtle)
                    if let intVal = value.as(Int.self) {
                        AxisValueLabel("$\(intVal / 1000)k")
                            .font(.system(size: 9, design: .monospaced))
                            .foregroundStyle(MDEsqTheme.slateMuted)
                    }
                }
            }
            .chartXAxis {
                AxisMarks { value in
                    AxisValueLabel()
                        .font(.system(size: 9, weight: .semibold, design: .monospaced))
                        .foregroundStyle(MDEsqTheme.parchment)
                }
            }

            // Dual Metric Strip
            HStack(spacing: 10) {
                metricPill(
                    title: "COMP PERCENTILE",
                    value: "\(viewModel.compPercentile)th",
                    subtitle: "$\(viewModel.totalAnnualOfferedComp.formatted())/yr",
                    color: MDEsqTheme.gold
                )
                metricPill(
                    title: "wRVU PERCENTILE",
                    value: "\(viewModel.wrvuPercentile)th",
                    subtitle: "\(Int(viewModel.offeredWrvuTarget).formatted()) wRVUs",
                    color: MDEsqTheme.emerald
                )
                metricPill(
                    title: "BLENDED $/wRVU",
                    value: "$\(String(format: "%.1f", viewModel.effectiveDollarPerWrvu))",
                    subtitle: "Mkt: $\(Int(viewModel.selectedSpecialty.conversionFactorMedian))",
                    color: viewModel.productivityAlignmentGap >= 15 ? MDEsqTheme.crimson : MDEsqTheme.goldLight
                )
            }
        }
        .padding(16)
        .background(MDEsqTheme.navyCard)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private func metricPill(title: String, value: String, subtitle: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title)
                .font(.system(size: 9, weight: .bold, design: .monospaced))
                .foregroundStyle(MDEsqTheme.slateMuted)
            Text(value)
                .font(.system(size: 17, weight: .black, design: .monospaced))
                .foregroundStyle(color)
                .contentTransition(.numericText())
            Text(subtitle)
                .font(.system(size: 10, design: .monospaced))
                .foregroundStyle(MDEsqTheme.parchment)
                .lineLimit(1)
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(MDEsqTheme.navyElevated)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    // MARK: - Interactive Compensation & wRVU Sliders
    private var interactiveSlidersCard: some View {
        let s = viewModel.selectedSpecialty
        let minSalary = Double(max(150_000, Int(Double(s.compP25) * 0.65)))
        let maxSalary = Double(Int(Double(s.compP90) * 1.30))
        let minWrvu = Double(max(1_500, Int(Double(s.wrvuP25) * 0.60)))
        let maxWrvu = Double(Int(Double(s.wrvuP90) * 1.35))

        return VStack(alignment: .leading, spacing: 16) {
            Text("CONTRACTUAL COMPENSATION & PRODUCTIVITY INPUTS")
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .foregroundStyle(MDEsqTheme.gold)

            // Base Salary Slider
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("Offered Base Salary")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(MDEsqTheme.ivory)
                    Spacer()
                    Text("$\(Int(viewModel.offeredBaseSalary).formatted())")
                        .font(.system(size: 15, weight: .bold, design: .monospaced))
                        .foregroundStyle(MDEsqTheme.gold)
                        .contentTransition(.numericText())
                }
                Slider(value: $viewModel.offeredBaseSalary, in: minSalary...maxSalary, step: 5_000)
                    .tint(MDEsqTheme.gold)
            }

            // Target wRVUs Slider
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("Contractual wRVU Threshold")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(MDEsqTheme.ivory)
                    Spacer()
                    Text("\(Int(viewModel.offeredWrvuTarget).formatted()) wRVUs")
                        .font(.system(size: 15, weight: .bold, design: .monospaced))
                        .foregroundStyle(MDEsqTheme.emerald)
                        .contentTransition(.numericText())
                }
                Slider(value: $viewModel.offeredWrvuTarget, in: minWrvu...maxWrvu, step: 100)
                    .tint(MDEsqTheme.emerald)
            }

            // Conversion Factor Slider
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("Offered $/wRVU Bonus Conversion Factor")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(MDEsqTheme.ivory)
                    Spacer()
                    Text("$\(String(format: "%.2f", viewModel.offeredConversionFactor))/wRVU")
                        .font(.system(size: 15, weight: .bold, design: .monospaced))
                        .foregroundStyle(MDEsqTheme.goldLight)
                        .contentTransition(.numericText())
                }
                Slider(
                    value: $viewModel.offeredConversionFactor,
                    in: max(20, s.conversionFactorLow * 0.7)...(s.conversionFactorHigh * 1.35),
                    step: 1.0
                )
                .tint(MDEsqTheme.goldLight)
            }
        }
        .padding(16)
        .background(MDEsqTheme.navyCard)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    // MARK: - Unassigned Call Burden & Stipend Dilution Calculator
    private var callStipendAuditCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Label("UNASSIGNED ED / TRAUMA CALL STIPEND AUDIT", systemImage: "phone.badge.waveform.fill")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundStyle(MDEsqTheme.gold)
                Spacer()
                Text("Mkt Median: $\(viewModel.selectedSpecialty.callStipend24hMedian.formatted())/24h")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundStyle(MDEsqTheme.goldLight)
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("24-Hour Call Shifts Per Month")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(MDEsqTheme.ivory)
                    Spacer()
                    Text("\(Int(viewModel.unassignedCallDaysPerMonth)) shifts/mo (\(viewModel.annualCallShifts)/yr)")
                        .font(.system(size: 13, weight: .bold, design: .monospaced))
                        .foregroundStyle(MDEsqTheme.gold)
                }
                Slider(value: $viewModel.unassignedCallDaysPerMonth, in: 0...15, step: 1)
                    .tint(MDEsqTheme.gold)
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("Offered Stipend Per 24h Shift ($0 if Unbundled/Free)")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(MDEsqTheme.ivory)
                    Spacer()
                    Text("$\(Int(viewModel.offeredCallStipendPerShift).formatted())/shift")
                        .font(.system(size: 13, weight: .bold, design: .monospaced))
                        .foregroundStyle(MDEsqTheme.emerald)
                }
                Slider(value: $viewModel.offeredCallStipendPerShift, in: 0...4_500, step: 100)
                    .tint(MDEsqTheme.emerald)
            }

            if viewModel.uncompensatedCallSubsidyLoss > 0 {
                HStack(spacing: 10) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(MDEsqTheme.amber)
                    Text("Hidden Uncompensated Call Subsidy: You are donating $\(viewModel.uncompensatedCallSubsidyLoss.formatted())/year in below-market 24h call coverage compared to the \(viewModel.selectedSpecialty.name) median ($\(viewModel.selectedSpecialty.callStipend24hMedian.formatted())/shift).")
                        .font(.caption)
                        .foregroundStyle(MDEsqTheme.parchment)
                }
                .padding(10)
                .background(MDEsqTheme.amber.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
        .padding(16)
        .background(MDEsqTheme.navyCard)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var executiveVerdictCard: some View {
        let stateColor: Color = {
            switch viewModel.starkComplianceState {
            case .starkAuditZone, .undercompensated: return MDEsqTheme.crimson
            case .premiumDefensible: return MDEsqTheme.gold
            case .commercialNorm: return MDEsqTheme.emerald
            }
        }()

        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(viewModel.starkComplianceState.rawValue)
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(stateColor.opacity(0.18))
                    .foregroundStyle(stateColor)
                    .clipShape(Capsule())
                Spacer()
                Text("42 C.F.R. § 411.357(c)")
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundStyle(MDEsqTheme.gold)
            }

            Text(viewModel.executiveVerdictSummary)
                .font(.system(size: 14, design: .serif))
                .foregroundStyle(MDEsqTheme.ivory)

            Button {
                UIPasteboard.general.string = viewModel.generateFMVNegotiationBrief()
                MDEsqHaptics.success()
                viewModel.copiedToast = "Copied FMV & Stark Law Compensation Brief"
                Task {
                    try? await Task.sleep(nanoseconds: 2_000_000_000)
                    viewModel.copiedToast = nil
                }
            } label: {
                Label("Copy Complete FMV & Call Negotiation Brief", systemImage: "doc.on.doc.fill")
                    .font(.caption.weight(.bold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(MDEsqTheme.gold)
                    .foregroundStyle(MDEsqTheme.obsidian)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding(16)
        .background(MDEsqTheme.navyCard)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(stateColor.opacity(0.45), lineWidth: 1)
        )
    }
}
