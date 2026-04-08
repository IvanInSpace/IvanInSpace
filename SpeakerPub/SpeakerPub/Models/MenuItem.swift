import Foundation

// MARK: - Menu Data Models

struct MenuSection: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let icon: String
    let categories: [MenuCategory]
}

struct MenuCategory: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let volumeInfo: String?
    let items: [MenuItem]

    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    static func == (lhs: MenuCategory, rhs: MenuCategory) -> Bool { lhs.id == rhs.id }
}

struct MenuItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let description: String?
    let prices: [PriceOption]

    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    static func == (lhs: MenuItem, rhs: MenuItem) -> Bool { lhs.id == rhs.id }

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
    let label: String?
}
