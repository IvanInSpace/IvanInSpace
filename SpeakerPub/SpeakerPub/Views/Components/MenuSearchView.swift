import SwiftUI

// MARK: - Menu Search View

struct MenuSearchView: View {
    @State private var query = ""
    @Environment(\.dismiss) private var dismiss

    private var allItems: [(MenuItem, String)] {
        // Flatten all items with their category name
        var result: [(MenuItem, String)] = []
        for cat in MenuData.barSection.categories {
            for item in cat.items {
                result.append((item, cat.name))
            }
        }
        for cat in MenuData.kitchenSection.categories {
            for item in cat.items {
                result.append((item, cat.name))
            }
        }
        return result
    }

    private var filtered: [(MenuItem, String)] {
        guard !query.isEmpty else { return [] }
        let q = query.lowercased()
        return allItems.filter {
            $0.0.name.lowercased().contains(q) ||
            ($0.0.description?.lowercased().contains(q) ?? false)
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search field
                HStack(spacing: SP.spacing12) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 15))
                        .foregroundColor(.spMuted)

                    TextField("Поиск по меню", text: $query)
                        .font(.spBody)
                        .foregroundColor(.spCream)
                        .autocorrectionDisabled()

                    if !query.isEmpty {
                        Button {
                            query = ""
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
                .padding(.top, SP.spacing16)

                if query.isEmpty {
                    // Empty state
                    VStack(spacing: SP.spacing12) {
                        Spacer()
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 36, weight: .ultraLight))
                            .foregroundColor(.spMuted)
                        Text("Введите название блюда или напитка")
                            .font(.spCaption)
                            .foregroundColor(.spMuted)
                        Spacer()
                    }
                } else if filtered.isEmpty {
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
                            ForEach(Array(filtered.enumerated()), id: \.offset) { _, pair in
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
                        .padding(.bottom, 40)
                    }
                }
            }
            .background(Color.spDark)
            .navigationTitle("Поиск")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.spCream)
                    }
                }
            }
        }
    }
}

#Preview {
    MenuSearchView()
}
