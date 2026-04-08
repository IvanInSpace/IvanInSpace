import SwiftUI

// MARK: - Kitchen Menu View

struct KitchenMenuView: View {
    @State private var currentSlide = 0
    @State private var selectedCategory: Int? = nil
    @State private var showSections = false
    @State private var showSearch = false
    @State private var searchQuery = ""

    private let slides: [(MenuCategory, [String], String)] = [
        (MenuData.coldStarters, ["cold_starters_1", "cold_starters_2", "cold_starters_3"], "Холодные закуски"),
        (MenuData.hotStarters, ["hot_starters_1", "hot_starters_2", "hot_starters_3"], "Горячие закуски"),
        (MenuData.salads, ["salads_1", "salads_2", "salads_3"], "Салаты"),
        (MenuData.soups, ["soups_1", "soups_2", "soups_3"], "Супы"),
        (MenuData.burgerAndMore, ["burgers_1", "burgers_2", "burgers_3"], "Бургеры"),
        (MenuData.sandwiches, ["sandwiches_1", "sandwiches_2", "sandwiches_3"], "Сэндвичи"),
        (MenuData.hotDishes, ["hot_dishes_1", "hot_dishes_2", "hot_dishes_3"], "Горячие блюда"),
        (MenuData.englishPies, ["english_pies_1", "english_pies_2", "english_pies_3"], "Английские пироги"),
        (MenuData.desserts, ["desserts_1", "desserts_2", "desserts_3"], "Десерты")
    ]

    private var searchResults: [MenuItem] {
        guard !searchQuery.isEmpty else { return [] }
        let q = searchQuery.lowercased()
        return slides.flatMap { $0.0.items }.filter { $0.name.lowercased().contains(q) }
    }

    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ZStack {
                    // Background slide
                    let (_, images, title) = slides[currentSlide]
                    SlideCard(
                        imageNames: images,
                        title: title,
                        totalSlides: slides.count,
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

                    // Top controls: sections toggle + search
                    VStack {
                        topControls(geo: geo)
                        Spacer()
                    }

                    // Expandable section list
                    if showSections {
                        sectionList(geo: geo)
                    }

                    // Search overlay
                    if showSearch {
                        searchOverlay(geo: geo)
                    }

                    // Bottom UI (only when no overlays)
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
                                currentSlide = (currentSlide + 1) % slides.count
                            } else {
                                currentSlide = (currentSlide - 1 + slides.count) % slides.count
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
            .navigationDestination(item: $selectedCategory) { index in
                KitchenCategoryDetailView(category: slides[index].0)
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    // MARK: - Top Controls

    private func topControls(geo: GeometryProxy) -> some View {
        HStack {
            // "Все разделы" button
            Button {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                    showSections.toggle()
                    if showSections { showSearch = false; searchQuery = "" }
                }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: showSections ? "chevron.up" : "chevron.down")
                        .font(.system(size: 12, weight: .medium))
                    Text("Все разделы")
                        .font(.system(size: 13, weight: .regular))
                }
                .foregroundColor(.white.opacity(0.8))
            }

            Spacer()

            // Search icon
            Button {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                    showSearch.toggle()
                    if showSearch { showSections = false }
                    if !showSearch { searchQuery = "" }
                }
            } label: {
                VStack(spacing: 4) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 18, weight: .light))
                    Text("Поиск")
                        .font(.system(size: 9, weight: .regular))
                        .tracking(0.5)
                }
                .foregroundColor(.white.opacity(0.8))
            }
        }
        .padding(.horizontal, SP.horizontalPadding)
        .padding(.top, geo.safeAreaInsets.top + geo.size.height * 0.12)
    }

    // MARK: - Section List

    private func sectionList(geo: GeometryProxy) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer().frame(height: geo.safeAreaInsets.top + geo.size.height * 0.2)

            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: SP.spacing20) {
                        ForEach(0..<slides.count, id: \.self) { index in
                            Button {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    currentSlide = index
                                    showSections = false
                                }
                            } label: {
                                Text(slides[index].2)
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

            // Search field
            HStack(spacing: SP.spacing12) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 15))
                    .foregroundColor(.spMuted)

                TextField("Поиск по кухне", text: $searchQuery)
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

            // Results
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
                Text("Перейти в меню")
                    .font(.system(size: 12, weight: .regular))
                    .tracking(1)
                    .foregroundColor(.white.opacity(0.5))

                Text(slides[currentSlide].2)
                    .font(.spHero)
                    .tracking(2)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 8, y: 4)

                HStack(spacing: SP.spacing24) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .light))
                        .foregroundColor(.white.opacity(0.4))
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .light))
                        .foregroundColor(.white.opacity(0.4))
                }

                HStack(spacing: 4) {
                    ForEach(0..<slides.count, id: \.self) { i in
                        Circle()
                            .fill(i == currentSlide ? Color.white : Color.white.opacity(0.3))
                            .frame(width: 5, height: 5)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 80)
        }
    }
}

// MARK: - Kitchen Category Detail

struct KitchenCategoryDetailView: View {
    let category: MenuCategory

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
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
            .padding(.top, SP.spacing16)

            PriceDisclaimer()

            Spacer().frame(height: 90)
        }
        .background(Color.spDark)
        .navigationTitle(category.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

#Preview {
    KitchenMenuView()
}
