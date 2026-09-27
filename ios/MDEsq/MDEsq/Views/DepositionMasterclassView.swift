import SwiftUI

public struct DepositionMasterclassView: View {
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header Banner
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("TRIAL TESTIMONY MASTERCLASS")
                                .font(.system(size: 10, weight: .bold))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(Color.green.opacity(0.15))
                                .foregroundColor(Color(red: 0.05, green: 0.55, blue: 0.40))
                                .cornerRadius(6)
                            
                            Spacer()
                            
                            Text("REPTILE THEORY SHIELD")
                                .font(.system(size: 10, weight: .bold, design: .monospaced))
                                .foregroundColor(.secondary)
                        }
                        
                        Text("Deposition Defense Rules")
                            .font(.title2.bold())
                        
                        Text("Master the cardinal rules of deposition testimony and neutralize plaintiff Reptile Theory tactics under cross-examination.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(16)
                    
                    // Rules Deck
                    ForEach(DepositionDatabase.rules) { r in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(r.title)
                                .font(.subheadline.bold())
                                .foregroundColor(.primary)
                            
                            Text(r.principle)
                                .font(.caption.bold())
                                .foregroundColor(Color(red: 0.05, green: 0.55, blue: 0.40))
                            
                            Text(r.explanation)
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("FATAL CONCESSION TO AVOID:")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(.red)
                                Text(r.fatalMistake)
                                    .font(.caption)
                                    .padding(8)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.red.opacity(0.08))
                                    .cornerRadius(8)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("MASTER DEFENSE RESPONSE SCRIPT:")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(Color(red: 0.05, green: 0.55, blue: 0.40))
                                Text(r.masterScript)
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
                .padding()
            }
            .navigationTitle("MDEsq Depositions")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
