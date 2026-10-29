import SwiftUI
import StoreKit

struct MainTabView: View {
    @AppStorage("mdesq_appearance_mode") private var appearanceModeRaw: String = MDEsqAppearanceMode.sunlit.rawValue
    @State private var selectedTab: Int = 0
    @State private var showCrisisTriageSheet: Bool = false
    @State private var showAICopilotSheet: Bool = false
    @State private var showStatutesAndSettingsSheet: Bool = false

    private var currentAppearance: MDEsqAppearanceMode {
        MDEsqAppearanceMode(rawValue: appearanceModeRaw) ?? .sunlit
    }

    init() {
        let dynamicBarBg = UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? UIColor(red: 0.06, green: 0.09, blue: 0.16, alpha: 0.96)
                : UIColor(red: 0.96, green: 0.95, blue: 0.92, alpha: 0.96)
        }
        let dynamicTitleColor = UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? UIColor(red: 0.98, green: 0.98, blue: 0.96, alpha: 1.0)
                : UIColor(red: 0.06, green: 0.09, blue: 0.16, alpha: 1.0)
        }

        let tabAppearance = UITabBarAppearance()
        tabAppearance.configureWithDefaultBackground()
        tabAppearance.backgroundColor = dynamicBarBg
        UITabBar.appearance().standardAppearance = tabAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabAppearance

        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithDefaultBackground()
        navAppearance.backgroundColor = dynamicBarBg
        navAppearance.titleTextAttributes = [
            .foregroundColor: dynamicTitleColor,
            .font: UIFont.systemFont(ofSize: 17, weight: .bold)
        ]
        navAppearance.largeTitleTextAttributes = [
            .foregroundColor: dynamicTitleColor
        ]
        UINavigationBar.appearance().standardAppearance = navAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
    }

    private func cycleAppearanceMode() {
        MDEsqHaptics.selection()
        switch currentAppearance {
        case .sunlit:
            appearanceModeRaw = MDEsqAppearanceMode.midnight.rawValue
        case .midnight:
            appearanceModeRaw = MDEsqAppearanceMode.sunlit.rawValue
        case .system:
            appearanceModeRaw = MDEsqAppearanceMode.sunlit.rawValue
        }
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            TabView(selection: $selectedTab) {
                ContractAnalyzerView()
                    .tabItem {
                        Label("Contracts", systemImage: "doc.text.magnifyingglass")
                    }
                    .tag(0)

                PrecedentFinderView()
                    .tabItem {
                        Label("Precedents", systemImage: "books.vertical.fill")
                    }
                    .tag(1)

                PeerReviewView()
                    .tabItem {
                        Label("Peer / WMC", systemImage: "shield.lefthalf.filled")
                    }
                    .tag(2)

                DepositionMasterclassView()
                    .tabItem {
                        Label("Deposition", systemImage: "person.wave.2.fill")
                    }
                    .tag(3)

                FMVCalculatorView()
                    .tabItem {
                        Label("FMV & Stark", systemImage: "chart.bar.xaxis")
                    }
                    .tag(4)
            }
            .tint(MDEsqTheme.gold)

            // Floating Executive Command Dock (First-Hour Crisis 911 + AI Counsel + Theme Toggle + Statutes)
            HStack(spacing: 8) {
                Button {
                    MDEsqHaptics.impactMedium()
                    showCrisisTriageSheet = true
                } label: {
                    HStack(spacing: 5) {
                        Image(systemName: "bolt.shield.fill")
                        Text("Crisis 911")
                            .font(.system(size: 11.5, weight: .bold))
                    }
                    .padding(.horizontal, 11)
                    .padding(.vertical, 9)
                    .background(MDEsqTheme.crimson)
                    .foregroundStyle(Color.white)
                    .clipShape(Capsule())
                }

                Button {
                    MDEsqHaptics.impactMedium()
                    showAICopilotSheet = true
                } label: {
                    HStack(spacing: 5) {
                        Image(systemName: "sparkles")
                        Text("AI Counsel")
                            .font(.system(size: 11.5, weight: .bold))
                    }
                    .padding(.horizontal, 11)
                    .padding(.vertical, 9)
                    .background(MDEsqTheme.gold)
                    .foregroundStyle(MDEsqTheme.obsidian)
                    .clipShape(Capsule())
                }

                Button {
                    cycleAppearanceMode()
                } label: {
                    Image(systemName: currentAppearance == .midnight ? "sun.max.fill" : "moon.stars.fill")
                        .font(.system(size: 13, weight: .bold))
                        .padding(9)
                        .background(MDEsqTheme.navyCard)
                        .foregroundStyle(MDEsqTheme.gold)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(MDEsqTheme.borderSubtle, lineWidth: 1)
                        )
                }
                .accessibilityLabel("Toggle Sunlit or Midnight Theme")

                Button {
                    MDEsqHaptics.selection()
                    showStatutesAndSettingsSheet = true
                } label: {
                    Image(systemName: "text.book.closed.fill")
                        .font(.system(size: 13, weight: .bold))
                        .padding(9)
                        .background(MDEsqTheme.navyCard)
                        .foregroundStyle(MDEsqTheme.gold)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(MDEsqTheme.borderSubtle, lineWidth: 1)
                        )
                }
                .accessibilityLabel("Statutes and Settings")
            }
            .padding(.trailing, 14)
            .padding(.bottom, 62)
            .shadow(color: .black.opacity(0.18), radius: 10, y: 4)
        }
        .sheet(isPresented: $showCrisisTriageSheet) {
            CrisisPlaybookSheetView()
        }
        .sheet(isPresented: $showAICopilotSheet) {
            AILegalCopilotSheetView()
        }
        .sheet(isPresented: $showStatutesAndSettingsSheet) {
            StatutesAndSettingsSheetView()
        }
    }
}

