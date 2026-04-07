import SwiftUI

// MARK: - Main Tab View — Minimal Dark Tab Bar

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        ZStack(alignment: .bottom) {
            // Content
            Group {
                switch selectedTab {
                case 0: HomeView()
                case 1: BarMenuView()
                case 2: KitchenMenuView()
                case 3: AboutView()
                default: HomeView()
                }
            }
            .ignoresSafeArea(.all, edges: .bottom)

            // Custom minimal tab bar
            tabBar
        }
        .preferredColorScheme(.dark)
    }

    // MARK: - Tab Bar

    private var tabBar: some View {
        HStack(spacing: 0) {
            tabItem(icon: "house", label: "Главная", index: 0)
            tabItem(icon: "wineglass", label: "Бар", index: 1)
            tabItem(icon: "fork.knife", label: "Кухня", index: 2)
            tabItem(icon: "info.circle", label: "О нас", index: 3)
        }
        .padding(.top, 8)
        .padding(.bottom, 28)
        .background(
            Color.spDark
                .overlay(
                    Rectangle()
                        .fill(Color.spDivider)
                        .frame(height: 0.5),
                    alignment: .top
                )
        )
    }

    private func tabItem(icon: String, label: String, index: Int) -> some View {
        Button {
            selectedTab = index
        } label: {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .light))

                Text(label)
                    .font(.system(size: 9, weight: .regular))
                    .tracking(0.5)
            }
            .foregroundColor(selectedTab == index ? .spCream : .spMuted.opacity(0.5))
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    ContentView()
        .environment(FavoritesManager.shared)
}
