import SwiftUI

// MARK: - Home Screen

struct HomeView: View {
    @Environment(FavoritesManager.self) private var favorites
    @State private var searchText = ""

    private var allItems: [MenuItem] {
        MenuData.sections.flatMap { $0.categories.flatMap(\.items) }
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
                    homeContent
                } else {
                    searchResults
                }
            }
            .background(Color.spBackground)
            .navigationTitle("")
            .searchable(text: $searchText, prompt: "Поиск по меню")
        }
    }

    // MARK: - Home Content

    private var homeContent: some View {
        VStack(spacing: 0) {
            heroSection
            quickLinksSection
            eventsSection
            popularSection
            favoritesSection
        }
    }

    // MARK: - Hero

    private var heroSection: some View {
        VStack(spacing: SP.spacing12) {
            Spacer().frame(height: SP.spacing20)

            // Decorative top ornament
            HStack(spacing: SP.spacing8) {
                ornamentLine
                Image(systemName: "star.fill")
                    .font(.system(size: 8))
                    .foregroundColor(.spAccent)
                ornamentLine
            }
            .padding(.horizontal, SP.spacing40)

            Text("THE SPEAKER PUB")
                .font(.system(size: 13, weight: .medium, design: .default))
                .tracking(6)
                .foregroundColor(.spSecondaryText)

            Text("Бар")
                .font(.system(size: 42, weight: .bold, design: .serif))
                .italic()
                .foregroundColor(.spAccentDark)

            Text("Английский паб в Москве")
                .font(.spCaption)
                .foregroundColor(.spSecondaryText)
                .padding(.top, SP.spacing2)

            // Decorative bottom ornament
            HStack(spacing: SP.spacing8) {
                ornamentLine
                Image(systemName: "star.fill")
                    .font(.system(size: 8))
                    .foregroundColor(.spAccent)
                ornamentLine
            }
            .padding(.horizontal, SP.spacing40)

            Text("Москва · ул. Покровка, 48")
                .font(.spCaption)
                .foregroundColor(.spSecondaryText)

            Spacer().frame(height: SP.spacing8)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, SP.spacing24)
        .background(
            LinearGradient(
                colors: [Color.spCardBackground, Color.spBackground],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }

    private var ornamentLine: some View {
        Rectangle()
            .fill(Color.spDivider)
            .frame(height: 1)
    }

    // MARK: - Quick Links

    private var quickLinksSection: some View {
        VStack(spacing: SP.spacing16) {
            sectionHeader("Меню")

            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: SP.spacing12),
                GridItem(.flexible(), spacing: SP.spacing12)
            ], spacing: SP.spacing12) {
                ForEach(MenuData.sections) { section in
                    NavigationLink {
                        MenuSectionView(section: section)
                    } label: {
                        QuickLinkCard(
                            title: section.name,
                            icon: section.icon,
                            count: section.categories.flatMap(\.items).count
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.horizontal, SP.horizontalPadding)
        .padding(.vertical, SP.spacing24)
    }

    // MARK: - Events

    private var eventsSection: some View {
        let events = BarInfo.shared.events
        return Group {
            if !events.isEmpty {
                VStack(spacing: SP.spacing16) {
                    sectionHeader("События")
                        .padding(.horizontal, SP.horizontalPadding)

                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: SP.spacing12) {
                            ForEach(events) { event in
                                EventCard(event: event)
                            }
                        }
                        .padding(.horizontal, SP.horizontalPadding)
                    }
                }
                .padding(.vertical, SP.spacing24)
            }
        }
    }

    // MARK: - Popular Items

    private var popularSection: some View {
        let popular = allItems.filter { $0.tags.contains(.popular) || $0.tags.contains(.houseFavorite) }
        return Group {
            if !popular.isEmpty {
                VStack(spacing: SP.spacing16) {
                    sectionHeader("Рекомендуем")

                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: SP.spacing12) {
                            ForEach(popular) { item in
                                NavigationLink {
                                    MenuItemDetailView(item: item)
                                } label: {
                                    PopularItemCard(item: item)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, SP.horizontalPadding)
                    }
                }
                .padding(.vertical, SP.spacing24)
            }
        }
    }

    // MARK: - Favorites

    private var favoritesSection: some View {
        let favs = favorites.favoriteItems(from: MenuData.sections)
        return Group {
            if !favs.isEmpty {
                VStack(spacing: SP.spacing16) {
                    sectionHeader("Избранное")
                        .padding(.horizontal, SP.horizontalPadding)

                    VStack(spacing: 0) {
                        ForEach(favs) { item in
                            NavigationLink {
                                MenuItemDetailView(item: item)
                            } label: {
                                MenuItemRow(item: item)
                            }
                            .buttonStyle(.plain)

                            if item.id != favs.last?.id {
                                Divider()
                                    .padding(.leading, SP.horizontalPadding)
                            }
                        }
                    }
                    .background(Color.spCardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: SP.cardRadius))
                    .padding(.horizontal, SP.horizontalPadding)
                }
                .padding(.vertical, SP.spacing24)
            }
        }
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
                Text("\(filteredItems.count) \(itemsCountText(filteredItems.count))")
                    .font(.spCaption)
                    .foregroundColor(.spSecondaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, SP.horizontalPadding)
                    .padding(.vertical, SP.spacing8)

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
            }
        }
        .padding(.top, SP.spacing16)
    }

    // MARK: - Helpers

    private func sectionHeader(_ title: String) -> some View {
        HStack {
            Text(title)
                .font(.spSectionHeader)
                .foregroundColor(.spPrimaryText)
            Spacer()
        }
    }

    private func itemsCountText(_ count: Int) -> String {
        let mod10 = count % 10
        let mod100 = count % 100
        if mod10 == 1 && mod100 != 11 { return "позиция" }
        if mod10 >= 2 && mod10 <= 4 && (mod100 < 12 || mod100 > 14) { return "позиции" }
        return "позиций"
    }
}

