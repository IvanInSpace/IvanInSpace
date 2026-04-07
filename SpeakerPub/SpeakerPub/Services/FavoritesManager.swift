import SwiftUI

// MARK: - Favorites Manager
// Persists favorite items using UserDefaults.

@Observable
final class FavoritesManager {
    static let shared = FavoritesManager()

    private let key = "speaker_pub_favorites"
    private(set) var favoriteIDs: Set<String> = []

    private init() {
        if let saved = UserDefaults.standard.array(forKey: key) as? [String] {
            favoriteIDs = Set(saved)
        }
    }

    func isFavorite(_ item: MenuItem) -> Bool {
        favoriteIDs.contains(item.name)
    }

    func toggle(_ item: MenuItem) {
        if favoriteIDs.contains(item.name) {
            favoriteIDs.remove(item.name)
        } else {
            favoriteIDs.insert(item.name)
        }
        save()
    }

    func favoriteItems(from sections: [MenuSection]) -> [MenuItem] {
        sections.flatMap { $0.categories.flatMap(\.items) }
            .filter { favoriteIDs.contains($0.name) }
    }

    private func save() {
        UserDefaults.standard.set(Array(favoriteIDs), forKey: key)
    }
}
