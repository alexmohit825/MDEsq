import SwiftUI

public struct PeerReviewView: View {
    @State private var selectedFactors: Set<String> = []
    
    public init() {}
    
    private var computedScore: Int {
        var total = 0
        for f in PeerReviewDatabase.shamFactors {
            if selectedFactors.contains(f.id) {
                total += f.weight
            }
        }
        return total
    }
    
    private var tierLabel: String {
        if computedScore >= 45 {
            return "High Probability of Sham Retaliation"
        } else if computedScore >= 20 {
            return "Moderate Concern (Procedural Irregularities)"
        } else {
            return "Low Sham Probability"
        }
    }
    
    private var tierColor: Color {
        if computedScore >= 45 {
            return .red
        } else if computedScore >= 20 {
            return .orange
        } else {
            return Color(red: 0.05, green: 0.55, blue: 0.40)
        }
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header Banner
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("PEER REVIEW DEFENSE")
                                .font(.system(size: 10, weight: .bold))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(Color.blue.opacity(0.15))
                                .foregroundColor(.blue)
                                .cornerRadius(6)
                            
                            Spacer()
                            
                            Text("HCQIA (42 U.S.C. § 11101)")
                                .font(.system(size: 10, weight: .bold, design: .monospaced))
                                .foregroundColor(.secondary)
                        }
                        
                        Text("Sham Peer Review Shield")
                            .font(.title2.bold())
                        
                        Text("Assess bad-faith economic retaliation, protect clinical privileges, and navigate the 30-day NPDB reporting cliff.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(16)
                    
                    // Score Gauge Card
                    VStack(spacing: 8) {
                        HStack {
                            Text("Bad-Faith Retaliation Score")
                                .font(.subheadline.bold())
                            Spacer()
                            Text("\(computedScore) / 60")
                                .font(.title3.bold().monospaced())
                                .foregroundColor(tierColor)
                        }
                        
                        Text(tierLabel)
                            .font(.caption.bold())
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(tierColor)
                    }
                    .padding()
                    .background(Color(uiColor: .systemBackground))
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.2), lineWidth: 1))
                    .cornerRadius(12)
                    
                    // Factor Checklist
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Diagnostic Retaliation Factors (Select all that apply):")
                            .font(.subheadline.bold())
                        
                        ForEach(PeerReviewDatabase.shamFactors) { f in
                            let isSelected = selectedFactors.contains(f.id)
                            Button(action: {
                                if isSelected {
                                    selectedFactors.remove(f.id)
                                } else {
                                    selectedFactors.insert(f.id)
                                }
                            }) {
                                HStack(alignment: .top, spacing: 12) {
                                    Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                                        .foregroundColor(isSelected ? .blue : .gray)
                                        .font(.headline)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        HStack {
                                            Text(f.name)
                                                .font(.caption.bold())
                                                .foregroundColor(.primary)
                                            Spacer()
                                            Text("+\(f.weight) pts")
                                                .font(.system(size: 10, weight: .bold))
                                                .foregroundColor(.secondary)
                                        }
                                        
                                        Text(f.description)
                                            .font(.caption2)
                                            .foregroundColor(.secondary)
                                            .multilineTextAlignment(.leading)
                                    }
                                }
                                .padding(12)
                                .background(isSelected ? Color.blue.opacity(0.06) : Color(uiColor: .systemBackground))
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(isSelected ? Color.blue.opacity(0.4) : Color.gray.opacity(0.2), lineWidth: 1))
                                .cornerRadius(10)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("MDEsq Peer Review")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