// MARK: - Quick Link Card

struct QuickLinkCard: View {
    let title: String
    let icon: String
    let count: Int

    var body: some View {
        VStack(spacing: SP.spacing8) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundColor(.spAccent)

            Text(title)
                .font(.spBodyBold)
                .foregroundColor(.spPrimaryText)

            Text("\(count) позиций")
                .font(.spCaption)
                .foregroundColor(.spSecondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, SP.spacing20)
        .background(Color.spCardBackground)
        .clipShape(RoundedRectangle(cornerRadius: SP.cardRadius))
        .overlay(
            RoundedRectangle(cornerRadius: SP.cardRadius)
                .stroke(Color.spDivider, lineWidth: 1)
        )
    }
}

// MARK: - Popular Item Card

struct PopularItemCard: View {
    let item: MenuItem

    var body: some View {
        VStack(alignment: .leading, spacing: SP.spacing8) {
            // Icon placeholder for the item category
            ZStack {
                RoundedRectangle(cornerRadius: SP.radiusSmall)
                    .fill(Color.spAccent.opacity(0.1))
                    .frame(height: 80)

                Image(systemName: itemIcon)
                    .font(.system(size: 32))
                    .foregroundColor(.spAccent)
            }

            Text(item.name)
                .font(.spBodyBold)
                .foregroundColor(.spPrimaryText)
                .lineLimit(2)
                .multilineTextAlignment(.leading)

            if let desc = item.description {
                Text(desc)
                    .font(.spCaption)
                    .foregroundColor(.spSecondaryText)
                    .lineLimit(1)
            }

            Text(item.shortPriceDisplay)
                .font(.spPrice)
                .foregroundColor(.spPrice)
        }
        .frame(width: 160)
        .padding(SP.spacing12)
        .background(Color.spCardBackground)
        .clipShape(RoundedRectangle(cornerRadius: SP.cardRadius))
        .overlay(
            RoundedRectangle(cornerRadius: SP.cardRadius)
                .stroke(Color.spDivider, lineWidth: 1)
        )
    }

    private var itemIcon: String {
        if item.tags.contains(.caskAle) { return "mug" }
        if item.tags.contains(.houseFavorite) { return "star.fill" }
        return "cup.and.saucer"
    }
}

// MARK: - Event Card

struct EventCard: View {
    let event: BarEvent

    var body: some View {
        VStack(alignment: .leading, spacing: SP.spacing8) {
            Image(systemName: event.icon)
                .font(.system(size: 24))
                .foregroundColor(.spAccent)

            Text(event.title)
                .font(.spBodyBold)
                .foregroundColor(.spPrimaryText)

            Text(event.day)
                .font(.spSmall)
                .foregroundColor(.spAccent)
                .padding(.horizontal, SP.spacing8)
                .padding(.vertical, SP.spacing4)
                .background(Color.spAccent.opacity(0.1))
                .clipShape(Capsule())

            Text(event.description)
                .font(.spCaption)
                .foregroundColor(.spSecondaryText)
                .lineLimit(3)
        }
        .frame(width: 200, alignment: .leading)
        .padding(SP.spacing16)
        .background(Color.spCardBackground)
        .clipShape(RoundedRectangle(cornerRadius: SP.cardRadius))
        .overlay(
            RoundedRectangle(cornerRadius: SP.cardRadius)
                .stroke(Color.spDivider, lineWidth: 1)
        )
    }
}

#Preview {
    HomeView()
        .environment(FavoritesManager.shared)
}
