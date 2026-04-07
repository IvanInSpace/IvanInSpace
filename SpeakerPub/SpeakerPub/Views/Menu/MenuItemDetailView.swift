import SwiftUI

// MARK: - Menu Item Detail View

struct MenuItemDetailView: View {
    let item: MenuItem
    @Environment(FavoritesManager.self) private var favorites

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Name
                VStack(spacing: SP.spacing8) {
                    Text(item.name)
                        .font(.spTitle)
                        .foregroundColor(.spCream)
                        .multilineTextAlignment(.center)

                    if let desc = item.description {
                        Text(desc)
                            .font(.spCaption)
                            .foregroundColor(.spMuted)
                    }
                }
                .padding(.top, SP.spacing32)
                .padding(.horizontal, SP.horizontalPadding)

                // Divider
                Rectangle()
                    .fill(Color.spDivider)
                    .frame(width: 40, height: 1)
                    .padding(.vertical, SP.spacing24)

                // Prices
                priceSection
                    .padding(.horizontal, SP.horizontalPadding)

                // Tags
                if !item.tags.isEmpty {
                    tagsSection
                        .padding(.top, SP.spacing24)
                        .padding(.horizontal, SP.horizontalPadding)
                }
            }
        }
        .background(Color.spDark)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        favorites.toggle(item)
                    }
                } label: {
                    Image(systemName: favorites.isFavorite(item) ? "heart.fill" : "heart")
                        .foregroundColor(favorites.isFavorite(item) ? .spGold : .spMuted)
                }
            }
        }
    }

    // MARK: - Price

    private var priceSection: some View {
        VStack(spacing: SP.spacing8) {
            if item.prices.isEmpty {
                Text("Цена по запросу")
                    .font(.spBody)
                    .foregroundColor(.spMuted)
                    .italic()
            } else if item.prices.count == 1 {
                HStack(alignment: .firstTextBaseline, spacing: SP.spacing4) {
                    Text("\(item.prices[0].amount)")
                        .font(.system(size: 32, weight: .light, design: .default))
                        .foregroundColor(.spGold)
                    Text("₽")
                        .font(.system(size: 18, weight: .light))
                        .foregroundColor(.spGold)

                    if let label = item.prices[0].label {
                        Text("/ \(label)")
                            .font(.spCaption)
                            .foregroundColor(.spMuted)
                    }
                }
            } else {
                ForEach(item.prices) { price in
                    HStack {
                        if let label = price.label {
                            Text(label)
                                .font(.spBody)
                                .foregroundColor(.spMuted)
                        }
                        Spacer()
                        Text("\(price.amount) ₽")
                            .font(.spPrice)
                            .foregroundColor(.spGold)
                    }
                    .padding(.vertical, SP.spacing8)
                    .padding(.horizontal, SP.spacing16)
                    .background(Color.spCard)
                    .clipShape(RoundedRectangle(cornerRadius: SP.radiusSmall))
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
                    .foregroundColor(.spGold)
                    .padding(.horizontal, SP.spacing12)
                    .padding(.vertical, SP.spacing6)
                    .background(Color.spGold.opacity(0.12))
                    .clipShape(Capsule())
            }
        }
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
