import SwiftUI

// MARK: - Kitchen Menu View
// 3-column grid of category tiles with photo backgrounds

struct KitchenMenuView: View {
    @State private var selectedCategory: MenuCategory? = nil

    private let categories: [(MenuCategory, String)] = [
        (MenuData.coldStarters, "cold_starters_1"),
        (MenuData.hotStarters, "hot_starters_1"),
        (MenuData.salads, "salads_1"),
        (MenuData.soups, "soups_1"),
        (MenuData.burgerAndMore, "burgers_1"),
        (MenuData.sandwiches, "sandwiches_1"),
        (MenuData.hotDishes, "hot_dishes_1"),
        (MenuData.englishPies, "english_pies_1"),
        (MenuData.desserts, "desserts_1")
    ]

    private let columns = [
        GridItem(.flexible(), spacing: 6),
        GridItem(.flexible(), spacing: 6),
        GridItem(.flexible(), spacing: 6)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 6) {
                    ForEach(0..<categories.count, id: \.self) { index in
                        let (category, image) = categories[index]
                        Button {
                            selectedCategory = category
                        } label: {
                            CategoryTile(name: category.name, imageName: image)
                        }
                    }
                }
                .padding(.horizontal, SP.horizontalPadding)
                .padding(.top, SP.spacing16)
                .padding(.bottom, 90)
            }
            .background(Color.spDark)
            .navigationTitle("Кухня")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .navigationDestination(item: $selectedCategory) { category in
                KitchenCategoryDetailView(category: category)
            }
        }
    }
}

// MARK: - Category Tile

struct CategoryTile: View {
    let name: String
    let imageName: String

    var body: some View {
        ZStack {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(minHeight: 110)

            Color.black.opacity(0.4)

            Text(name)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 4)
                .shadow(color: .black.opacity(0.6), radius: 4, y: 2)
        }
        .aspectRatio(1, contentMode: .fill)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Kitchen Category Detail

struct KitchenCategoryDetailView: View {
    let category: MenuCategory

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
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
            .padding(.top, SP.spacing16)

            PriceDisclaimer()

            Spacer().frame(height: 90)
        }
        .background(Color.spDark)
        .navigationTitle(category.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

#Preview {
    KitchenMenuView()
}
