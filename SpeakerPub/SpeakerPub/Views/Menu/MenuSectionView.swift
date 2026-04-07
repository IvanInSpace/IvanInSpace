import SwiftUI

// MARK: - Menu Section View
// Displays all categories within a section (Bar or Kitchen).

struct MenuSectionView: View {
    let section: MenuSection
    @State private var searchText = ""

    private var allItems: [MenuItem] {
        section.categories.flatMap(\.items)
    }

    private var filteredItems: [MenuItem] {
        guard !searchText.isEmpty else { return [] }
        let query = searchText.lowercased()
        return allItems.filter {
            $0.name.lowercased().contains(query) ||
            ($0.description?.lowercased().contains(query) ?? false)
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                if searchText.isEmpty {
                    categoryList
                } else {
                    searchResults
                }
            }
            .background(Color.spBackground)
            .navigationTitle(section.name)
            .searchable(text: $searchText, prompt: "Поиск в \(section.name.lowercased())")
        }
    }

    // MARK: - Category List

    private var categoryList: some View {
        LazyVStack(spacing: SP.spacing24, pinnedViews: .sectionHeaders) {
            ForEach(section.categories) { category in
                MenuCategoryBlock(category: category)
            }
        }
        .padding(.vertical, SP.spacing16)
    }

    // MARK: - Search Results

    private var searchResults: some View {
        VStack(spacing: 0) {
            if filteredItems.isEmpty {
                VStack(spacing: SP.spacing12) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 40))
                        .foregroundColor(.spSecondaryText)
                    Text("Ничего не найдено")
                        .font(.spBody)
                        .foregroundColor(.spSecondaryText)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 80)
            } else {
                LazyVStack(spacing: 0) {
                    ForEach(filteredItems) { item in
                        NavigationLink {
                            MenuItemDetailView(item: item)
                        } label: {
                            MenuItemRow(item: item)
                        }
                        .buttonStyle(.plain)

                        Divider()
                            .padding(.leading, SP.horizontalPadding)
                    }
                }
                .background(Color.spCardBackground)
                .clipShape(RoundedRectangle(cornerRadius: SP.cardRadius))
                .padding(.horizontal, SP.horizontalPadding)
                .padding(.top, SP.spacing16)
            }
        }
    }
}

// MARK: - Category Block

struct MenuCategoryBlock: View {
    let category: MenuCategory

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Category header
            VStack(alignment: .leading, spacing: SP.spacing4) {
                Text(category.name)
                    .font(.spSectionHeader)
                    .foregroundColor(.spAccentDark)

                if let volume = category.volumeInfo {
                    Text(volume)
                        .font(.spCaption)
                        .foregroundColor(.spSecondaryText)
                }
            }
            .padding(.horizontal, SP.horizontalPadding)
            .padding(.bottom, SP.spacing12)

            // Items
            VStack(spacing: 0) {
                ForEach(category.items) { item in
                    NavigationLink {
                        MenuItemDetailView(item: item)
                    } label: {
                        MenuItemRow(item: item)
                    }
                    .buttonStyle(.plain)

                    if item.id != category.items.last?.id {
                        Divider()
                            .padding(.leading, SP.horizontalPadding)
                    }
                }
            }
            .background(Color.spCardBackground)
            .clipShape(RoundedRectangle(cornerRadius: SP.cardRadius))
            .padding(.horizontal, SP.horizontalPadding)
        }
    }
}

#Preview {
    MenuSectionView(section: MenuData.barSection)
        .environment(FavoritesManager.shared)
}
