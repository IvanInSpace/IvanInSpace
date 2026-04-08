import SwiftUI

// MARK: - Kitchen Menu View
// Full-screen slide with left sidebar category list + search

struct KitchenMenuView: View {
    @State private var currentSlide = 0
    @State private var selectedCategory: Int? = nil
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

    private var allKitchenItems: [(MenuItem, String)] {
        slides.flatMap { (cat, _, name) in
            cat.items.map { ($0, name) }
        }
    }

    private var searchResults: [(MenuItem, String)] {
        guard !searchQuery.isEmpty else { return [] }
        let q = searchQuery.lowercased()
        return allKitchenItems.filter { $0.0.name.lowercased().contains(q) }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                // Background slide
                let (_, images, _) = slides[currentSlide]
                SlideCard(
                    imageNames: images,
                    title: "",
                    totalSlides: slides.count,
                    slideIndex: currentSlide,
                    showOverlayUI: false
                )
                .id(currentSlide)
                .transition(.opacity)

                // Darker overlay for text readability
                Color.black.opacity(0.5)

                // Content overlay
                if showSearch {
                    searchOverlay
                } else {
                    mainOverlay
                }
            }
            .ignoresSafeArea()
            .gesture(
                DragGesture(minimumDistance: 50, coordinateSpace: .local)
                    .onEnded { value in
                        guard !showSearch else { return }
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
                if !showSearch {
                    selectedCategory = currentSlide
                }
            }
            .navigationDestination(item: $selectedCategory) { index in
                KitchenCategoryDetailView(category: slides[index].0)
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    // MARK: - Main Overlay (category list + search icon)

    private var mainOverlay: some View {
        GeometryReader { geo in
            VStack(alignment: .leading, spacing: 0) {
                // 30% top offset
                Spacer().frame(height: geo.size.height * 0.3)

                // Search icon row (right-aligned, same level as first category)
                HStack {
                    Spacer()
                    Button {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            showSearch = true
                        }
                    } label: {
                        VStack(spacing: 4) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 18, weight: .light))
                            Text("Поиск")
                                .font(.system(size: 9, weight: .regular))
                                .tracking(0.5)
                        }
                        .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.trailing, SP.horizontalPadding)
                }

                // Category list — left side
                ScrollViewReader { proxy in
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: SP.spacing4) {
                            ForEach(0..<slides.count, id: \.self) { index in
                                Button {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        currentSlide = index
                                    }
                                } label: {
                                    Text(slides[index].2)
                                        .font(index == currentSlide
                                              ? .system(size: 20, weight: .medium)
                                              : .system(size: 14, weight: .regular))
                                        .foregroundColor(index == currentSlide
                                                         ? .white
                                                         : .white.opacity(0.4))
                                        .animation(.easeInOut(duration: 0.2), value: currentSlide)
                                }
                                .id(index)
                            }
                        }
                        .padding(.leading, SP.horizontalPadding)
                        .padding(.top, SP.spacing16)
                    }
                    .onChange(of: currentSlide) { _, newValue in
                        withAnimation {
                            proxy.scrollTo(newValue, anchor: .center)
                        }
                    }
                }

                Spacer()

                // Bottom hint + dots
                VStack(spacing: SP.spacing12) {
                    Text("Перейти в меню")
                        .font(.system(size: 12, weight: .regular))
                        .tracking(1)
                        .foregroundColor(.white.opacity(0.5))

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

    // MARK: - Search Overlay

    private var searchOverlay: some View {
        VStack(spacing: 0) {
            // Search bar
            HStack(spacing: SP.spacing12) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 15))
                    .foregroundColor(.spMuted)

                TextField("Поиск по кухне", text: $searchQuery)
                    .font(.spBody)
                    .foregroundColor(.spCream)
                    .autocorrectionDisabled()

                Button {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        searchQuery = ""
                        showSearch = false
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.spMuted)
                }
            }
            .padding(.horizontal, SP.spacing16)
            .padding(.vertical, SP.spacing12)
            .background(Color.spCard)
            .clipShape(RoundedRectangle(cornerRadius: SP.radiusSmall))
            .padding(.horizontal, SP.horizontalPadding)
            .padding(.top, 70)

            if searchQuery.isEmpty {
                Spacer()
            } else if searchResults.isEmpty {
                VStack(spacing: SP.spacing12) {
                    Spacer()
                    Text("Ничего не найдено")
                        .font(.spBody)
                        .foregroundColor(.spMuted)
                    Spacer()
                }
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(Array(searchResults.enumerated()), id: \.offset) { _, pair in
                            let (item, categoryName) = pair
                            VStack(alignment: .leading, spacing: SP.spacing2) {
                                HStack {
                                    Text(item.name)
                                        .font(.spBody)
                                        .foregroundColor(.spCream)
                                    Spacer()
                                    Text(item.shortPriceDisplay)
                                        .font(.spPrice)
                                        .foregroundColor(.spGold)
                                }
                                Text(categoryName)
                                    .font(.spCaption)
                                    .foregroundColor(.spMuted)
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
