import SwiftUI

// MARK: - Bar Menu View
// Horizontal slider with two hero cards: Cask & Keg, Cocktails & Soft

struct BarMenuView: View {
    var body: some View {
        NavigationStack {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 0) {
                    // Card 1: Cask & Keg → Draught beer
                    NavigationLink {
                        DrinksCategoryListView(
                            title: "Cask & Keg",
                            categories: [MenuData.draughtBeer]
                        )
                    } label: {
                        BarHeroCard(imageName: "draft", title: "Cask & Keg")
                    }

                    // Card 2: Cocktails & Soft → everything else
                    NavigationLink {
                        DrinksCategoryListView(
                            title: "Cocktails & Soft",
                            categories: cocktailsAndSoftCategories
                        )
                    } label: {
                        BarHeroCard(imageName: "cocktails", title: "Cocktails & Soft")
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.paging)
            .background(Color.spDark)
            .navigationBarHidden(true)
        }
    }

    private var cocktailsAndSoftCategories: [MenuCategory] {
        // All bar categories except draught beer
        let excluded = MenuData.draughtBeer.id
        return MenuData.barSection.categories.filter { $0.id != excluded }
    }
}

// MARK: - Bar Hero Card

struct BarHeroCard: View {
    let imageName: String
    let title: String

    var body: some View {
        ZStack {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .clipped()

            // Dark overlay
            Color.black.opacity(0.45)

            // Title
            VStack {
                Spacer()
                Text(title)
                    .font(.spHero)
                    .tracking(2)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 8, y: 4)

                // Subtle hint
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .light))
                    .foregroundColor(.white.opacity(0.6))
                    .padding(.top, SP.spacing4)

                Spacer().frame(height: 120)
            }
        }
        .frame(width: UIScreen.main.bounds.width)
        .ignoresSafeArea()
    }
}

// MARK: - Drinks Category List View

struct DrinksCategoryListView: View {
    let title: String
    let categories: [MenuCategory]
    @Environment(FavoritesManager.self) private var favorites

    var body: some View {
        ScrollView {
            LazyVStack(spacing: SP.spacing24) {
                ForEach(categories) { category in
                    CategoryBlock(category: category)
                }
            }
            .padding(.vertical, SP.spacing16)
        }
        .background(Color.spDark)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

// MARK: - Shared Category Block

struct CategoryBlock: View {
    let category: MenuCategory

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            VStack(alignment: .leading, spacing: SP.spacing2) {
                Text(category.name.uppercased())
                    .font(.spSmall)
                    .tracking(2)
                    .foregroundColor(.spGold)

                if let volume = category.volumeInfo {
                    Text(volume)
                        .font(.spCaption)
                        .foregroundColor(.spMuted)
                }
            }
            .padding(.horizontal, SP.horizontalPadding)
            .padding(.bottom, SP.spacing12)

            // Items
            VStack(spacing: 0) {
                ForEach(category.items) { item in
                    NavigationLink {
                        MenuItemDetailView(item: item)
                    } label: {
                        MenuItemRow(item: item)
                    }
                    .buttonStyle(.plain)

                    if item.id != category.items.last?.id {
                        Divider()
                            .background(Color.spDivider)
                            .padding(.leading, SP.horizontalPadding)
                    }
                }
            }
            .background(Color.spCard)
            .clipShape(RoundedRectangle(cornerRadius: SP.radiusSmall))
            .padding(.horizontal, SP.horizontalPadding)
        }
    }
}

#Preview {
    BarMenuView()
        .environment(FavoritesManager.shared)
}
