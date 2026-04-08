import SwiftUI

// MARK: - Kitchen Menu View
// Horizontal paging slider with 9 category cards (like Bar)

struct KitchenMenuView: View {
    // Each slide: (category, image asset name, display title)
    private let slides: [(MenuCategory, String, String)] = [
        (MenuData.coldStarters, "cold_starters", "Холодные закуски"),
        (MenuData.hotStarters, "hot_starters", "Горячие закуски"),
        (MenuData.salads, "salads", "Салаты"),
        (MenuData.soups, "soups", "Супы"),
        (MenuData.burgerAndMore, "burgers", "Бургеры"),
        (MenuData.sandwiches, "sandwiches", "Сэндвичи"),
        (MenuData.hotDishes, "hot_dishes", "Горячие блюда"),
        (MenuData.englishPies, "english_pies", "Английские пироги"),
        (MenuData.desserts, "desserts", "Десерты")
    ]

    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 0) {
                        ForEach(0..<slides.count, id: \.self) { index in
                            let (category, image, title) = slides[index]
                            NavigationLink {
                                KitchenCategoryDetailView(category: category)
                            } label: {
                                KitchenHeroCard(
                                    imageName: image,
                                    title: title,
                                    size: geo.size,
                                    totalSlides: slides.count,
                                    currentIndex: index
                                )
                            }
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.paging)
            }
            .background(Color.spDark)
            .ignoresSafeArea()
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Kitchen Hero Card

struct KitchenHeroCard: View {
    let imageName: String
    let title: String
    let size: CGSize
    let totalSlides: Int
    let currentIndex: Int

    var body: some View {
        ZStack {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width, height: size.height)
                .clipped()

            Color.black.opacity(0.45)

            VStack {
                Spacer()

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

                // Slide dots
                HStack(spacing: 4) {
                    ForEach(0..<totalSlides, id: \.self) { i in
                        Circle()
                            .fill(i == currentIndex ? Color.white : Color.white.opacity(0.3))
                            .frame(width: 5, height: 5)
                    }
                }
                .padding(.top, SP.spacing12)

                Spacer().frame(height: 100)
            }
        }
        .frame(width: size.width, height: size.height)
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
            .padding(.bottom, 90)
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
