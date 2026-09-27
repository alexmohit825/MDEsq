import SwiftUI

public struct MainTabView: View {
    public init() {}
    
    public var body: some View {
        TabView {
            ContractAnalyzerView()
                .tabItem {
                    Label("Contracts", systemImage: "doc.text.magnifyingglass")
                }
            
            PrecedentFinderView()
                .tabItem {
                    Label("Precedents", systemImage: "scale.3d")
                }
            
            PeerReviewView()
                .tabItem {
                    Label("Peer Review", systemImage: "shield.lefthalf.filled")
                }
            
            DepositionMasterclassView()
                .tabItem {
                    Label("Depositions", systemImage: "mic.fill")
                }
            
            FMVCalculatorView()
                .tabItem {
                    Label("FMV & Stark", systemImage: "chart.bar.xaxis")
                }
        }
        .tint(Color(red: 0.05, green: 0.55, blue: 0.40)) // Executive Emerald
    }
}
