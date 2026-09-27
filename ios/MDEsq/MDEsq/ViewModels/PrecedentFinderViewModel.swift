import Foundation
import Combine
import Speech
import AVFoundation

@MainActor
public class PrecedentFinderViewModel: ObservableObject {
    @Published public var searchQuery: String = ""
    @Published public var selectedJurisdiction: String = "WA" // WA, OR, CA, NY, ALL
    @Published public var matchingCases: [PrecedentCase] = []
    @Published public var isRecording: Bool = false
    @Published public var speechAuthStatus: String = "Ready"
    
    private var speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    public init() {}
    
    public func searchPrecedents() {
        let q = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !q.isEmpty else {
            matchingCases = []
            return
        }
        
        let all = PrecedentDatabase.allCases
        var results: [(caseItem: PrecedentCase, score: Int)] = []
        
        for c in all {
            if selectedJurisdiction != "ALL" && c.jurisdiction != selectedJurisdiction {
                continue
            }
            
            var score = 0
            for kw in c.scenarioKeywords {
                if q.contains(kw.lowercased()) {
                    score += 25
                }
            }
            
            if q.contains(c.clinicalTopic.lowercased()) { score += 30 }
            if q.contains(c.caseCitation.lowercased()) { score += 40 }
            
            if score > 0 {
                results.append((caseItem: c, score: score))
            }
        }
        
        results.sort { $0.score > $1.score }
        self.matchingCases = results.map { $0.caseItem }
    }
    
    public func applyPreset(_ query: String, jurisdiction: String = "WA") {
        self.searchQuery = query
        self.selectedJurisdiction = jurisdiction
        searchPrecedents()
    }
    
    public func toggleSpeechRecognition() {
        if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }
    
    private func startRecording() {
        SFSpeechRecognizer.requestAuthorization { [weak self] status in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch status {
                case .authorized:
                    self.beginAudioEngineRecording()
                case .denied, .restricted, .notDetermined:
                    self.speechAuthStatus = "Microphone / Speech access denied."
                @unknown default:
                    break
                }
            }
        }
    }
    
    private func beginAudioEngineRecording() {
        recognitionTask?.cancel()
        recognitionTask = nil
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            speechAuthStatus = "Audio session failed."
            return
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { return }
        recognitionRequest.shouldReportPartialResults = true
        
        let inputNode = audioEngine.inputNode
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let self = self else { return }
            if let result = result {
                self.searchQuery = result.bestTranscription.formattedString
                self.searchPrecedents()
            }
            if error != nil || (result?.isFinal ?? false) {
                self.stopRecording()
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
            self.isRecording = true
            self.speechAuthStatus = "Listening..."
        } catch {
            self.speechAuthStatus = "Could not start audio engine."
        }
    }
    
    private func stopRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        recognitionRequest = nil
        recognitionTask = nil
        isRecording = false
        speechAuthStatus = "Ready"
    }
}
