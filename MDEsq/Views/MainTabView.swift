import SwiftUI
import StoreKit

struct MainTabView: View {
    @State private var selectedTab: Int = 0
    @State private var showAICopilotSheet: Bool = false
    @State private var showStatutesAndSettingsSheet: Bool = false

    init() {
        let tabAppearance = UITabBarAppearance()
        tabAppearance.configureWithOpaqueBackground()
        tabAppearance.backgroundColor = UIColor(red: 0.04, green: 0.06, blue: 0.11, alpha: 0.98)
        UITabBar.appearance().standardAppearance = tabAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabAppearance

        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithOpaqueBackground()
        navAppearance.backgroundColor = UIColor(red: 0.04, green: 0.06, blue: 0.11, alpha: 0.98)
        navAppearance.titleTextAttributes = [
            .foregroundColor: UIColor(red: 0.96, green: 0.95, blue: 0.91, alpha: 1.0),
            .font: UIFont.systemFont(ofSize: 17, weight: .bold)
        ]
        UINavigationBar.appearance().standardAppearance = navAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
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

            // Floating Executive Action Pill (AI Legal Copilot + Statutory Reference & Settings)
            HStack(spacing: 8) {
                Button {
                    MDEsqHaptics.impactMedium()
                    showAICopilotSheet = true
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "sparkles")
                        Text("AI Counsel")
                            .font(.system(size: 12, weight: .bold))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 9)
                    .background(MDEsqTheme.gold)
                    .foregroundStyle(MDEsqTheme.obsidian)
                    .clipShape(Capsule())
                }

                Button {
                    MDEsqHaptics.selection()
                    showStatutesAndSettingsSheet = true
                } label: {
                    Image(systemName: "text.book.closed.fill")
                        .font(.system(size: 13, weight: .bold))
                        .padding(9)
                        .background(MDEsqTheme.navyElevated)
                        .foregroundStyle(MDEsqTheme.goldLight)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(MDEsqTheme.gold.opacity(0.45), lineWidth: 1)
                        )
                }
            }
            .padding(.trailing, 16)
            .padding(.bottom, 64)
            .shadow(color: .black.opacity(0.5), radius: 8, y: 4)
        }
        .sheet(isPresented: $showAICopilotSheet) {
            AILegalCopilotSheetView()
        }
        .sheet(isPresented: $showStatutesAndSettingsSheet) {
            StatutesAndSettingsSheetView()
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
            text: "MD Esq. Executive Legal Copilot online. Ask any question regarding Washington physician non-competes (RCW 49.62), WMC 14-day Letters of Cooperation (RCW 18.130.180), HCQIA 30-day summary suspensions, or Stark Law FMV safe harbors. On-device PHI scrubbing is active.",
            phiRedacted: 0
        )
    ]
    @State private var isThinking: Bool = false

    private let quickPrompts = [
        "How do I void a 25-mile hospital non-compete in WA under RCW 49.62?",
        "I just received a 14-day WMC Letter of Cooperation. What are my first 3 steps?",
        "How do I demand tail coverage if the hospital changes my call schedule?",
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

// MARK: - Statutory Codebook & Ungated App Store Review Sheet (Rule 7 Compliant)
private struct StatutesAndSettingsSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.requestReview) private var requestReview

    var body: some View {
        NavigationStack {
            ZStack {
                MDEsqTheme.obsidian.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Rule 7 Persistent Ungated In-App Rating & Review Card
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "star.bubble.fill")
                                    .font(.title3)
                                    .foregroundStyle(MDEsqTheme.gold)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Support Physician Medicolegal Autonomy")
                                        .font(.system(size: 16, weight: .bold, design: .serif))
                                        .foregroundStyle(MDEsqTheme.ivory)
                                    Text("If MD Esq. helped you audit an employment agreement or prepare for a peer review / deposition, your rating helps fellow physicians discover the suite.")
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
            .navigationTitle("Statutory Codebook & Info")
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
