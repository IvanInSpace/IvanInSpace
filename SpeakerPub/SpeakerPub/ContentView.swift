import SwiftUI

// MARK: - Main Container

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        ZStack(alignment: .bottom) {
            // Content — full screen
            Group {
                switch selectedTab {
                case 0: HomeView(selectedTab: $selectedTab)
                case 1: BarMenuView()
                case 2: KitchenMenuView()
                case 3: AboutView()
                default: HomeView(selectedTab: $selectedTab)
                }
            }

            // Tab bar only on non-home screens
            if selectedTab != 0 {
                tabBar
            }
        }
        .ignoresSafeArea(.keyboard)
        .preferredColorScheme(.dark)
    }

    // MARK: - Tab Bar (for Bar, Kitchen, About)

    private var tabBar: some View {
        HStack(spacing: 0) {
            tabItem(icon: "house", label: "Главная", index: 0)
            tabItem(icon: "wineglass", label: "Бар", index: 1)
            tabItem(icon: "fork.knife", label: "Кухня", index: 2)
            tabItem(icon: "info.circle", label: "О нас", index: 3)
        }
        .padding(.top, 10)
        .padding(.bottom, 2)
        .background(
            Color.spDark
                .ignoresSafeArea(.all, edges: .bottom)
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
}
