import SwiftUI

// MARK: - Bar Menu View

struct BarMenuView: View {
    @State private var currentSlide = 0
    @State private var selectedCategory: Int? = nil
    @State private var showSections = false
    @State private var showSearch = false
    @State private var searchQuery = ""
    private let totalSlides = 2

    private let slideData: [(title: String, images: [String])] = [
        ("Cask & Keg", ["draft_1", "draft_2", "draft_3"]),
        ("Cocktails & Soft", ["cocktails_1", "cocktails_2", "cocktails_3"])
    ]

    private var categoriesForSlide: [[MenuCategory]] {
        let excluded = MenuData.draughtBeer.id
        let cocktailsCats = MenuData.barSection.categories.filter { $0.id != excluded }
        return [[MenuData.draughtBeer], cocktailsCats]
    }

    private var allBarItems: [MenuItem] {
        MenuData.barSection.categories.flatMap(\.items)
    }

    private var searchResults: [MenuItem] {
        guard !searchQuery.isEmpty else { return [] }
        let q = searchQuery.lowercased()
        return allBarItems.filter { $0.name.lowercased().contains(q) }
    }

    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ZStack {
                    // Background slide
                    SlideCard(
                        imageNames: slideData[currentSlide].images,
                        title: "",
                        totalSlides: totalSlides,
                        slideIndex: currentSlide,
                        showOverlayUI: false
                    )
                    .id(currentSlide)
                    .blur(radius: (showSections || showSearch) ? 8 : 0)
                    .animation(.easeInOut(duration: 0.35), value: showSections)
                    .animation(.easeInOut(duration: 0.35), value: showSearch)

                    // Dark overlay
                    Color.black.opacity((showSections || showSearch) ? 0.7 : 0.5)
                        .animation(.easeInOut(duration: 0.35), value: showSections)
                        .animation(.easeInOut(duration: 0.35), value: showSearch)

                    // Top row: "Все разделы" center + search right
                    VStack {
                        ZStack {
                            // Centered: "Все разделы"
                            Button {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                    showSections.toggle()
                                    if showSections { showSearch = false; searchQuery = "" }
                                }
                            } label: {
                                HStack(spacing: 6) {
                                    Text("Все разделы")
                                        .font(.system(size: 15, weight: .regular))
                                    Image(systemName: showSections ? "chevron.down" : "chevron.right")
                                        .font(.system(size: 11, weight: .medium))
                                }
                                .foregroundColor(.white.opacity(0.7))
                            }

                            // Right: search
                            HStack {
                                Spacer()
                                Button {
                                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                        showSearch.toggle()
                                        if showSearch { showSections = false }
                                        if !showSearch { searchQuery = "" }
                                    }
                                } label: {
                                    Image(systemName: "magnifyingglass")
                                        .font(.system(size: 18, weight: .light))
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                .padding(.trailing, SP.horizontalPadding)
                            }
                        }
                        .padding(.top, geo.safeAreaInsets.top + geo.size.height * 0.12)
                        Spacer()
                    }

                    // Section list
                    if showSections {
                        sectionList(geo: geo)
                    }

                    // Search overlay
                    if showSearch {
                        searchOverlay(geo: geo)
                    }

