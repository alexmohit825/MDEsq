import SwiftUI

struct PeerReviewView: View {
    enum DefenseArena: String, CaseIterable {
        case hospitalHCQIA = "Hospital Peer Review (HCQIA)"
        case wmcBoard = "WA Medical Commission (WMC)"
    }

    @State private var selectedArena: DefenseArena = .hospitalHCQIA
    @State private var shamFactors: [ShamFactor] = PeerReviewDatabase.shamFactors
    @State private var suspensionStartDate: Date = Date()
    @State private var showNPDBMatrix: Bool = true
    @State private var copiedToast: String? = nil

    private var shamScore: Int {
        shamFactors.filter { $0.isSelected }.reduce(0) { $0 + $1.weight }
    }

    private var shamVerdict: (label: String, color: Color, advice: String) {
        switch shamScore {
        case 0...19:
            return (
                "LOW SHAM SIGNAL (PRESUMPTIVE HCQIA IMMUNITY)",
                MDEsqTheme.emerald,
                "Hospital proceedings currently appear aligned with baseline procedural checklists. Focus on winning the clinical merits with external academic peer review."
            )
        case 20...44:
            return (
                "MODERATE DUE PROCESS DEFECTS DETECTED",
                MDEsqTheme.amber,
                "Multiple deviations from 42 U.S.C. § 11112(b) fair procedure exist. Place formal written objections into the administrative record now to preserve waiver challenges."
            )
        default:
            return (
                "CRITICAL SHAM PEER REVIEW & BAD-FAITH RECORD",
                MDEsqTheme.crimson,
                "High probability that hospital has forfeited HCQIA immunity under 42 U.S.C. § 11112(a) and RCW 70.41.200. Prepare immediate demand for independent tribunal and evaluate Superior Court injunctive relief."
            )
        }
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                MDEsqTheme.obsidian.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        arenaPickerCard

                        if selectedArena == .hospitalHCQIA {
                            interactive30DayCliffCalculatorCard
                            shamIndexScoreboardCard
                            shamChecklistCard
                            suspensionPhasesCard
                            npdbMatrixCard
                        } else {
                            wmcExecutiveBannerCard
                            wmcFivePhasesCard
                            wmcCardinalRulesCard
                            wmcPhraseDisrupterCard
                            wmcSanctionsHierarchyCard
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    .padding(.bottom, 40)
                }

                if let toast = copiedToast {
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
            .navigationTitle("Peer Review & WMC Shield")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: - Segmented Mode Switcher
    private var arenaPickerCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Picker("Defense Arena", selection: $selectedArena) {
                ForEach(DefenseArena.allCases, id: \.self) { arena in
                    Text(arena.rawValue).tag(arena)
                }
            }
            .pickerStyle(.segmented)
            .onChange(of: selectedArena) { _, _ in
                MDEsqHaptics.selection()
            }
        }
    }

