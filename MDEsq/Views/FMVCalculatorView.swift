import SwiftUI

public struct FMVCalculatorView: View {
    @StateObject private var viewModel = FMVCalculatorViewModel()
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header Banner
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("STARK LAW FMV BENCHMARKS")
                                .font(.system(size: 10, weight: .bold))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(Color.yellow.opacity(0.2))
                                .foregroundColor(.orange)
                                .cornerRadius(6)
                            
                            Spacer()
                            
                            Text("42 U.S.C. § 1395nn")
                                .font(.system(size: 10, weight: .bold, design: .monospaced))
                                .foregroundColor(.secondary)
                        }
                        
                        Text("Compensation & FMV Calculator")
                            .font(.title2.bold())
                        
                        Text("Calculate clinical Fair Market Value percentiles and verify safe harbor compliance.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(16)
                    
                    // Specialty Picker
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Select Specialty:")
                            .font(.subheadline.bold())
                        
                        Picker("Specialty", selection: $viewModel.selectedSpecialty) {
                            ForEach(SpecialtyDatabase.allBenchmarks) { s in
                                Text(s.name).tag(s)
                            }
                        }
                        .pickerStyle(.menu)
                        .padding(8)
                        .background(Color(uiColor: .systemBackground))
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                    }
                    
                    // Sliders
                    VStack(alignment: .leading, spacing: 14) {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("Base Salary:")
                                    .font(.caption.bold())
                                Spacer()
                                Text("$\(Int(viewModel.baseSalary).formatted())")
                                    .font(.caption.bold().monospaced())
                            }
                            Slider(value: $viewModel.baseSalary, in: 200000...2000000, step: 25000)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("Target wRVUs:")
                                    .font(.caption.bold())
                                Spacer()
                                Text("\(Int(viewModel.targetWrvus).formatted()) wRVUs")
                                    .font(.caption.bold().monospaced())
                            }
                            Slider(value: $viewModel.targetWrvus, in: 2000...20000, step: 200)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("$/wRVU Conversion Factor:")
                                    .font(.caption.bold())
                                Spacer()
                                Text("$\(String(format: "%.2f", viewModel.conversionFactor)) / wRVU")
                                    .font(.caption.bold().monospaced())
                            }
                            Slider(value: $viewModel.conversionFactor, in: 40...150, step: 1.0)
                        }
                    }
                    .padding()
                    .background(Color(uiColor: .systemBackground))
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.2), lineWidth: 1))
                    .cornerRadius(12)
                    
                    // Compensation Output Card
                    VStack(spacing: 12) {
                        HStack {
                            Text("Total Estimated Compensation:")
                                .font(.subheadline)
                            Spacer()
                            Text("$\(Int(viewModel.totalEstimatedComp).formatted())")
                                .font(.title2.bold().monospaced())
                                .foregroundColor(Color(red: 0.05, green: 0.55, blue: 0.40))
                        }
                        
                        Divider()
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("FMV STATUS:")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.secondary)
                            Text(viewModel.fmvStatusTitle)
                                .font(.caption.bold())
                                .foregroundColor(viewModel.fmvStatusColor == "green" ? Color(red: 0.05, green: 0.55, blue: 0.40) : (viewModel.fmvStatusColor == "orange" ? .orange : .red))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack(spacing: 8) {
                            VStack(alignment: .leading) {
                                Text("25th Percentile")
                                    .font(.system(size: 9))
                                    .foregroundColor(.secondary)
                                Text("$\(Int(viewModel.selectedSpecialty.compP25).formatted())")
                                    .font(.caption2.bold().monospaced())
                            }
                            Spacer()
                            VStack(alignment: .leading) {
                                Text("Median (50th)")
                                    .font(.system(size: 9))
                                    .foregroundColor(.secondary)
                                Text("$\(Int(viewModel.selectedSpecialty.compP50).formatted())")
                                    .font(.caption2.bold().monospaced())
                            }
                            Spacer()
                            VStack(alignment: .leading) {
                                Text("75th Percentile")
                                    .font(.system(size: 9))
                                    .foregroundColor(.secondary)
                                Text("$\(Int(viewModel.selectedSpecialty.compP75).formatted())")
                                    .font(.caption2.bold().monospaced())
                            }
                            Spacer()
                            VStack(alignment: .leading) {
                                Text("90th Percentile")
                                    .font(.system(size: 9))
                                    .foregroundColor(.secondary)
                                Text("$\(Int(viewModel.selectedSpecialty.compP90).formatted())")
                                    .font(.caption2.bold().monospaced())
                            }
                        }
                        .padding(.top, 4)
                    }
                    .padding()
                    .background(Color(uiColor: .systemBackground))
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.gray.opacity(0.2), lineWidth: 1))
                    .cornerRadius(14)
                }
                .padding()
            }
            .navigationTitle("MDEsq FMV & Stark")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
