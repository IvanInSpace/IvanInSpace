import SwiftUI

// MARK: - Menu Item Row

struct MenuItemRow: View {
    let item: MenuItem
    @Environment(FavoritesManager.self) private var favorites

    var body: some View {
        HStack(alignment: .center, spacing: SP.spacing12) {
            VStack(alignment: .leading, spacing: SP.spacing4) {
                HStack(spacing: SP.spacing6) {
                    Text(item.name)
                        .font(.spBody)
                        .foregroundColor(.spCream)
                        .lineLimit(2)

                    if favorites.isFavorite(item) {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 9))
                            .foregroundColor(.spGold.opacity(0.7))
                    }
                }

                if let desc = item.description {
                    Text(desc)
                        .font(.spCaption)
                        .foregroundColor(.spMuted)
                        .lineLimit(1)
                }
            }

            Spacer()

            if item.prices.isEmpty {
                Text("по запросу")
                    .font(.spCaption)
                    .foregroundColor(.spMuted)
                    .italic()
            } else {
                Text(item.shortPriceDisplay)
                    .font(.spPrice)
                    .foregroundColor(.spGold)
            }
        }
        .padding(.horizontal, SP.horizontalPadding)
        .padding(.vertical, SP.spacing12)
        .contentShape(Rectangle())
    }
}

#Preview {
    VStack(spacing: 0) {
        MenuItemRow(item: MenuItem(
            name: "Guinness",
            description: "Ирландский стаут",
            prices: [PriceOption(amount: 950, label: "568 мл"), PriceOption(amount: 500, label: "280 мл")],
            tags: [.popular]
        ))
        Divider().background(Color.spDivider)
        MenuItemRow(item: MenuItem(
            name: "Guest Cask Ale",
            description: "Спрашивайте у бармена",
            prices: [],
            tags: [.caskAle]
        ))
    }
    .background(Color.spCard)
    .environment(FavoritesManager.shared)
}
