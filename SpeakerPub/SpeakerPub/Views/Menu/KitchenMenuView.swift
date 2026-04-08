import SwiftUI

// MARK: - Kitchen Menu View
// Horizontal paging slider, each slide has rotating background images

struct KitchenMenuView: View {
    // Each slide: (category, image names array, display title)
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

    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 0) {
                        ForEach(0..<slides.count, id: \.self) { index in
                            let (category, images, title) = slides[index]
                            NavigationLink {
                                KitchenCategoryDetailView(category: category)
                            } label: {
                                KitchenHeroCard(
                                    imageNames: images,
                                    title: title,
                                    size: geo.size,
                                    totalSlides: slides.count,
                                    slideIndex: index
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

// MARK: - Kitchen Hero Card (rotating backgrounds)

struct KitchenHeroCard: View {
    let imageNames: [String]
    let title: String
    let size: CGSize
    let totalSlides: Int
    let slideIndex: Int

    @State private var currentImageIndex = 0
    private let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            // Rotating backgrounds
            ForEach(0..<imageNames.count, id: \.self) { index in
                Image(imageNames[index])
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                    .clipped()
                    .opacity(index == currentImageIndex ? 1 : 0)
            }

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
                            .fill(i == slideIndex ? Color.white : Color.white.opacity(0.3))
                            .frame(width: 5, height: 5)
                    }
                }
                .padding(.top, SP.spacing12)

                Spacer().frame(height: 100)
            }
        }
        .frame(width: size.width, height: size.height)
        .onReceive(timer) { _ in
            guard imageNames.count > 1 else { return }
            withAnimation(.easeInOut(duration: 0.8)) {
                currentImageIndex = (currentImageIndex + 1) % imageNames.count
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