    // MARK: - Interactive 30-Day HCQIA Summary Suspension Countdown Calculator (Pillar III)
    private var interactive30DayCliffCalculatorCard: some View {
        let calendar = Calendar.current
        let day14Date = calendar.date(byAdding: .day, value: 14, to: suspensionStartDate) ?? suspensionStartDate
        let day29CliffDate = calendar.date(byAdding: .day, value: 29, to: suspensionStartDate) ?? suspensionStartDate
        let day31NPDBDate = calendar.date(byAdding: .day, value: 31, to: suspensionStartDate) ?? suspensionStartDate

        return VStack(alignment: .leading, spacing: 14) {
            HStack {
                Label("INTERACTIVE 30-DAY NPDB CLIFF CALCULATOR", systemImage: "clock.badge.exclamationmark.fill")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundStyle(MDEsqTheme.crimson)
                Spacer()
                Text("45 C.F.R. § 60.12")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundStyle(MDEsqTheme.gold)
            }

            Text("Summary Suspension / Restriction Deadline Tracker")
                .font(.system(size: 18, weight: .bold, design: .serif))
                .foregroundStyle(MDEsqTheme.ivory)

            DatePicker(
                "Date Summary Suspension Imposed:",
                selection: $suspensionStartDate,
                displayedComponents: .date
            )
            .font(.footnote.weight(.semibold))
            .foregroundStyle(MDEsqTheme.parchment)
            .tint(MDEsqTheme.gold)

            HStack(spacing: 10) {
                deadlineTile(
                    tag: "DAY 14",
                    title: "Abeyance / Bylaws Window",
                    date: day14Date,
                    color: MDEsqTheme.amber
                )
                deadlineTile(
                    tag: "DAY 29",
                    title: "Last Day to Lift Unreported",
                    date: day29CliffDate,
                    color: MDEsqTheme.gold
                )
                deadlineTile(
                    tag: "DAY 31",
                    title: "Mandatory NPDB Trigger",
                    date: day31NPDBDate,
                    color: MDEsqTheme.crimson
                )
            }

            Text("⚠️ NEVER RESIGN PRIVILEGES during this 30-day window. Under 45 C.F.R. § 60.12(a)(1)(ii), resigning while under investigation triggers an immediate, permanent NPDB report on Day 1—whereas lifting or staying a suspension on or before Day 30 avoids NPDB reporting entirely.")
                .font(.caption)
                .foregroundStyle(MDEsqTheme.parchment)
                .padding(10)
                .background(MDEsqTheme.crimson.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .padding(16)
        .background(MDEsqTheme.navyCard)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(MDEsqTheme.crimson.opacity(0.45), lineWidth: 1)
        )
    }

    private func deadlineTile(tag: String, title: String, date: Date, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(tag)
                .font(.system(size: 10, weight: .black, design: .monospaced))
                .foregroundStyle(color)
            Text(date.formatted(date: .abbreviated, time: .omitted))
                .font(.system(size: 13, weight: .bold, design: .monospaced))
                .foregroundStyle(MDEsqTheme.ivory)
            Text(title)
                .font(.system(size: 10))
                .foregroundStyle(MDEsqTheme.slateMuted)
                .lineLimit(2)
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(MDEsqTheme.navyElevated)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(color.opacity(0.35), lineWidth: 1)
        )
    }

