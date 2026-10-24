import SwiftUI

struct PrecedentFinderView: View {
    @StateObject private var viewModel = PrecedentFinderViewModel()

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                MDEsqTheme.obsidian.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        headerCard
                        searchAndDictationCard
                        presetPillsBar
                        jurisdictionFilterBar
                        if let aiBrief = viewModel.aiCaseSynthesis {
                            aiSynthesisCard(brief: aiBrief)
                        }
                        precedentsListSection
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
            .navigationTitle("Malpractice Precedents")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Label("APPELLATE CASE LAW & DEFENSIVE CHARTING", systemImage: "books.vertical.fill")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundStyle(MDEsqTheme.gold)
                Spacer()
                Text("WA • OR • CA • NY")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundStyle(MDEsqTheme.goldLight)
            }
            Text("Statutory Malpractice Shield & Charting Formulas")
                .font(.system(size: 21, weight: .bold, design: .serif))
                .foregroundStyle(MDEsqTheme.ivory)
            Text("Describe or dictate a clinical complication to retrieve controlling appellate holdings (RCW 7.70, WPI 105.08) and copy courtroom-tested operative note language.")
                .font(.footnote)
                .foregroundStyle(MDEsqTheme.slateMuted)
        }
        .padding(16)
        .background(MDEsqTheme.navyCard)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(MDEsqTheme.borderSubtle, lineWidth: 1)
        )
    }

    private var searchAndDictationCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(MDEsqTheme.gold)
                TextField("Describe scenario (e.g. dural tear, delayed stroke, refusal)...", text: $viewModel.searchQuery)
                    .font(.subheadline)
                    .foregroundStyle(MDEsqTheme.ivory)
                    .onChange(of: viewModel.searchQuery) { _, _ in
                        viewModel.performSearch()
                    }

                if !viewModel.searchQuery.isEmpty {
                    Button {
                        viewModel.searchQuery = ""
                        viewModel.aiCaseSynthesis = nil
                        viewModel.performSearch()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(MDEsqTheme.slateMuted)
                    }
                }

                Button {
                    viewModel.toggleVoiceDictation()
                } label: {
                    Image(systemName: viewModel.isRecordingVoice ? "waveform.circle.fill" : "mic.circle.fill")
                        .font(.title2)
                        .foregroundStyle(viewModel.isRecordingVoice ? MDEsqTheme.crimson : MDEsqTheme.gold)
                }
            }
            .padding(12)
            .background(MDEsqTheme.obsidian)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(viewModel.isRecordingVoice ? MDEsqTheme.crimson : MDEsqTheme.borderSubtle, lineWidth: 1)
            )

            if let voiceErr = viewModel.voiceErrorMessage {
                Text(voiceErr)
                    .font(.caption2)
                    .foregroundStyle(MDEsqTheme.amber)
            }

            HStack(spacing: 10) {
                Button {
                    Task {
                        await viewModel.requestAICaseStrategy()
                    }
                } label: {
                    HStack(spacing: 6) {
                        if viewModel.isSynthesizingAI {
                            ProgressView()
                                .tint(MDEsqTheme.obsidian)
                                .scaleEffect(0.8)
                            Text("Synthesizing Custom Defense Strategy & EMR Note…")
                                .font(.caption.weight(.bold))
                        } else {
                            Image(systemName: "sparkles")
                            Text("Synthesize Custom AI Defense Brief & EMR SmartPhrase")
                                .font(.caption.weight(.bold))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 11)
                    .background(viewModel.searchQuery.trimmingCharacters(in: .whitespaces).isEmpty ? MDEsqTheme.navyElevated : MDEsqTheme.gold)
                    .foregroundStyle(viewModel.searchQuery.trimmingCharacters(in: .whitespaces).isEmpty ? MDEsqTheme.slateMuted : MDEsqTheme.obsidian)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .disabled(viewModel.searchQuery.trimmingCharacters(in: .whitespaces).isEmpty || viewModel.isSynthesizingAI)
            }
        }
        .padding(14)
        .background(MDEsqTheme.navyCard)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(MDEsqTheme.borderSubtle, lineWidth: 1)
        )
    }

    private var presetPillsBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(PrecedentDatabase.scenarioPresets) { preset in
                    Button {
                        viewModel.applyPreset(preset)
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: preset.icon)
                                .font(.caption)
                            Text(preset.label)
                                .font(.caption.weight(.semibold))
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(MDEsqTheme.navyElevated)
                        .foregroundStyle(MDEsqTheme.parchment)
                        .clipShape(Capsule())
                        .overlay(
                            Capsule()
                                .stroke(MDEsqTheme.gold.opacity(0.35), lineWidth: 1)
                        )
                    }
                }
            }
        }
    }

    private var jurisdictionFilterBar: some View {
        HStack(spacing: 8) {
            ForEach(viewModel.jurisdictions, id: \.self) { code in
                let isSelected = viewModel.selectedJurisdiction == code
                Button {
                    viewModel.selectJurisdiction(code)
                } label: {
                    Text(code == "ALL" ? "ALL STATES" : code)
                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(isSelected ? MDEsqTheme.gold : MDEsqTheme.navyCard)
                        .foregroundStyle(isSelected ? MDEsqTheme.obsidian : MDEsqTheme.slateMuted)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
    }

    private func aiSynthesisCard(brief: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Label("AI EDGE CUSTOM CASE DEFENSE & CHARTING FORMULA", systemImage: "sparkles")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundStyle(MDEsqTheme.gold)
                Spacer()
                Button {
                    UIPasteboard.general.string = brief
                    MDEsqHaptics.success()
                    viewModel.showCopiedToast("Copied AI Defense Brief")
                } label: {
                    Label("Copy", systemImage: "doc.on.doc")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(MDEsqTheme.goldLight)
                }
            }
            Text(brief)
                .font(.system(size: 13.5, design: .serif))
                .foregroundStyle(MDEsqTheme.ivory)
        }
        .padding(16)
        .background(MDEsqTheme.gold.opacity(0.11))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(MDEsqTheme.gold, lineWidth: 1)
        )
    }

    private var precedentsListSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            ForEach(viewModel.scoredResults) { item in
                PrecedentFolioCard(
                    scored: item,
                    onCopyChartingFormula: {
                        UIPasteboard.general.string = item.precedent.defensiveChartingDirective
                        MDEsqHaptics.success()
                        viewModel.showCopiedToast("Copied Defensive Charting Formula")
                    }
                )
            }
        }
    }
}

