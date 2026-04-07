import SwiftUI

// MARK: - Kitchen Menu View

struct KitchenMenuView: View {
    @Environment(FavoritesManager.self) private var favorites
    private let categories = MenuData.kitchenSection.categories

    var body: some View {
        NavigationStack {
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
                .padding(.bottom, 80)
            }
            .background(
                Image("kitchen")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .overlay(Color.black.opacity(0.7))
                    .ignoresSafeArea()
            )
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    KitchenMenuView()
        .environment(FavoritesManager.shared)
}