                    // Bottom UI
                    if !showSections && !showSearch {
                        bottomUI
                    }
                }
            }
            .ignoresSafeArea()
            .gesture(
                DragGesture(minimumDistance: 50, coordinateSpace: .local)
                    .onEnded { value in
                        guard !showSections && !showSearch else { return }
                        guard abs(value.translation.width) > abs(value.translation.height) else { return }
                        withAnimation(.easeInOut(duration: 0.3)) {
                            if value.translation.width < 0 {
                                currentSlide = (currentSlide + 1) % totalSlides
                            } else {
                                currentSlide = (currentSlide - 1 + totalSlides) % totalSlides
                            }
                        }
                    }
            )
            .onTapGesture {
                if showSections {
                    withAnimation(.easeInOut(duration: 0.25)) { showSections = false }
                } else if showSearch {
                    withAnimation(.easeInOut(duration: 0.25)) { showSearch = false; searchQuery = "" }
                } else {
                    selectedCategory = currentSlide
                }
            }
            .sensoryFeedback(.selection, trigger: selectedCategory)
            .navigationDestination(item: $selectedCategory) { index in
                DrinksCategoryListView(
                    title: slideData[index].title,
                    categories: categoriesForSlide[index]
                )
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    // MARK: - Section List

    private func sectionList(geo: GeometryProxy) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer().frame(height: geo.safeAreaInsets.top + geo.size.height * 0.2)

            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: SP.spacing20) {
                        ForEach(0..<totalSlides, id: \.self) { index in
                            Button {
                                showSections = false
                                selectedCategory = index
                            } label: {
                                Text(slideData[index].title)
                                    .font(index == currentSlide
                                          ? .system(size: 22, weight: .medium)
                                          : .system(size: 15, weight: .regular))
                                    .foregroundColor(index == currentSlide
                                                     ? .white
                                                     : .white.opacity(0.4))
                            }
                            .id(index)
                        }
                    }
                    .padding(.leading, SP.horizontalPadding)
                    .padding(.vertical, SP.spacing8)
                }
                .onAppear {
                    proxy.scrollTo(currentSlide, anchor: .center)
                }
            }

            Spacer()
        }
        .transition(.opacity.combined(with: .move(edge: .top)))
    }

    // MARK: - Search Overlay

    private func searchOverlay(geo: GeometryProxy) -> some View {
        VStack(spacing: 0) {
            Spacer().frame(height: geo.safeAreaInsets.top + geo.size.height * 0.2)

            HStack(spacing: SP.spacing12) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 15))
                    .foregroundColor(.spMuted)

                TextField("Поиск по бару", text: $searchQuery)
                    .font(.spBody)
                    .foregroundColor(.spCream)
                    .autocorrectionDisabled()

                if !searchQuery.isEmpty {
                    Button {
                        searchQuery = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.spMuted)
                    }
                }
            }
            .padding(.horizontal, SP.spacing16)
            .padding(.vertical, SP.spacing12)
            .background(Color.spCard)
            .clipShape(RoundedRectangle(cornerRadius: SP.radiusSmall))
            .padding(.horizontal, SP.horizontalPadding)

            if !searchQuery.isEmpty {
                if searchResults.isEmpty {
                    VStack {
                        Spacer()
                        Text("Ничего не найдено")
                            .font(.spBody)
                            .foregroundColor(.spMuted)
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(searchResults) { item in
                                HStack {
                                    Text(item.name)
                                        .font(.spBody)
                                        .foregroundColor(.spCream)
                                    Spacer()
                                    Text(item.shortPriceDisplay)
                                        .font(.spPrice)
                                        .foregroundColor(.spGold)
                                }
                                .padding(.horizontal, SP.horizontalPadding)
                                .padding(.vertical, SP.spacing12)

                                Divider()
                                    .background(Color.spDivider)
                                    .padding(.leading, SP.horizontalPadding)
                            }
                        }
                        .padding(.top, SP.spacing8)
                    }
                }
            } else {
                Spacer()
            }
        }
    }

    // MARK: - Bottom UI

    private var bottomUI: some View {
        VStack {
            Spacer()

            VStack(spacing: SP.spacing12) {
                // "Перейти в меню" pill
                Text("Перейти в меню")
                    .font(.system(size: 12, weight: .medium))
                    .tracking(1)
                    .foregroundColor(.white.opacity(0.85))
                    .padding(.horizontal, SP.spacing24)
                    .padding(.vertical, SP.spacing8)
                    .background(Color.black.opacity(0.4))
                    .background(.ultraThinMaterial.opacity(0.5))
                    .clipShape(Capsule())

                // Category name
                Text(slideData[currentSlide].title)
                    .font(.spHero)
                    .tracking(2)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 8, y: 4)

                // Swipe arrows
                HStack(spacing: SP.spacing24) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .light))
                        .foregroundColor(.white.opacity(0.4))
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .light))
                        .foregroundColor(.white.opacity(0.4))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 92)
        }
    }
}

// MARK: - Shared Slide Card

struct SlideCard: View {
    let imageNames: [String]
    let title: String
    let totalSlides: Int
    let slideIndex: Int
    var showOverlayUI: Bool = true

    @State private var currentImageIndex = 0
    private let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(0..<imageNames.count, id: \.self) { index in
                    Image(imageNames[index])
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geo.size.width, height: geo.size.height)
                        .clipped()
                        .opacity(index == currentImageIndex ? 1 : 0)
                }

                if showOverlayUI {
                    Color.black.opacity(0.45)

                    VStack {
                        Spacer()

                        Text("Перейти в меню")
                            .font(.system(size: 12, weight: .regular))
                            .tracking(1)
                            .foregroundColor(.white.opacity(0.6))
                            .padding(.bottom, SP.spacing8)

                        Text(title)
                            .font(.spHero)
                            .tracking(2)
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.5), radius: 8, y: 4)

                        HStack(spacing: SP.spacing24) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 14, weight: .light))
                                .foregroundColor(.white.opacity(0.5))
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .light))
                                .foregroundColor(.white.opacity(0.5))
                        }
                        .padding(.top, SP.spacing12)
                        .padding(.bottom, 80)
                    }
                }
            }
        }
        .ignoresSafeArea()
        .onReceive(timer) { _ in
            guard imageNames.count > 1 else { return }
            withAnimation(.easeInOut(duration: 0.8)) {
                currentImageIndex = (currentImageIndex + 1) % imageNames.count
            }
        }
    }
}

// MARK: - Drinks Category List View

struct DrinksCategoryListView: View {
    let title: String
    let categories: [MenuCategory]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: SP.spacing24) {
                ForEach(categories) { category in
                    CategoryBlock(category: category)
                }

                PriceDisclaimer()
            }
            .padding(.vertical, SP.spacing16)
            .padding(.bottom, 90)
        }
        .background(Color.spDark)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

// MARK: - Price Disclaimer

struct PriceDisclaimer: View {
    var body: some View {
        Text("Цены в приложении могут отличаться от цен в заведении, уточняйте итоговую стоимость у сотрудников")
            .font(.spCaption)
            .foregroundColor(.spMuted)
            .multilineTextAlignment(.center)
            .padding(.horizontal, SP.spacing32)
            .padding(.top, SP.spacing8)
    }
}

// MARK: - Shared Category Block

struct CategoryBlock: View {
    let category: MenuCategory

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: SP.spacing2) {
                Text(category.name.uppercased())
                    .font(.spSmall)
                    .tracking(2)
                    .foregroundColor(.spGold)

                if let volume = category.volumeInfo {
                    Text(volume)
                        .font(.spCaption)
                        .foregroundColor(.spMuted)
                }
            }
            .padding(.horizontal, SP.horizontalPadding)
            .padding(.bottom, SP.spacing12)

            VStack(spacing: 0) {
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
        }
    }
}

#Preview {
    BarMenuView()
}
