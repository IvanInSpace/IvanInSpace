import SwiftUI

@main
struct SpeakerPubApp: App {
    @State private var favoritesManager = FavoritesManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(favoritesManager)
        }
    }
}
