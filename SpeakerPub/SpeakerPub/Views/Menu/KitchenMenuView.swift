import SwiftUI

// MARK: - Kitchen Menu View
// Circular pager with 9 slides

struct KitchenMenuView: View {
    @State private var currentSlide = 0

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
                ZStack {
                    let (category, images, title) = slides[currentSlide]

                    NavigationLink {
                        KitchenCategoryDetailView(category: category)
                    } label: {
                        SlideCard(
                            imageNames: images,
                            title: title,
                            size: geo.size,
                            totalSlides: slides.count,
                            slideIndex: currentSlide
                        )
                    }
                }
                .gesture(
                    DragGesture(minimumDistance: 50)
                        .onEnded { value in
                            withAnimation(.easeInOut(duration: 0.3)) {
                                if value.translation.width < 0 {
                                    currentSlide = (currentSlide + 1) % slides.count
                                } else {
                                    currentSlide = (currentSlide - 1 + slides.count) % slides.count
                                }
                            }
                        }
                )
            }
            .background(Color.spDark)
            .ignoresSafeArea()
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Kitchen Category Detail

struct KitchenCategoryDetailView: View {
    let category: MenuCategory
    @Environment(\.dismiss) private var dismiss

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
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButton { dismiss() }
            }
            ToolbarItem(placement: .principal) {
                Text(category.name)
                    .font(.spSubsection)
                    .foregroundColor(.spCream)
            }
        }
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

#Preview {
    KitchenMenuView()
}
