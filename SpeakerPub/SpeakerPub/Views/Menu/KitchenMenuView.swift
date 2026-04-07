import SwiftUI

// MARK: - Kitchen Menu View
// Full-screen background image with scrollable menu overlay

struct KitchenMenuView: View {
    @Environment(FavoritesManager.self) private var favorites
    private let categories = MenuData.kitchenSection.categories

    var body: some View {
        NavigationStack {
            ZStack {
                // Background image
                Image("kitchen")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()

                // Dark overlay
                Color.black.opacity(0.7)
                    .ignoresSafeArea()

                // Menu content
                ScrollView {
                    LazyVStack(spacing: SP.spacing24) {
                        // Header
                        VStack(spacing: SP.spacing4) {
                            Text("КУХНЯ")
                                .font(.spBrandSmall)
                                .tracking(4)
                                .foregroundColor(.spGold)
                            Text("Kitchen")
                                .font(.spHero)
                                .foregroundColor(.spCream)
                        }
                        .padding(.top, SP.spacing48)
                        .padding(.bottom, SP.spacing8)

                        ForEach(categories) { category in
                            CategoryBlock(category: category)
                        }
                    }
                    .padding(.bottom, SP.spacing40)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    KitchenMenuView()
        .environment(FavoritesManager.shared)
}