    // MARK: - 10-Factor Sham Peer Review Scoreboard & Checklist
    private var shamIndexScoreboardCard: some View {
        let verdict = shamVerdict
        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("HCQIA SHAM PEER REVIEW DETECTOR (42 U.S.C. § 11112)")
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .foregroundStyle(MDEsqTheme.gold)
                    Text(verdict.label)
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(verdict.color)
                }
                Spacer()
                Text("\(shamScore)/100")
                    .font(.system(size: 26, weight: .black, design: .monospaced))
                    .foregroundStyle(verdict.color)
                    .contentTransition(.numericText())
            }

            ProgressView(value: Double(shamScore), total: 100)
                .tint(verdict.color)

            Text(verdict.advice)
                .font(.footnote)
                .foregroundStyle(MDEsqTheme.parchment)
        }
        .padding(16)
        .background(MDEsqTheme.navyCard)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(verdict.color.opacity(0.45), lineWidth: 1)
        )
    }

    private var shamChecklistCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("TAP ANY PROCEDURAL DEFECT PRESENT IN YOUR CASE")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundStyle(MDEsqTheme.gold)
                Spacer()
                if shamScore > 0 {
                    Button("Reset") {
                        MDEsqHaptics.selection()
                        for idx in shamFactors.indices {
                            shamFactors[idx].isSelected = false
                        }
                    }
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(MDEsqTheme.crimson)
                }
            }

            ForEach($shamFactors) { $factor in
                Button {
                    MDEsqHaptics.impactLight()
                    factor.isSelected.toggle()
                } label: {
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: factor.isSelected ? "checkmark.square.fill" : "square")
                            .font(.title3)
                            .foregroundStyle(factor.isSelected ? MDEsqTheme.crimson : MDEsqTheme.slateMuted)

                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(factor.title)
                                    .font(.subheadline.weight(.bold))
                                    .foregroundStyle(MDEsqTheme.ivory)
                                    .multilineTextAlignment(.leading)
                                Spacer()
                                Text("+\(factor.weight)")
                                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                                    .foregroundStyle(factor.isSelected ? MDEsqTheme.crimson : MDEsqTheme.gold)
                            }
                            Text(factor.description)
                                .font(.caption)
                                .foregroundStyle(MDEsqTheme.slateMuted)
                                .multilineTextAlignment(.leading)
                            if factor.isSelected {
                                Text("Evidence to Subpoena/Preserve: \(factor.evidenceRequired) (\(factor.statutoryRef))")
                                    .font(.system(size: 11, weight: .medium, design: .serif))
                                    .foregroundStyle(MDEsqTheme.goldLight)
                                    .padding(.top, 2)
                                    .multilineTextAlignment(.leading)
                            }
                        }
                    }
                    .padding(12)
                    .background(factor.isSelected ? MDEsqTheme.crimson.opacity(0.11) : MDEsqTheme.navyElevated)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(factor.isSelected ? MDEsqTheme.crimson.opacity(0.5) : MDEsqTheme.borderSubtle, lineWidth: 1)
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(16)
        .background(MDEsqTheme.navyCard)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var suspensionPhasesCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Label("4-PHASE SUMMARY SUSPENSION SURVIVAL PLAYBOOK", systemImage: "list.number")
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .foregroundStyle(MDEsqTheme.gold)

            ForEach(PeerReviewDatabase.suspensionPhases) { phase in
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(phase.dayRange)
                            .font(.system(size: 11, weight: .black, design: .monospaced))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(MDEsqTheme.gold)
                            .foregroundStyle(MDEsqTheme.obsidian)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                        Text(phase.urgencyLevel)
                            .font(.system(size: 10, weight: .bold, design: .monospaced))
                            .foregroundStyle(MDEsqTheme.crimson)
                    }
                    Text(phase.title)
                        .font(.system(size: 16, weight: .bold, design: .serif))
                        .foregroundStyle(MDEsqTheme.ivory)
                    Text(phase.legalReality)
                        .font(.caption)
                        .foregroundStyle(MDEsqTheme.parchment.opacity(0.9))
                    Text(phase.mandatoryAction)
                        .font(.system(size: 12.5, design: .serif))
                        .foregroundStyle(MDEsqTheme.goldLight)
                        .padding(10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(MDEsqTheme.obsidian.opacity(0.6))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .padding(12)
                .background(MDEsqTheme.navyElevated)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(16)
        .background(MDEsqTheme.navyCard)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var npdbMatrixCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("NPDB REPORTABILITY TRUTH MATRIX (45 C.F.R. PART 60)", systemImage: "tablecells.fill")
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .foregroundStyle(MDEsqTheme.gold)

            ForEach(PeerReviewDatabase.npdbMatrix) { item in
                let isSafe = item.reportableStatus.contains("NON-REPORTABLE")
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(item.reportableStatus)
                            .font(.system(size: 10, weight: .bold, design: .monospaced))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background((isSafe ? MDEsqTheme.emerald : MDEsqTheme.crimson).opacity(0.18))
                            .foregroundStyle(isSafe ? MDEsqTheme.emerald : MDEsqTheme.crimson)
                            .clipShape(Capsule())
                        Spacer()
                        Text(item.statutoryRule)
                            .font(.system(size: 10, design: .monospaced))
                            .foregroundStyle(MDEsqTheme.gold)
                    }
                    Text(item.scenario)
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(MDEsqTheme.ivory)
                    Text(item.strategicGuidance)
                        .font(.caption)
                        .foregroundStyle(MDEsqTheme.parchment)
                }
                .padding(12)
                .background(MDEsqTheme.navyElevated)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding(16)
        .background(MDEsqTheme.navyCard)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    // MARK: - Washington Medical Commission (WMC) Defense Arena
    private var wmcExecutiveBannerCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("WASHINGTON MEDICAL COMMISSION • RCW 18.71 & RCW 18.130", systemImage: "building.columns.circle.fill")
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .foregroundStyle(MDEsqTheme.gold)
            Text("WMC Letter of Cooperation (LOC) & STID Defense Shield")
                .font(.system(size: 20, weight: .bold, design: .serif))
                .foregroundStyle(MDEsqTheme.ivory)
            Text("How to respond to a 14-day RCW 18.130.180(8) Letter of Cooperation so the Reviewing Commission Member (RCM) closes your file at panel review without formal charges.")
                .font(.footnote)
                .foregroundStyle(MDEsqTheme.slateMuted)
        }
        .padding(16)
        .background(MDEsqTheme.navyCard)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var wmcFivePhasesCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("5-PHASE WMC INVESTIGATION ANATOMY")
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .foregroundStyle(MDEsqTheme.gold)

            ForEach(PeerReviewDatabase.wmcPhases) { phase in
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("PHASE \(phase.phaseNumber)")
                            .font(.system(size: 10, weight: .black, design: .monospaced))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(MDEsqTheme.gold)
                            .foregroundStyle(MDEsqTheme.obsidian)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                        Text(phase.timeline)
                            .font(.system(size: 11, weight: .semibold, design: .monospaced))
                            .foregroundStyle(MDEsqTheme.goldLight)
                        Spacer()
                        Text(phase.statutoryRef)
                            .font(.system(size: 10, design: .monospaced))
                            .foregroundStyle(MDEsqTheme.slateMuted)
                    }
                    Text(phase.title)
                        .font(.system(size: 16, weight: .bold, design: .serif))
                        .foregroundStyle(MDEsqTheme.ivory)
                    Text(phase.description)
                        .font(.caption)
                        .foregroundStyle(MDEsqTheme.parchment)
                    Text("Directive: \(phase.physicianDirective)")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(MDEsqTheme.emerald)
                }
                .padding(12)
                .background(MDEsqTheme.navyElevated)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding(16)
        .background(MDEsqTheme.navyCard)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var wmcCardinalRulesCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("5 CARDINAL RULES FOR THE 14-DAY LETTER OF COOPERATION")
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .foregroundStyle(MDEsqTheme.gold)

            ForEach(PeerReviewDatabase.wmcRules) { rule in
                VStack(alignment: .leading, spacing: 6) {
                    Text("Rule #\(rule.ruleNumber): \(rule.title)")
                        .font(.system(size: 15, weight: .bold, design: .serif))
                        .foregroundStyle(MDEsqTheme.ivory)
                    Text("Fatal Mistake: \(rule.fatalMistake)")
                        .font(.caption)
                        .foregroundStyle(MDEsqTheme.crimson)
                    Text("Executive Protocol: \(rule.executiveRule)")
                        .font(.caption)
                        .foregroundStyle(MDEsqTheme.parchment)
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

    private var wmcPhraseDisrupterCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("WMC WRITTEN NARRATIVE PHRASE DISRUPTERS")
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .foregroundStyle(MDEsqTheme.gold)

            ForEach(PeerReviewDatabase.wmcPhraseDisrupters) { item in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(item.context)
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(MDEsqTheme.ivory)
                        Spacer()
                        Button {
                            UIPasteboard.general.string = item.masterPhrase
                            MDEsqHaptics.success()
                            showCopied("Copied WMC Narrative Formula")
                        } label: {
                            Label("Copy Phrase", systemImage: "doc.on.doc")
                                .font(.caption2.weight(.bold))
                                .foregroundStyle(MDEsqTheme.emerald)
                        }
                    }
                    Text("❌ Avoid: \(item.toxicPhrase)")
                        .font(.system(size: 12.5, design: .serif))
                        .foregroundStyle(MDEsqTheme.crimson)
                    Text("✅ Master WMC Formulation: \(item.masterPhrase)")
                        .font(.system(size: 13, design: .serif))
                        .foregroundStyle(MDEsqTheme.emerald)
                }
                .padding(12)
                .background(MDEsqTheme.navyElevated)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding(16)
        .background(MDEsqTheme.navyCard)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var wmcSanctionsHierarchyCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("WMC SANCTIONS HIERARCHY (RCW 18.130.172 STID VS. AGREED ORDER)")
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .foregroundStyle(MDEsqTheme.gold)

            ForEach(PeerReviewDatabase.wmcSanctionTiers) { tier in
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(tier.tierName)
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(MDEsqTheme.ivory)
                        Spacer()
                        Text(tier.citation)
                            .font(.system(size: 10, design: .monospaced))
                            .foregroundStyle(MDEsqTheme.gold)
                    }
                    Text(tier.description)
                        .font(.caption)
                        .foregroundStyle(MDEsqTheme.parchment)
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

    private func showCopied(_ msg: String) {
        copiedToast = msg
        Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            if copiedToast == msg {
                copiedToast = nil
            }
        }
    }
}
