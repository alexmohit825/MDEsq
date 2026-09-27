import SwiftUI

public struct ContractAnalyzerView: View {
    @StateObject private var viewModel = ContractAnalyzerViewModel()
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header Banner
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("DOCUMENT REDLINE CENTER")
                                .font(.system(size: 10, weight: .bold))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(Color.yellow.opacity(0.2))
                                .foregroundColor(.orange)
                                .cornerRadius(6)
                            
                            Spacer()
                            
                            Text("RCW 49.62 / STARK")
                                .font(.system(size: 10, weight: .bold, design: .monospaced))
                                .foregroundColor(.secondary)
                        }
                        
                        Text("Physician Contract Audit")
                            .font(.title2.bold())
                            .foregroundColor(.primary)
                        
                        Text("Audit non-competes, tail liabilities, and call obligations with instant recommended redlines.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(16)
                    
                    // Input Text Area
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Contract Agreement Text")
                                .font(.subheadline.bold())
                            Spacer()
                            Button("Load Sample Agreement") {
                                viewModel.loadSampleContract()
                            }
                            .font(.caption.bold())
                            .foregroundColor(Color(red: 0.05, green: 0.55, blue: 0.40))
                        }
                        
                        TextEditor(text: $viewModel.rawContractText)
                            .frame(height: 140)
                            .padding(8)
                            .background(Color(uiColor: .systemBackground))
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                            .cornerRadius(12)
                            .font(.system(size: 12, design: .monospaced))
                        
                        Button(action: {
                            viewModel.analyzeText(viewModel.rawContractText)
                        }) {
                            HStack {
                                Image(systemName: "bolt.shield.fill")
                                Text("Audit Contract & Generate Redlines")
                            }
                            .font(.subheadline.bold())
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 0.05, green: 0.55, blue: 0.40))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                    }
                    
                    // Results Section
                    if !viewModel.flaggedClauses.isEmpty {
                        VStack(alignment: .leading, spacing: 14) {
                            HStack {
                                Text("Audit Grade:")
                                    .font(.headline)
                                Text(viewModel.overallGrade)
                                    .font(.title2.bold())
                                    .foregroundColor(viewModel.overallGrade == "F" ? .red : .orange)
                                Spacer()
                                Text("\(viewModel.flaggedClauses.count) Traps Flagged")
                                    .font(.caption.bold())
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(Color.red.opacity(0.15))
                                    .foregroundColor(.red)
                                    .cornerRadius(8)
                            }
                            
                            Text(viewModel.gradeNarrative)
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            ForEach(viewModel.flaggedClauses) { item in
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack {
                                        Text(item.rule.name)
                                            .font(.subheadline.bold())
                                            .foregroundColor(.red)
                                        Spacer()
                                        Text(item.rule.riskSeverity)
                                            .font(.system(size: 10, weight: .bold))
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 2)
                                            .background(Color.red.opacity(0.2))
                                            .foregroundColor(.red)
                                            .cornerRadius(4)
                                    }
                                    
                                    Text("Statutory Basis: \(item.rule.statutoryBasis)")
                                        .font(.system(size: 11, weight: .semibold))
                                        .foregroundColor(.secondary)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("RECOMMENDED REDLINE REWRITE:")
                                            .font(.system(size: 10, weight: .bold))
                                            .foregroundColor(Color(red: 0.05, green: 0.55, blue: 0.40))
                                        Text(item.rule.recommendedRedline)
                                            .font(.caption)
                                            .padding(8)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .background(Color.green.opacity(0.08))
                                            .cornerRadius(8)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("PHYSICIAN NEGOTIATION TALKING POINTS:")
                                            .font(.system(size: 10, weight: .bold))
                                            .foregroundColor(.blue)
                                        Text(item.rule.negotiationScript)
                                            .font(.caption)
                                            .padding(8)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .background(Color.blue.opacity(0.08))
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
            .navigationTitle("MDEsq Contracts")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
