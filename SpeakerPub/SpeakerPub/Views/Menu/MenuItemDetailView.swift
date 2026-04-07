import SwiftUI

// MARK: - Menu Item Detail View

struct MenuItemDetailView: View {
    let item: MenuItem
    @Environment(FavoritesManager.self) private var favorites

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Hero area
                heroSection

                // Content
                VStack(alignment: .leading, spacing: SP.spacing24) {
                    // Price section
                    priceSection

                    // Tags
                    if !item.tags.isEmpty {
                        tagsSection
                    }

                    // Description
                    if let desc = item.description {
                        descriptionSection(desc)
                    }
                }
                .padding(SP.horizontalPadding)
                .padding(.top, SP.spacing24)
            }
        }
        .background(Color.spBackground)
        .navigationTitle(item.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        favorites.toggle(item)
                    }
                } label: {
                    Image(systemName: favorites.isFavorite(item) ? "heart.fill" : "heart")
                        .foregroundColor(favorites.isFavorite(item) ? .red : .spSecondaryText)
                        .symbolEffect(.bounce, value: favorites.isFavorite(item))
                }
            }
        }
    }

    // MARK: - Hero

    private var heroSection: some View {
        ZStack {
            LinearGradient(
                colors: [Color.spAccent.opacity(0.08), Color.spBackground],
                startPoint: .top,
                endPoint: .bottom
            )

            VStack(spacing: SP.spacing16) {
                Image(systemName: categoryIcon)
                    .font(.system(size: 56))
                    .foregroundColor(.spAccent.opacity(0.4))

                Text(item.name)
                    .font(.spTitle)
                    .foregroundColor(.spPrimaryText)
                    .multilineTextAlignment(.center)
            }
            .padding(.vertical, SP.spacing40)
        }
    }

    // MARK: - Price

    private var priceSection: some View {
        VStack(alignment: .leading, spacing: SP.spacing12) {
            if item.prices.isEmpty {
                Text("Цена по запросу")
                    .font(.spBody)
                    .foregroundColor(.spSecondaryText)
                    .italic()
            } else if item.prices.count == 1 {
                HStack(alignment: .firstTextBaseline) {
                    Text("\(item.prices[0].amount)")
                        .font(.system(size: 36, weight: .bold, design: .serif))
                        .foregroundColor(.spPrice)
                    Text("₽")
                        .font(.system(size: 22, weight: .medium, design: .serif))
                        .foregroundColor(.spPrice)

                    if let label = item.prices[0].label {
                        Text("/ \(label)")
                            .font(.spCaption)
                            .foregroundColor(.spSecondaryText)
                    }
                }
            } else {
                VStack(spacing: SP.spacing8) {
                    ForEach(item.prices) { price in
                        HStack {
                            if let label = price.label {
                                Text(label)
                                    .font(.spBody)
                                    .foregroundColor(.spSecondaryText)
                            }
                            Spacer()
                            Text("\(price.amount) ₽")
                                .font(.spPrice)
                                .foregroundColor(.spPrice)
                        }
                        .padding(.vertical, SP.spacing8)
                        .padding(.horizontal, SP.spacing16)
                        .background(Color.spCardBackground)
                        .clipShape(RoundedRectangle(cornerRadius: SP.radiusSmall))
                    }
                }
            }
        }
    }

    // MARK: - Tags

    private var tagsSection: some View {
        HStack(spacing: SP.spacing8) {
            ForEach(item.tags, id: \.self) { tag in
                Text(tag.rawValue)
                    .font(.spSmall)
                    .foregroundColor(.spAccentDark)
                    .padding(.horizontal, SP.spacing12)
                    .padding(.vertical, SP.spacing6)
                    .background(Color.spAccent.opacity(0.1))
                    .clipShape(Capsule())
            }
        }
    }

    // MARK: - Description

    private func descriptionSection(_ text: String) -> some View {
        VStack(alignment: .leading, spacing: SP.spacing8) {
            Text("Описание")
                .font(.spSubsection)
                .foregroundColor(.spPrimaryText)
            Text(text)
                .font(.spBody)
                .foregroundColor(.spSecondaryText)
        }
    }

    // MARK: - Icon

    private var categoryIcon: String {
        if item.tags.contains(.nonAlcoholic) { return "cup.and.saucer" }
        if item.tags.contains(.vegetarian) { return "leaf" }
        if item.tags.contains(.spicy) { return "flame" }
        if item.tags.contains(.caskAle) { return "mug" }
        return "fork.knife"
    }
}

#Preview {
    NavigationStack {
        MenuItemDetailView(
            item: MenuItem(
                name: "Guinness",
                description: "Ирландский стаут",
                prices: [
                    PriceOption(amount: 950, label: "568 мл"),
                    PriceOption(amount: 500, label: "280 мл")
                ],
                tags: [.popular]
            )
        )
    }
    .environment(FavoritesManager.shared)
}