// MARK: - First-Hour Physician Crisis Triage Command Center (Unique Survival Feature)
private struct CrisisPlaybookSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPlaybookID: String = CrisisPlaybookDatabase.allPlaybooks[0].id
    @State private var copiedToast: String? = nil

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                MDEsqTheme.obsidian.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        // Top Executive Alert Header
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Label("FIRST-HOUR PHYSICIAN CRISIS TRIAGE", systemImage: "bolt.shield.fill")
                                    .font(.system(size: 10, weight: .black, design: .monospaced))
                                    .foregroundStyle(MDEsqTheme.crimson)
                                Spacer()
                                Text("6 ACUTE PROTOCOLS")
                                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                                    .foregroundStyle(MDEsqTheme.gold)
                            }
                            Text("What to Do in the First 60 Minutes of a Legal Ambush")
                                .font(.system(size: 20, weight: .bold, design: .serif))
                                .foregroundStyle(MDEsqTheme.ivory)
                            Text("Physicians rarely lose their careers over the underlying clinical event—they lose them in the first 60 minutes through unrepresented concessions, coerced resignations, or EMR audit-log mistakes.")
                                .font(.footnote)
                                .foregroundStyle(MDEsqTheme.slateMuted)
                        }
                        .padding(16)
                        .background(MDEsqTheme.navyCard)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(MDEsqTheme.crimson.opacity(0.35), lineWidth: 1)
                        )

                        // Playbook Cards
                        ForEach(CrisisPlaybookDatabase.allPlaybooks) { item in
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text(item.badge)
                                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                                        .foregroundStyle(MDEsqTheme.gold)
                                    Spacer()
                                    Text(item.urgencyWindow)
                                        .font(.system(size: 9.5, weight: .black, design: .monospaced))
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 3)
                                        .background(MDEsqTheme.crimson.opacity(0.15))
                                        .foregroundStyle(MDEsqTheme.crimson)
                                        .clipShape(Capsule())
                                }

                                Text(item.title)
                                    .font(.system(size: 17, weight: .bold, design: .serif))
                                    .foregroundStyle(MDEsqTheme.ivory)

                                // Fatal Trap Box
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("FATAL FIRST-HOUR MISTAKE TO AVOID")
                                        .font(.system(size: 9.5, weight: .bold, design: .monospaced))
                                        .foregroundStyle(MDEsqTheme.crimson)
                                    Text(item.fatalTrap)
                                        .font(.caption)
                                        .foregroundStyle(MDEsqTheme.parchment)
                                }
                                .padding(10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(MDEsqTheme.crimson.opacity(0.08))
                                .clipShape(RoundedRectangle(cornerRadius: 10))

                                // Action Steps
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("MANDATORY ACTION PROTOCOL")
                                        .font(.system(size: 9.5, weight: .bold, design: .monospaced))
                                        .foregroundStyle(MDEsqTheme.emerald)
                                    ForEach(Array(item.first60MinutesSteps.enumerated()), id: \.offset) { idx, step in
                                        HStack(alignment: .top, spacing: 8) {
                                            Text("\(idx + 1).")
                                                .font(.system(size: 11, weight: .bold, design: .monospaced))
                                                .foregroundStyle(MDEsqTheme.gold)
                                            Text(step)
                                                .font(.caption)
                                                .foregroundStyle(MDEsqTheme.ivory)
                                        }
                                    }
                                }

                                // Verbatim Script Box
                                VStack(alignment: .leading, spacing: 6) {
                                    HStack {
                                        Text("VERBATIM PROTECTIVE STATEMENT / EMAIL")
                                            .font(.system(size: 9.5, weight: .bold, design: .monospaced))
                                            .foregroundStyle(MDEsqTheme.gold)
                                        Spacer()
                                        Button {
                                            UIPasteboard.general.string = item.verbatimScript
                                            MDEsqHaptics.success()
                                            copiedToast = "Copied Protective Script"
                                            Task {
                                                try? await Task.sleep(nanoseconds: 2_000_000_000)
                                                copiedToast = nil
                                            }
                                        } label: {
                                            Label("Copy Script", systemImage: "doc.on.doc")
                                                .font(.caption2.weight(.bold))
                                                .padding(.horizontal, 9)
                                                .padding(.vertical, 4)
                                                .background(MDEsqTheme.gold.opacity(0.18))
                                                .foregroundStyle(MDEsqTheme.gold)
                                                .clipShape(Capsule())
                                        }
                                    }
                                    Text(item.verbatimScript)
                                        .font(.system(size: 13, design: .serif))
                                        .italic()
                                        .foregroundStyle(MDEsqTheme.ivory)
                                        .padding(10)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(MDEsqTheme.navyElevated)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                }

                                Text("Authority: \(item.statutoryAnchor)")
                                    .font(.system(size: 10, design: .monospaced))
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
                    }
                    .padding(16)
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
            .navigationTitle("First-Hour Crisis Triage")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundStyle(MDEsqTheme.gold)
                }
            }
        }
    }
}

