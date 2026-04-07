import Foundation

// MARK: - Menu Data Models

struct MenuSection: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let icon: String          // SF Symbol name
    let categories: [MenuCategory]
}

struct MenuCategory: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let volumeInfo: String?   // e.g. "568/280 мл", "40 мл"
    let items: [MenuItem]

    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    static func == (lhs: MenuCategory, rhs: MenuCategory) -> Bool { lhs.id == rhs.id }
}

struct MenuItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let description: String?
    let prices: [PriceOption]
    let tags: [ItemTag]

    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    static func == (lhs: MenuItem, rhs: MenuItem) -> Bool { lhs.id == rhs.id }

    var primaryPrice: Int? {
        prices.first?.amount
    }

    var priceDisplay: String {
        if prices.isEmpty { return "" }
        if prices.count == 1 {
            return "\(prices[0].amount) ₽"
        }
        return prices.map { p in
            if let label = p.label {
                return "\(label) — \(p.amount) ₽"
            }
            return "\(p.amount) ₽"
        }.joined(separator: " / ")
    }

    var shortPriceDisplay: String {
        if prices.isEmpty { return "" }
        if prices.count == 1 {
            return "\(prices[0].amount) ₽"
        }
        return prices.map { "\($0.amount)" }.joined(separator: "/") + " ₽"
    }
}

struct PriceOption: Identifiable, Hashable {
    let id = UUID()
    let amount: Int
    let label: String?       // e.g. "568 мл", "бутылка"
}

enum ItemTag: String, CaseIterable {
    case popular = "Популярное"
    case spicy = "Острое"
    case vegetarian = "Вегетарианское"
    case nonAlcoholic = "Безалкогольное"
    case houseFavorite = "Выбор бара"
    case caskAle = "Каск Эль"
}
