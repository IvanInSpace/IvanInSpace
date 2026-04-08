import SwiftUI

// MARK: - Kitchen Menu View
// Category icon grid over background, tapping opens category list

struct KitchenMenuView: View {
    @State private var selectedCategory: MenuCategory? = nil
    private let categories = MenuData.kitchenSection.categories

    // Ordered layout: rows of icons
    // Row 1: Английские пироги — Холодные закуски (center)
    // Row 2: Салаты — Супы — Сэндвичи
    // Row 3: Горячие закуски — Бургеры — Горячие блюда
    // Row 4: Десерты (center)

    private var categoryRows: [[(MenuCategory, String)]] {
        let cats = categoriesDict
        return [
            [cats["Английские пироги"]!, cats["Холодные закуски"]!],
            [cats["Салаты"]!, cats["Супы"]!, cats["Сэндвичи"]!],
            [cats["Горячие закуски"]!, cats["Бургеры"]!, cats["Горячие блюда"]!],
            [cats["Десерты"]!]
        ]
    }

    private var categoriesDict: [String: (MenuCategory, String)] {
        var d: [String: (MenuCategory, String)] = [:]
        for cat in categories {
            d[cat.name] = (cat, iconFor(cat.name))
        }
        return d
    }

    private func iconFor(_ name: String) -> String {
        switch name {
        case "Английские пироги": return "chart.pie"
        case "Холодные закуски": return "snowflake"
        case "Салаты": return "leaf"
        case "Супы": return "mug"
        case "Сэндвичи": return "takeoutbag.and.cup.and.straw"
        case "Горячие закуски": return "flame"
        case "Бургеры": return "circle.grid.cross"
        case "Горячие блюда": return "frying.pan"
        case "Десерты": return "birthday.cake"
        default: return "fork.knife"
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Image("kitchen")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
                    .overlay(Color.black.opacity(0.65))
                    .ignoresSafeArea()

                // Category grid
                VStack(spacing: 28) {
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
                    .padding(.bottom, SP.spacing8)

                    // Icon rows
                    ForEach(0..<categoryRows.count, id: \.self) { rowIndex in
                        HStack(spacing: 36) {
                            ForEach(0..<categoryRows[rowIndex].count, id: \.self) { colIndex in
                                let (cat, icon) = categoryRows[rowIndex][colIndex]
                                Button {
                                    selectedCategory = cat
                                } label: {
                                    VStack(spacing: 6) {
                                        Image(systemName: icon)
                                            .font(.system(size: 20, weight: .light))
                                        Text(cat.name)
                                            .font(.system(size: 10, weight: .regular))
                                            .tracking(0.5)
                                            .lineLimit(2)
                                            .multilineTextAlignment(.center)
                                    }
                                    .foregroundColor(.white)
                                    .frame(width: 80)
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(item: $selectedCategory) { category in
                KitchenCategoryDetailView(category: category)
            }
        }
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
            .padding(.bottom, 90)
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