// MARK: - Global AI Legal Copilot Sheet (Cloudflare Edge + On-Device PHI Sanitizer)
private struct AILegalCopilotSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var userQuestion: String = ""
    @State private var conversationHistory: [(role: String, text: String, phiRedacted: Int)] = [
        (
            role: "assistant",
            text: "MD Esq. Executive Legal Copilot online. Ask any question regarding Washington physician non-competes (RCW 49.62), physician invention protection (RCW 49.44.140), WMC 14-day Letters of Cooperation (RCW 18.130.180), HCQIA 30-day summary suspensions, or Stark Law FMV safe harbors. On-device PHI scrubbing is active.",
            phiRedacted: 0
        )
    ]
    @State private var isThinking: Bool = false

    private let quickPrompts = [
        "How do I void a 25-mile hospital non-compete in WA under RCW 49.62?",
        "Can my hospital claim ownership of a medical app I built at home (RCW 49.44.140)?",
        "I just received a 14-day WMC Letter of Cooperation. What are my first 3 steps?",
        "Give me a Reptile defense answer for an incidental durotomy deposition question."
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                MDEsqTheme.obsidian.ignoresSafeArea()

                VStack(spacing: 0) {
                    // HIPAA / PHI Shield Banner
                    HStack(spacing: 8) {
                        Image(systemName: "lock.shield.fill")
                            .foregroundStyle(MDEsqTheme.emerald)
                        Text("On-Device Regex PHI Scrubber Active • Zero API Key Exposure (Cloudflare Edge)")
                            .font(.system(size: 10, weight: .bold, design: .monospaced))
                            .foregroundStyle(MDEsqTheme.emerald)
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(MDEsqTheme.emerald.opacity(0.1))

                    ScrollView {
                        VStack(alignment: .leading, spacing: 14) {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(quickPrompts, id: \.self) { preset in
                                        Button {
                                            userQuestion = preset
                                            sendQuestion()
                                        } label: {
                                            Text(preset)
                                                .font(.caption)
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 8)
                                                .background(MDEsqTheme.navyElevated)
                                                .foregroundStyle(MDEsqTheme.parchment)
                                                .clipShape(Capsule())
                                        }
                                    }
                                }
                            }

                            ForEach(Array(conversationHistory.enumerated()), id: \.offset) { _, msg in
                                VStack(alignment: .leading, spacing: 6) {
                                    HStack {
                                        Text(msg.role == "user" ? "PHYSICIAN INQUIRY" : "MD ESQ. STATUTORY COPILOT")
                                            .font(.system(size: 9, weight: .bold, design: .monospaced))
                                            .foregroundStyle(msg.role == "user" ? MDEsqTheme.slateMuted : MDEsqTheme.gold)
                                        if msg.phiRedacted > 0 {
                                            Text("\(msg.phiRedacted) PHI Token(s) Scrubbed On-Device")
                                                .font(.system(size: 9, weight: .bold, design: .monospaced))
                                                .foregroundStyle(MDEsqTheme.emerald)
                                        }
                                        Spacer()
                                        if msg.role == "assistant" {
                                            Button {
                                                UIPasteboard.general.string = msg.text
                                                MDEsqHaptics.success()
                                            } label: {
                                                Image(systemName: "doc.on.doc")
                                                    .font(.caption2)
                                                    .foregroundStyle(MDEsqTheme.goldLight)
                                            }
                                        }
                                    }

                                    Text(msg.text)
                                        .font(.system(size: 13.5, design: msg.role == "assistant" ? .serif : .default))
                                        .foregroundStyle(MDEsqTheme.ivory)
                                }
                                .padding(14)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(msg.role == "user" ? MDEsqTheme.navyElevated : MDEsqTheme.navyCard)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(msg.role == "assistant" ? MDEsqTheme.borderSubtle : Color.clear, lineWidth: 1)
                                )
                            }

                            if isThinking {
                                HStack(spacing: 10) {
                                    ProgressView().tint(MDEsqTheme.gold)
                                    Text("Analyzing RCW & Federal Statutory Authority…")
                                        .font(.caption)
                                        .foregroundStyle(MDEsqTheme.goldLight)
                                }
                                .padding(12)
                            }
                        }
                        .padding(16)
                    }

                    // Input Bar
                    HStack(spacing: 10) {
                        TextField("Ask a contract, WMC, peer review, or deposition question…", text: $userQuestion)
                            .font(.subheadline)
                            .foregroundStyle(MDEsqTheme.ivory)
                            .padding(12)
                            .background(MDEsqTheme.navyCard)
                            .clipShape(RoundedRectangle(cornerRadius: 12))

                        Button {
                            sendQuestion()
                        } label: {
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.system(size: 32))
                                .foregroundStyle(userQuestion.trimmingCharacters(in: .whitespaces).isEmpty ? MDEsqTheme.slateMuted : MDEsqTheme.gold)
                        }
                        .disabled(userQuestion.trimmingCharacters(in: .whitespaces).isEmpty || isThinking)
                    }
                    .padding(14)
                    .background(MDEsqTheme.navyElevated)
                }
            }
            .navigationTitle("AI Medicolegal Copilot")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundStyle(MDEsqTheme.gold)
                }
            }
        }
    }

    private func sendQuestion() {
        let raw = userQuestion.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !raw.isEmpty else { return }
        userQuestion = ""
        let scrubbed = PHISanitizer.scrub(raw)
        conversationHistory.append((role: "user", text: scrubbed.sanitizedText, phiRedacted: scrubbed.redactedCount))
        isThinking = true

        Task {
            let reply = await MDEsqEdgeAIClient.shared.askCopilot(
                prompt: scrubbed.sanitizedText,
                systemContext: "Interactive Physician Legal Copilot Sheet."
            )
            await MainActor.run {
                conversationHistory.append((role: "assistant", text: reply, phiRedacted: 0))
                isThinking = false
                MDEsqHaptics.success()
            }
        }
    }
}

