import SwiftUI
import StoreKit

struct DepositionMasterclassView: View {
    enum TrainingMode: String, CaseIterable {
        case simulator = "Cross-Exam Simulator"
        case metronome = "5s Pause Metronome"
        case rules = "8 Rules & Reptile"
    }

    @Environment(\.requestReview) private var requestReview
    @State private var selectedMode: TrainingMode = .simulator
    @State private var selectedOptionByScenario: [String: MockDepositionOption] = [:]

    // 5-Second Pause Haptic Metronome State
    @State private var isMetronomeRunning: Bool = false
    @State private var metronomeSecondsElapsed: Int = 0
    @State private var metronomeStatusText: String = "Tap 'Start Question End' the instant opposing counsel finishes speaking."
    private let metronomeTimer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationStack {
            ZStack {
                MDEsqTheme.obsidian.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        headerBanner
                        modeSelector

                        switch selectedMode {
                        case .simulator:
                            simulatorSection
                        case .metronome:
                            hapticMetronomeCard
                        case .rules:
                            reptileSection
                            cardinalRulesSection
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("Deposition Masterclass")
            .navigationBarTitleDisplayMode(.inline)
            .onReceive(metronomeTimer) { _ in
                guard isMetronomeRunning else { return }
                if metronomeSecondsElapsed < 5 {
                    metronomeSecondsElapsed += 1
                    if metronomeSecondsElapsed < 5 {
                        MDEsqHaptics.impactLight()
                        metronomeStatusText = "Hold silence…Second \(metronomeSecondsElapsed) of 5 (Letting counsel object & breaking cadence)"
                    } else {
                        MDEsqHaptics.success()
                        metronomeStatusText = "5.0 SECONDS COMPLETE — Deliver concise 1-sentence answer & stop talking."
                        isMetronomeRunning = false
                    }
                }
            }
        }
    }

    private var headerBanner: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Label("REPTILE THEORY DEFENSE & ER 803(18) SHIELD", systemImage: "person.wave.2.fill")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundStyle(MDEsqTheme.gold)
                Spacer()
                Text("MOCK CROSS-EXAM")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundStyle(MDEsqTheme.goldLight)
            }
            Text("Physician Deposition & Testimony Simulator")
                .font(.system(size: 21, weight: .bold, design: .serif))
                .foregroundStyle(MDEsqTheme.ivory)
            Text("Train against plaintiff counsel's Reptile 'Safety Rule' traps, Learned Treatise ambushes, and rapid-fire cadence before going under oath.")
                .font(.footnote)
                .foregroundStyle(MDEsqTheme.slateMuted)
        }
        .padding(16)
        .background(MDEsqTheme.navyCard)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var modeSelector: some View {
        Picker("Training Mode", selection: $selectedMode) {
            ForEach(TrainingMode.allCases, id: \.self) { mode in
                Text(mode.rawValue).tag(mode)
            }
        }
        .pickerStyle(.segmented)
        .onChange(of: selectedMode) { _, _ in
            MDEsqHaptics.selection()
        }
    }

    // MARK: - Interactive Mock Cross-Examination Simulator
    private var simulatorSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(DepositionDatabase.mockScenarios) { scenario in
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("TRAP #\(scenario.number)")
                            .font(.system(size: 10, weight: .black, design: .monospaced))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(MDEsqTheme.crimson)
                            .foregroundStyle(MDEsqTheme.ivory)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                        Text(scenario.category.uppercased())
                            .font(.system(size: 10, weight: .bold, design: .monospaced))
                            .foregroundStyle(MDEsqTheme.gold)
                    }

                    Text(scenario.plaintiffQuestion)
                        .font(.system(size: 15, weight: .semibold, design: .serif))
                        .italic()
                        .foregroundStyle(MDEsqTheme.ivory)
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(MDEsqTheme.obsidian)
                        .clipShape(RoundedRectangle(cornerRadius: 10))

                    Text("Select Your Testimony Under Oath:")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(MDEsqTheme.slateMuted)

                    ForEach(scenario.options) { option in
                        let isChosen = selectedOptionByScenario[scenario.id]?.id == option.id
                        Button {
                            if option.isBest {
                                MDEsqHaptics.success()
                            } else {
                                MDEsqHaptics.warning()
                            }
                            selectedOptionByScenario[scenario.id] = option
                            if selectedOptionByScenario.count == DepositionDatabase.mockScenarios.count {
                                requestReview()
                            }
                        } label: {
                            HStack(alignment: .top, spacing: 10) {
                                Image(systemName: isChosen ? (option.isBest ? "checkmark.seal.fill" : "exclamationmark.octagon.fill") : "circle")
                                    .foregroundStyle(isChosen ? (option.isBest ? MDEsqTheme.emerald : MDEsqTheme.crimson) : MDEsqTheme.gold)
                                    .padding(.top, 2)
                                Text(option.label)
                                    .font(.system(size: 13, design: .serif))
                                    .foregroundStyle(MDEsqTheme.ivory)
                                    .multilineTextAlignment(.leading)
                            }
                            .padding(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(isChosen ? (option.isBest ? MDEsqTheme.emerald.opacity(0.15) : MDEsqTheme.crimson.opacity(0.15)) : MDEsqTheme.navyElevated)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(isChosen ? (option.isBest ? MDEsqTheme.emerald : MDEsqTheme.crimson) : MDEsqTheme.borderSubtle, lineWidth: 1)
                            )
                        }
                        .buttonStyle(.plain)
                    }

                    if let chosen = selectedOptionByScenario[scenario.id] {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("GRADE: \(chosen.grade)")
                                    .font(.system(size: 12, weight: .black, design: .monospaced))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 3)
                                    .background((chosen.isBest ? MDEsqTheme.emerald : MDEsqTheme.crimson).opacity(0.2))
                                    .foregroundStyle(chosen.isBest ? MDEsqTheme.emerald : MDEsqTheme.crimson)
                                    .clipShape(Capsule())
                                Text(chosen.isBest ? "COURTROOM MASTERCLASS" : "LITIGATION TRAP SPRUNG")
                                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                                    .foregroundStyle(chosen.isBest ? MDEsqTheme.emerald : MDEsqTheme.crimson)
                            }
                            Text(chosen.critique)
                                .font(.caption)
                                .foregroundStyle(MDEsqTheme.parchment)
                            Text("Underlying Strategy: \(scenario.trapAnalysis)")
                                .font(.caption2)
                                .foregroundStyle(MDEsqTheme.slateMuted)
                        }
                        .padding(12)
                        .background(MDEsqTheme.obsidian.opacity(0.8))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                .padding(16)
                .background(MDEsqTheme.navyCard)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
        }
    }

    // MARK: - Interactive 5-Second Pause Haptic Metronome (Pillar III)
    private var hapticMetronomeCard: some View {
        VStack(spacing: 20) {
            VStack(spacing: 6) {
                Text("5-SECOND PAUSE CADENCE TRAINER")
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .foregroundStyle(MDEsqTheme.gold)
                Text("Why Surgeons Lose Depositions in the First 800 Milliseconds")
                    .font(.system(size: 18, weight: .bold, design: .serif))
                    .foregroundStyle(MDEsqTheme.ivory)
                    .multilineTextAlignment(.center)
                Text("In the OR, rapid reflexes save lives. In a video deposition, answering within 1 second prevents your attorney from objecting to form and lets plaintiff counsel lock you into a rhythm.")
                    .font(.caption)
                    .foregroundStyle(MDEsqTheme.slateMuted)
                    .multilineTextAlignment(.center)
            }

            // Circular Tactile Ring
            ZStack {
                Circle()
                    .stroke(MDEsqTheme.navyElevated, lineWidth: 14)
                    .frame(width: 190, height: 190)

                Circle()
                    .trim(from: 0, to: CGFloat(metronomeSecondsElapsed) / 5.0)
                    .stroke(
                        metronomeSecondsElapsed == 5 ? MDEsqTheme.emerald : MDEsqTheme.gold,
                        style: StrokeStyle(lineWidth: 14, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.4), value: metronomeSecondsElapsed)
                    .frame(width: 190, height: 190)

                VStack(spacing: 4) {
                    Text("\(metronomeSecondsElapsed).0s")
                        .font(.system(size: 42, weight: .black, design: .monospaced))
                        .foregroundStyle(metronomeSecondsElapsed == 5 ? MDEsqTheme.emerald : MDEsqTheme.ivory)
                        .contentTransition(.numericText())
                    Text(metronomeSecondsElapsed == 5 ? "SPEAK NOW" : (isMetronomeRunning ? "HOLD SILENCE" : "READY"))
                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                        .foregroundStyle(metronomeSecondsElapsed == 5 ? MDEsqTheme.emerald : MDEsqTheme.gold)
                }
            }
            .padding(.vertical, 8)

            Text(metronomeStatusText)
                .font(.system(size: 13.5, design: .serif))
                .foregroundStyle(MDEsqTheme.parchment)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 12)

            HStack(spacing: 12) {
                Button {
                    MDEsqHaptics.impactMedium()
                    metronomeSecondsElapsed = 0
                    isMetronomeRunning = true
                    metronomeStatusText = "Inhale slowly… Feeling 1 Hz haptic pulse…"
                } label: {
                    Label(isMetronomeRunning ? "Restart 5s Pause" : "Start 5-Second Pause Drill", systemImage: "waveform.path.ecg")
                        .font(.subheadline.weight(.bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(MDEsqTheme.gold)
                        .foregroundStyle(MDEsqTheme.obsidian)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                if isMetronomeRunning || metronomeSecondsElapsed > 0 {
                    Button {
                        isMetronomeRunning = false
                        metronomeSecondsElapsed = 0
                        metronomeStatusText = "Tap 'Start 5-Second Pause Drill' the instant opposing counsel finishes speaking."
                    } label: {
                        Text("Reset")
                            .font(.subheadline.weight(.semibold))
                            .padding(.horizontal, 18)
                            .padding(.vertical, 14)
                            .background(MDEsqTheme.navyElevated)
                            .foregroundStyle(MDEsqTheme.ivory)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
        }
        .padding(20)
        .background(MDEsqTheme.navyCard)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    // MARK: - Reptile Countermeasures & 8 Cardinal Rules
    private var reptileSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("REPTILE THEORY VERBAL PIVOT FORMULAS")
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .foregroundStyle(MDEsqTheme.gold)

            ForEach(DepositionDatabase.reptileCountermeasures) { item in
                VStack(alignment: .leading, spacing: 6) {
                    Text(item.reptileQuestion)
                        .font(.system(size: 14, weight: .bold, design: .serif))
                        .foregroundStyle(MDEsqTheme.crimson)
                    Text("Trap: \(item.psychologicalTrap)")
                        .font(.caption)
                        .foregroundStyle(MDEsqTheme.slateMuted)
                    Text("Master Pivot: \(item.pivotFormula)")
                        .font(.system(size: 13.5, design: .serif))
                        .foregroundStyle(MDEsqTheme.emerald)
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(MDEsqTheme.navyElevated)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding(16)
        .background(MDEsqTheme.navyCard)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var cardinalRulesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("THE 8 CARDINAL DEPOSITION RULES")
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .foregroundStyle(MDEsqTheme.gold)

            ForEach(DepositionDatabase.cardinalRules) { rule in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("RULE #\(rule.number)")
                            .font(.system(size: 10, weight: .black, design: .monospaced))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(MDEsqTheme.gold)
                            .foregroundStyle(MDEsqTheme.obsidian)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                        Text(rule.subtitle)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(MDEsqTheme.goldLight)
                    }
                    Text(rule.title)
                        .font(.system(size: 17, weight: .bold, design: .serif))
                        .foregroundStyle(MDEsqTheme.ivory)
                    Text("Ambush Question: \(rule.trapExample)")
                        .font(.caption)
                        .italic()
                        .foregroundStyle(MDEsqTheme.parchment)
                    Text("❌ Fatal Concession: \(rule.badResponse)")
                        .font(.system(size: 12.5, design: .serif))
                        .foregroundStyle(MDEsqTheme.crimson)
                    Text("✅ Master Testimony: \(rule.masterResponse)")
                        .font(.system(size: 13, design: .serif))
                        .foregroundStyle(MDEsqTheme.emerald)
                    Text("Why It Matters: \(rule.takeaway)")
                        .font(.caption2)
                        .foregroundStyle(MDEsqTheme.slateMuted)
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(MDEsqTheme.navyElevated)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(16)
        .background(MDEsqTheme.navyCard)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}
