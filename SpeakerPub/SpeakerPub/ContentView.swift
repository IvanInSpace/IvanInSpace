import SwiftUI

// MARK: - Main Tab View

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Главная", systemImage: "house.fill")
                }
                .tag(0)

            MenuSectionView(section: MenuData.barSection)
                .tabItem {
                    Label("Бар", systemImage: "wineglass")
                }
                .tag(1)

            MenuSectionView(section: MenuData.kitchenSection)
                .tabItem {
                    Label("Кухня", systemImage: "fork.knife")
                }
                .tag(2)

            AboutView()
                .tabItem {
                    Label("О нас", systemImage: "info.circle")
                }
                .tag(3)
        }
        .tint(.spAccent)
    }
}

#Preview {
    ContentView()
        .environment(FavoritesManager.shared)
}