// MARK: - Statutory Codebook, Appearance Switcher & Ungated App Store Review Sheet (Rule 7 Compliant)
private struct StatutesAndSettingsSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.requestReview) private var requestReview
    @AppStorage("mdesq_appearance_mode") private var appearanceModeRaw: String = MDEsqAppearanceMode.sunlit.rawValue

    var body: some View {
        NavigationStack {
            ZStack {
                MDEsqTheme.obsidian.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Display & Editorial Theme Picker Card
                        VStack(alignment: .leading, spacing: 10) {
                            Label("EDITORIAL FOLIO APPEARANCE", systemImage: "sun.max.fill")
                                .font(.system(size: 10, weight: .bold, design: .monospaced))
                                .foregroundStyle(MDEsqTheme.gold)
                            Text("Choose between high-contrast Sunlit Alabaster for bright clinic/hospital environments or Midnight Chambers for low-light reading.")
                                .font(.caption)
                                .foregroundStyle(MDEsqTheme.slateMuted)

                            Picker("Appearance Mode", selection: $appearanceModeRaw) {
                                ForEach(MDEsqAppearanceMode.allCases, id: \.rawValue) { mode in
                                    Text(mode.rawValue).tag(mode.rawValue)
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                        .padding(16)
                        .background(MDEsqTheme.navyCard)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(MDEsqTheme.borderSubtle, lineWidth: 1)
                        )

                        // Rule 7 Persistent Ungated In-App Rating & Review Card
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "star.bubble.fill")
                                    .font(.title3)
                                    .foregroundStyle(MDEsqTheme.gold)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Built by a Surgeon to Protect Physicians")
                                        .font(.system(size: 16, weight: .bold, design: .serif))
                                        .foregroundStyle(MDEsqTheme.ivory)
                                    Text("MD Esq. is the only native medicolegal survival suite engineered specifically for physicians facing predatory hospital contracts, sham peer review, and courtroom cross-examination.")
                                        .font(.caption)
                                        .foregroundStyle(MDEsqTheme.slateMuted)
                                }
                            }

                            Button {
                                MDEsqHaptics.impactLight()
                                requestReview()
                            } label: {
                                Label("Rate MD Esq. on the App Store", systemImage: "star.fill")
                                    .font(.caption.weight(.bold))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 11)
                                    .background(MDEsqTheme.gold)
                                    .foregroundStyle(MDEsqTheme.obsidian)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                        .padding(16)
                        .background(MDEsqTheme.navyCard)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(MDEsqTheme.gold.opacity(0.45), lineWidth: 1)
                        )

                        // Washington State & Federal Statutory Codebook
                        VStack(alignment: .leading, spacing: 12) {
                            Text("WASHINGTON STATE & FEDERAL STATUTORY CODEBOOK")
                                .font(.system(size: 10, weight: .bold, design: .monospaced))
                                .foregroundStyle(MDEsqTheme.gold)

                            ForEach(StatutoryDatabase.allStatutes) { stat in
                                VStack(alignment: .leading, spacing: 6) {
                                    HStack {
                                        Text(stat.jurisdiction)
                                            .font(.system(size: 10, weight: .bold, design: .monospaced))
                                            .padding(.horizontal, 7)
                                            .padding(.vertical, 2)
                                            .background(MDEsqTheme.gold.opacity(0.2))
                                            .foregroundStyle(MDEsqTheme.gold)
                                            .clipShape(Capsule())
                                        Text(stat.code)
                                            .font(.system(size: 12, weight: .bold, design: .monospaced))
                                            .foregroundStyle(MDEsqTheme.goldLight)
                                    }
                                    Text(stat.title)
                                        .font(.system(size: 15, weight: .bold, design: .serif))
                                        .foregroundStyle(MDEsqTheme.ivory)
                                    Text(stat.summary)
                                        .font(.caption)
                                        .foregroundStyle(MDEsqTheme.parchment)
                                    Text("Physician Impact: \(stat.clinicalImpact)")
                                        .font(.caption2.weight(.semibold))
                                        .foregroundStyle(MDEsqTheme.emerald)
                                }
                                .padding(12)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(MDEsqTheme.navyCard)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(MDEsqTheme.borderSubtle, lineWidth: 1)
                                )
                            }
                        }

                        // Legal Disclaimer & Copyright Footer (Rule 7)
                        VStack(alignment: .leading, spacing: 6) {
                            Text("LEGAL & REGULATORY NOTICE")
                                .font(.system(size: 10, weight: .bold, design: .monospaced))
                                .foregroundStyle(MDEsqTheme.slateMuted)
                            Text("MD Esq. provides statutory reference architecture, quantitative Fair Market Value benchmarking, and contract redline drafting intelligence for licensed physicians and surgeons. Use of this application does not create an attorney-client relationship. Always verify final contract execution and formal administrative filings with retained legal counsel in your jurisdiction.")
                                .font(.caption2)
                                .foregroundStyle(MDEsqTheme.slateMuted)
                            Text("© 2026 A. Alex Mohit. All rights reserved.")
                                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                                .foregroundStyle(MDEsqTheme.gold)
                                .padding(.top, 4)
                        }
                        .padding(16)
                        .background(MDEsqTheme.navyCard)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding(16)
                }
            }
            .navigationTitle("Codebook & Appearance")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundStyle(MDEsqTheme.gold)
                }
            }
        }
    }
}
