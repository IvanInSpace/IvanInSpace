import SwiftUI

// MARK: - Bar Menu View
// Horizontal paging slider with two hero cards

struct BarMenuView: View {
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 0) {
                        NavigationLink {
                            DrinksCategoryListView(
                                title: "Cask & Keg",
                                categories: [MenuData.draughtBeer]
                            )
                        } label: {
                            BarHeroCard(imageName: "draft", title: "Cask & Keg", size: geo.size)
                        }

                        NavigationLink {
                            DrinksCategoryListView(
                                title: "Cocktails & Soft",
                                categories: cocktailsAndSoftCategories
                            )
                        } label: {
                            BarHeroCard(imageName: "cocktails", title: "Cocktails & Soft", size: geo.size)
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.paging)
            }
            .background(Color.spDark)
            .ignoresSafeArea()
            .navigationBarHidden(true)
        }
    }

    private var cocktailsAndSoftCategories: [MenuCategory] {
        let excluded = MenuData.draughtBeer.id
        return MenuData.barSection.categories.filter { $0.id != excluded }
    }
}

// MARK: - Bar Hero Card

struct BarHeroCard: View {
    let imageName: String
    let title: String
    let size: CGSize

    var body: some View {
        ZStack {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width, height: size.height)
                .clipped()

            Color.black.opacity(0.45)

            VStack {
                Spacer()
                Text(title)
                    .font(.spHero)
                    .tracking(2)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 8, y: 4)

                // Swipe arrows
                HStack(spacing: SP.spacing24) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .light))
                        .foregroundColor(.white.opacity(0.5))
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .light))
                        .foregroundColor(.white.opacity(0.5))
                }
                .padding(.top, SP.spacing12)

                Spacer().frame(height: 160)
            }
        }
        .frame(width: size.width, height: size.height)
    }
}

// MARK: - Drinks Category List View

struct DrinksCategoryListView: View {
    let title: String
    let categories: [MenuCategory]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: SP.spacing24) {
                ForEach(categories) { category in
                    CategoryBlock(category: category)
                }
            }
            .padding(.vertical, SP.spacing16)
            .padding(.bottom, 90)
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

            VStack(spacing: 0) {
                ForEach(category.items) { item in
                    MenuItemRow(item: item)

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
}
