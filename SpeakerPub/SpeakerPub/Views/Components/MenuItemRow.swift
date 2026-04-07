import SwiftUI

// MARK: - Menu Item Row
// Compact row used in category lists and search results.

struct MenuItemRow: View {
    let item: MenuItem
    @Environment(FavoritesManager.self) private var favorites

    var body: some View {
        HStack(alignment: .center, spacing: SP.spacing12) {
            // Content
            VStack(alignment: .leading, spacing: SP.spacing4) {
                HStack(spacing: SP.spacing6) {
                    Text(item.name)
                        .font(.spBody)
                        .foregroundColor(.spPrimaryText)
                        .lineLimit(2)

                    if favorites.isFavorite(item) {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.red.opacity(0.7))
                    }
                }

                if let desc = item.description {
                    Text(desc)
                        .font(.spCaption)
                        .foregroundColor(.spSecondaryText)
                        .lineLimit(1)
                }

                // Tags
                if !item.tags.isEmpty {
                    HStack(spacing: SP.spacing4) {
                        ForEach(item.tags.prefix(2), id: \.self) { tag in
                            Text(tag.rawValue)
                                .font(.spSmall)
                                .foregroundColor(.spAccent)
                                .padding(.horizontal, SP.spacing6)
                                .padding(.vertical, SP.spacing2)
                                .background(Color.spAccent.opacity(0.08))
                                .clipShape(Capsule())
                        }
                    }
                }
            }

            Spacer()

            // Price
            VStack(alignment: .trailing, spacing: SP.spacing2) {
                if item.prices.isEmpty {
                    Text("по запросу")
                        .font(.spCaption)
                        .foregroundColor(.spSecondaryText)
                        .italic()
                } else {
                    Text(item.shortPriceDisplay)
                        .font(.spPrice)
                        .foregroundColor(.spPrice)
                }
            }

            // Chevron
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.spDivider)
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
        Divider()
        MenuItemRow(item: MenuItem(
            name: "Guest Cask Ale",
            description: "Спрашивайте у бармена",
            prices: [],
            tags: [.caskAle]
        ))
    }
    .background(Color.spCardBackground)
    .environment(FavoritesManager.shared)
}
