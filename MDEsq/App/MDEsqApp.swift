import SwiftUI

@main
struct MDEsqApp: App {
    @AppStorage("mdesq_appearance_mode") private var appearanceModeRaw: String = MDEsqAppearanceMode.sunlit.rawValue

    private var activeScheme: ColorScheme? {
        (MDEsqAppearanceMode(rawValue: appearanceModeRaw) ?? .sunlit).colorScheme
    }

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .preferredColorScheme(activeScheme)
        }
    }
}
