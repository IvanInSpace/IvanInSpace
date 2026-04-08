import SwiftUI

// MARK: - Bar Menu View
// Custom circular pager — no TabView

struct BarMenuView: View {
    @State private var currentSlide = 0
    @State private var selectedCategory: Int? = nil
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

    var body: some View {
        NavigationStack {
            ZStack {
                // Full-screen slide
                SlideCard(
                    imageNames: slideData[currentSlide].images,
                    title: slideData[currentSlide].title,
                    totalSlides: totalSlides,
                    slideIndex: currentSlide
                )
                .id(currentSlide)
                .transition(.opacity)
            }
            .ignoresSafeArea()
            .gesture(
                DragGesture(minimumDistance: 50, coordinateSpace: .local)
                    .onEnded { value in
                        // Only horizontal swipes (ignore vertical)
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
                selectedCategory = currentSlide
            }
            .navigationDestination(item: $selectedCategory) { index in
                DrinksCategoryListView(
                    title: slideData[index].title,
                    categories: categoriesForSlide[index]
                )
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

// MARK: - Shared Slide Card (full screen, no frame constraint)

struct SlideCard: View {
    let imageNames: [String]
    let title: String
    let totalSlides: Int
    let slideIndex: Int

    @State private var currentImageIndex = 0
    private let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            // Rotating background images — fill entire screen
            ForEach(0..<imageNames.count, id: \.self) { index in
                Image(imageNames[index])
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                    .opacity(index == currentImageIndex ? 1 : 0)
            }

            Color.black.opacity(0.45)
                .ignoresSafeArea()

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

                HStack(spacing: 4) {
                    ForEach(0..<totalSlides, id: \.self) { i in
                        Circle()
                            .fill(i == slideIndex ? Color.white : Color.white.opacity(0.3))
                            .frame(width: 5, height: 5)
                    }
                }
                .padding(.top, SP.spacing12)

                Spacer().frame(height: 120)
            }
        }
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
