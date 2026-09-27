import SwiftUI

public struct PrecedentFinderView: View {
    @StateObject private var viewModel = PrecedentFinderViewModel()
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Header Card
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("MALPRACTICE DEFENSIVE RADAR")
                                .font(.system(size: 10, weight: .bold))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(Color.purple.opacity(0.15))
                                .foregroundColor(.purple)
                                .cornerRadius(6)
                            
                            Spacer()
                            
                            Text("WA • OR • CA • NY")
                                .font(.system(size: 10, weight: .bold, design: .monospaced))
                                .foregroundColor(.secondary)
                        }
                        
                        Text("Precedent Case Finder")
                            .font(.title2.bold())
                        
                        Text("Match clinical complications against landmark standard of care and known risk caselaw.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(16)
                    
                    // Clinical Scenario Presets
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Clinical Scenario Quick Presets:")
                            .font(.caption.bold())
                            .foregroundColor(.secondary)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                Button("💧 Dural Tear (Keen)") {
                                    viewModel.applyPreset("incidental dural tear lumbar laminectomy csf leak revision repair", jurisdiction: "WA")
                                }
                                .font(.caption.bold())
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.blue.opacity(0.12))
                                .foregroundColor(.blue)
                                .cornerRadius(8)
                                
                                Button("⚡ Cauda Equina (Davis)") {
                                    viewModel.applyPreset("emergency cauda equina urinary retention saddle anesthesia decompression delay", jurisdiction: "WA")
                                }
                                .font(.caption.bold())
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.red.opacity(0.12))
                                .foregroundColor(.red)
                                .cornerRadius(8)
                                
                                Button("🔩 Pedicle Screw (Cobbs)") {
                                    viewModel.applyPreset("pedicle screw medial wall breach radiculopathy triggered emg", jurisdiction: "CA")
                                }
                                .font(.caption.bold())
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.orange.opacity(0.12))
                                .foregroundColor(.orange)
                                .cornerRadius(8)
                            }
                        }
                    }
                    
                    // Voice & Text Input
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            TextField("Describe clinical case or complication...", text: $viewModel.searchQuery)
                                .textFieldStyle(.plain)
                                .font(.subheadline)
                                .padding(10)
                                .background(Color(uiColor: .systemBackground))
                                .cornerRadius(10)
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                                .onSubmit {
                                    viewModel.searchPrecedents()
                                }
                            
                            Button(action: {
                                viewModel.toggleSpeechRecognition()
                            }) {
                                Image(systemName: viewModel.isRecording ? "stop.circle.fill" : "mic.fill")
                                    .font(.title3)
                                    .foregroundColor(viewModel.isRecording ? .red : Color(red: 0.05, green: 0.55, blue: 0.40))
                                    .padding(10)
                                    .background(Color(uiColor: .systemBackground))
                                    .cornerRadius(10)
                                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                            }
                        }
                        
                        Button(action: {
                            viewModel.searchPrecedents()
                        }) {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                Text("Search Precedents & Defensive Guidance")
                            }
                            .font(.subheadline.bold())
                            .frame(maxWidth: .infinity)
                            .padding(12)
                            .background(Color(red: 0.35, green: 0.15, blue: 0.55)) // Deep Purple
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                    }
                    
                    // Matching Case Results
                    if !viewModel.matchingCases.isEmpty {
                        VStack(alignment: .leading, spacing: 14) {
                            Text("Matching Precedent Cases (\(viewModel.matchingCases.count))")
                                .font(.headline)
                            
                            ForEach(viewModel.matchingCases) { c in
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack {
                                        Text(c.caseCitation)
                                            .font(.subheadline.bold())
                                            .foregroundColor(.primary)
                                        Spacer()
                                        Text("\(c.stateName) • \(c.courtAndYear)")
                                            .font(.system(size: 10, weight: .bold, design: .monospaced))
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 2)
                                            .background(Color.purple.opacity(0.15))
                                            .foregroundColor(.purple)
                                            .cornerRadius(4)
                                    }
                                    
                                    Text(c.clinicalTopic)
                                        .font(.caption.bold())
                                        .foregroundColor(Color(red: 0.05, green: 0.55, blue: 0.40))
                                    
                                    Text(c.factualSummary)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("LEGAL HOLDING:")
                                            .font(.system(size: 10, weight: .bold))
                                            .foregroundColor(.primary)
                                        Text(c.coreLegalHolding)
                                            .font(.caption)
                                            .padding(8)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .background(Color.gray.opacity(0.08))
                                            .cornerRadius(8)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("STANDARD OF CARE DEFENSE STRATEGY:")
                                            .font(.system(size: 10, weight: .bold))
                                            .foregroundColor(.blue)
                                        Text(c.defenseStrategy)
                                            .font(.caption)
                                            .padding(8)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .background(Color.blue.opacity(0.08))
                                            .cornerRadius(8)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("DEFENSIVE CHARTING DIRECTIVE:")
                                            .font(.system(size: 10, weight: .bold))
                                            .foregroundColor(Color(red: 0.05, green: 0.55, blue: 0.40))
                                        Text(c.defensiveChartingDirective)
                                            .font(.caption)
                                            .padding(8)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .background(Color.green.opacity(0.08))
                                            .cornerRadius(8)
                                    }
                                }
                                .padding()
                                .background(Color(uiColor: .systemBackground))
                                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.gray.opacity(0.2), lineWidth: 1))
                                .cornerRadius(14)
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("MDEsq Precedents")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