private struct PrecedentFolioCard: View {
    let scored: ScoredPrecedent
    let onCopyChartingFormula: () -> Void

    private var p: LegalPrecedent { scored.precedent }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Jurisdiction & Match Badge Row
            HStack {
                Text(p.jurisdiction)
                    .font(.system(size: 11, weight: .black, design: .monospaced))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(MDEsqTheme.gold)
                    .foregroundStyle(MDEsqTheme.obsidian)
                    .clipShape(RoundedRectangle(cornerRadius: 6))

                Text(p.statutoryRef)
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .foregroundStyle(MDEsqTheme.goldLight)

                Spacer()

                Text("\(scored.matchScore)% MATCH")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(MDEsqTheme.emerald.opacity(0.18))
                    .foregroundStyle(MDEsqTheme.emerald)
                    .clipShape(Capsule())
            }

            // Case Name & Citation in New York Serif
            VStack(alignment: .leading, spacing: 2) {
                Text(p.caseName)
                    .font(.system(size: 19, weight: .bold, design: .serif))
                    .foregroundStyle(MDEsqTheme.ivory)
                Text("\(p.citation) • \(p.court)")
                    .font(.system(size: 12, design: .serif))
                    .italic()
                    .foregroundStyle(MDEsqTheme.parchment.opacity(0.85))
            }

            HStack(spacing: 8) {
                Label(p.specialty, systemImage: "stethoscope")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(MDEsqTheme.slateMuted)
                Text("•")
                    .foregroundStyle(MDEsqTheme.slateMuted)
                Text(p.verdictOutcome)
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(MDEsqTheme.emerald)
            }

            // Controlling Appellate Holding
            VStack(alignment: .leading, spacing: 4) {
                Text("CONTROLLING APPELLATE HOLDING")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundStyle(MDEsqTheme.slateMuted)
                Text(p.holding)
                    .font(.system(size: 13.5, design: .serif))
                    .foregroundStyle(MDEsqTheme.ivory.opacity(0.95))
            }

            // Defense Litigation Strategy
            VStack(alignment: .leading, spacing: 4) {
                Text("LITIGATION DEFENSE STRATEGY")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundStyle(MDEsqTheme.gold)
                Text(p.defenseStrategy)
                    .font(.footnote)
                    .foregroundStyle(MDEsqTheme.parchment)
            }

            // Defensive Operative / EMR Charting Formula
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Label("PROTECTIVE EMR / OPERATIVE NOTE FORMULA", systemImage: "heart.text.square.fill")
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .foregroundStyle(MDEsqTheme.emerald)
                    Spacer()
                    Button(action: onCopyChartingFormula) {
                        Label("Copy SmartPhrase", systemImage: "doc.on.doc")
                            .font(.system(size: 11, weight: .bold))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(MDEsqTheme.emerald.opacity(0.2))
                            .foregroundStyle(MDEsqTheme.emerald)
                            .clipShape(Capsule())
                    }
                }
                Text(p.defensiveChartingDirective)
                    .font(.system(size: 13, design: .serif))
                    .foregroundStyle(MDEsqTheme.ivory)
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(MDEsqTheme.emerald.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(MDEsqTheme.emerald.opacity(0.35), lineWidth: 1)
                    )
            }
        }
        .padding(16)
        .background(MDEsqTheme.navyCard)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(MDEsqTheme.borderSubtle, lineWidth: 1)
        )
    }
}
