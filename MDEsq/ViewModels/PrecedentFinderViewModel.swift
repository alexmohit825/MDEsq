import Foundation
import SwiftUI
import Speech
import AVFoundation

struct ScoredPrecedent: Identifiable, Hashable {
    let precedent: LegalPrecedent
    let matchScore: Int // 0...100
    let matchedKeywords: [String]
    var id: String { precedent.id }
}

@MainActor
final class PrecedentFinderViewModel: ObservableObject {
    @Published var searchQuery: String = ""
    @Published var selectedJurisdiction: String = "ALL"
    @Published var scoredResults: [ScoredPrecedent] = []
    @Published var isRecordingVoice: Bool = false
    @Published var voiceErrorMessage: String? = nil
    @Published var isSynthesizingAI: Bool = false
    @Published var aiCaseSynthesis: String? = nil
    @Published var copiedToast: String? = nil

    let jurisdictions = ["ALL", "WA", "OR", "CA", "NY"]

    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()

    init() {
        performSearch()
    }

    func applyPreset(_ preset: PrecedentScenarioPreset) {
        MDEsqHaptics.impactLight()
        searchQuery = preset.queryText
        aiCaseSynthesis = nil
        performSearch()
    }

    func selectJurisdiction(_ code: String) {
        MDEsqHaptics.selection()
        selectedJurisdiction = code
        performSearch()
    }

    func performSearch() {
        let pool: [LegalPrecedent]
        if selectedJurisdiction == "ALL" {
            pool = PrecedentDatabase.allPrecedents
        } else {
            pool = PrecedentDatabase.allPrecedents.filter { $0.jurisdiction == selectedJurisdiction }
        }

        let trimmed = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !trimmed.isEmpty else {
            scoredResults = pool.map {
                ScoredPrecedent(
                    precedent: $0,
                    matchScore: $0.jurisdiction == "WA" ? 96 : 88,
                    matchedKeywords: Array($0.keywords.prefix(3))
                )
            }
            return
        }

        let queryTokens = trimmed
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { $0.count >= 2 }

        var scored: [ScoredPrecedent] = []

        for item in pool {
            var rawPoints = 0
            var matched: [String] = []

            let searchableBlob = [
                item.caseName,
                item.specialty,
                item.category,
                item.holding,
                item.statutoryRef,
                item.defenseStrategy,
                item.defensiveChartingDirective
            ].joined(separator: " ").lowercased()

            for kw in item.keywords {
                let lowerKW = kw.lowercased()
                if trimmed.contains(lowerKW) {
                    rawPoints += 28
                    matched.append(kw)
                } else {
                    for token in queryTokens where lowerKW.contains(token) {
                        rawPoints += 16
                        if !matched.contains(kw) {
                            matched.append(kw)
                        }
                    }
                }
            }

            for token in queryTokens {
                if searchableBlob.contains(token) {
                    rawPoints += 12
                    if !matched.contains(token) {
                        matched.append(token)
                    }
                }
            }

            if item.jurisdiction == "WA" && rawPoints > 0 {
                rawPoints += 8 // Primary WA statutory anchor boost
            }

            if rawPoints > 0 {
                let normalizedScore = min(99, max(55, 50 + rawPoints))
                scored.append(
                    ScoredPrecedent(
                        precedent: item,
                        matchScore: normalizedScore,
                        matchedKeywords: Array(matched.prefix(5))
                    )
                )
            }
        }

        if scored.isEmpty {
            scoredResults = pool.map {
                ScoredPrecedent(
                    precedent: $0,
                    matchScore: 65,
                    matchedKeywords: Array($0.keywords.prefix(2))
                )
            }
        } else {
            scoredResults = scored.sorted { $0.matchScore > $1.matchScore }
        }
    }

    // MARK: - Live AI Custom Clinical Case Strategy (Cloudflare Edge Worker)
    func requestAICaseStrategy() async {
        let query = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return }
        MDEsqHaptics.impactMedium()
        isSynthesizingAI = true
        defer { isSynthesizingAI = false }

        let topCitations = scoredResults.prefix(3).map { "\($0.precedent.caseName) (\($0.precedent.citation)) — \($0.precedent.statutoryRef)" }.joined(separator: "; ")

        let prompt = """
        Clinical / Medicolegal Scenario Described by Physician: "\(query)"
        Target Jurisdiction Filter: \(selectedJurisdiction)
        Relevant Indexed Precedents: \(topCitations)
        
        Deliver a concise, 3-part Executive Defense Brief:
        1. STATUTORY & CASE LAW SHIELD (how RCW 7.70.040 / WPI 105.08 or applicable state precedent insulates this clinical decision)
        2. PRIMARY PLAINTIFF ATTACK VECTOR TO ANTICIPATE
        3. CONTEMPORANEOUS OPERATIVE / PROGRESS NOTE CHARTING FORMULA (exact quotation-ready language to enter into the EMR today)
        """

        let result = await MDEsqEdgeAIClient.shared.askCopilot(
            prompt: prompt,
            systemContext: "Module: Malpractice Precedent & Defensive Charting Engine."
        )
        aiCaseSynthesis = result
        MDEsqHaptics.success()
    }

    // MARK: - Voice Dictation Support
    func toggleVoiceDictation() {
        if isRecordingVoice {
            stopRecording()
        } else {
            startRecording()
        }
    }

    private func startRecording() {
        voiceErrorMessage = nil
        SFSpeechRecognizer.requestAuthorization { [weak self] status in
            Task { @MainActor in
                guard let self = self else { return }
                guard status == .authorized else {
                    self.voiceErrorMessage = "Speech recognition permission not granted in Settings."
                    return
                }
                self.beginAudioSession()
            }
        }
    }

    private func beginAudioSession() {
        recognitionTask?.cancel()
        recognitionTask = nil

        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            voiceErrorMessage = "Unable to initialize microphone session."
            return
        }

        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        self.recognitionRequest = request

        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.removeTap(onBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            request.append(buffer)
        }

        audioEngine.prepare()
        do {
            try audioEngine.start()
            isRecordingVoice = true
            MDEsqHaptics.impactMedium()
        } catch {
            voiceErrorMessage = "Audio engine failed to start."
            return
        }

        recognitionTask = speechRecognizer?.recognitionTask(with: request) { [weak self] result, error in
            Task { @MainActor in
                guard let self = self else { return }
                if let result = result {
                    self.searchQuery = result.bestTranscription.formattedString
                    self.performSearch()
                }
                if error != nil || (result?.isFinal == true) {
                    self.stopRecording()
                }
            }
        }
    }

    func stopRecording() {
        if audioEngine.isRunning {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
        }
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        recognitionRequest = nil
        recognitionTask = nil
        isRecordingVoice = false
    }

    func showCopiedToast(_ message: String) {
        copiedToast = message
        Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            if copiedToast == message {
                copiedToast = nil
            }
        }
    }
}
