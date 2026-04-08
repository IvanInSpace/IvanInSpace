import SwiftUI

// MARK: - Home Screen

struct HomeView: View {
    @Binding var selectedTab: Int
    @State private var currentImageIndex = 0
    @State private var currentEventIndex = 0
    @State private var showProfile = false
    @State private var showSearch = false
    private let backgrounds = ["main1", "main2", "main3"]
    private let timer = Timer.publish(every: 4, on: .main, in: .common).autoconnect()
    private let info = BarInfo.shared

    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack(spacing: 0) {
                    // Photo header with logo
                    photoHeader(width: geo.size.width)

                    // Status pill
                    statusPill
                        .padding(.top, SP.spacing16)

                    // Nav icons
                    navIcons
                        .padding(.top, SP.spacing24)

                    // Events carousel
                    eventsCarousel
                        .padding(.top, SP.spacing20)

                    Spacer().frame(height: SP.spacing40)
                }
            }
            .background(Color.spDark)
            .overlay(alignment: .top) {
                // Gradient under status bar for readability
                LinearGradient(
                    colors: [.black.opacity(0.6), .clear],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: geo.safeAreaInsets.top + 30)
                .ignoresSafeArea()
            }
        }
        .ignoresSafeArea(edges: .top)
        .onReceive(timer) { _ in
            withAnimation(.easeInOut(duration: 1.0)) {
                currentImageIndex = (currentImageIndex + 1) % backgrounds.count
            }
        }
        .fullScreenCover(isPresented: $showProfile) {
            ProfileView()
        }
        .fullScreenCover(isPresented: $showSearch) {
            MenuSearchView()
        }
    }

    // MARK: - Photo Header (280pt)

    private func photoHeader(width: CGFloat) -> some View {
        ZStack {
            // Rotating backgrounds
            ForEach(0..<backgrounds.count, id: \.self) { index in
                Image(backgrounds[index])
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: width, height: 320)
                    .clipped()
                    .opacity(index == currentImageIndex ? 1 : 0)
            }

            // Bottom gradient for smooth blend into dark bg
            VStack {
                Spacer()
                LinearGradient(
                    colors: [.clear, Color.spDark],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 80)
            }

            // Logo overlay
            Image("layer")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 80)
        }
        .frame(height: 320)
    }

    // MARK: - Status Pill

    private var statusPill: some View {
        let status = info.currentStatus()
        return HStack(spacing: SP.spacing6) {
            Circle()
                .fill(status.isOpen ? Color.spGreen : Color.red.opacity(0.7))
                .frame(width: 6, height: 6)
            Text(status.isOpen ? "Открыто" : "Закрыто")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.spCream)
            Text("·")
                .foregroundColor(.spMuted)
            Text(status.isOpen ? "до \(status.closingTime)" : "с \(status.closingTime)")
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(.spGold)
        }
        .padding(.horizontal, SP.spacing16)
        .padding(.vertical, SP.spacing8)
        .background(Color.spCard)
        .clipShape(Capsule())
    }

    // MARK: - Navigation Icons

    private var navIcons: some View {
        VStack(spacing: 20) {
            // Row 1: Бар, Кухня
            HStack(spacing: 36) {
                navButton(icon: "wineglass", label: "Бар", tab: 1)
                navButton(icon: "fork.knife", label: "Кухня", tab: 2)
            }

            // Row 2: Профиль, Бронь, Поиск, О нас
            HStack(spacing: 28) {
                Button { showProfile = true } label: {
                    iconLabel(icon: "person.circle", label: "Профиль")
                }
                .sensoryFeedback(.selection, trigger: showProfile)

                Button {
                    UIApplication.shared.open(BarInfo.shared.phoneURL)
                } label: {
                    iconLabel(icon: "phone", label: "Бронь")
                }

                Button { showSearch = true } label: {
                    iconLabel(icon: "magnifyingglass", label: "Поиск")
                }
                .sensoryFeedback(.selection, trigger: showSearch)

                navButton(icon: "info.circle", label: "О нас", tab: 3)
            }
        }
    }

    private func iconLabel(icon: String, label: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .light))
                .frame(height: 22)
            Text(label)
                .font(.system(size: 10, weight: .regular))
                .tracking(1)
        }
        .foregroundColor(.spCream)
        .frame(width: 56)
    }

    private func navButton(icon: String, label: String, tab: Int) -> some View {
        Button {
            selectedTab = tab
        } label: {
            iconLabel(icon: icon, label: label)
        }
        .sensoryFeedback(.selection, trigger: selectedTab)
    }

    // MARK: - Events Carousel

    private var eventsCarousel: some View {
        VStack(spacing: SP.spacing8) {
            HStack(spacing: 0) {
                Button {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        currentEventIndex = (currentEventIndex - 1 + info.events.count) % info.events.count
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.spMuted)
                        .frame(width: 44, height: 60)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)

                ZStack {
                    ForEach(Array(info.events.enumerated()), id: \.element.id) { index, event in
                        if index == currentEventIndex {
                            VStack(spacing: SP.spacing6) {
                                Text(event.day.uppercased())
                                    .font(.spSmall)
                                    .tracking(1)
                                    .foregroundColor(.spGold)

                                Text(event.title)
                                    .font(.spBodyMedium)
                                    .foregroundColor(.spCream)

                                Text(event.description)
                                    .font(.spCaption)
                                    .foregroundColor(.spMuted)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.vertical, SP.spacing12)
                            .padding(.horizontal, SP.spacing8)
                            .transition(.opacity)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .gesture(
                    DragGesture(minimumDistance: 30)
                        .onEnded { value in
                            withAnimation(.easeInOut(duration: 0.3)) {
                                if value.translation.width < 0 {
                                    currentEventIndex = (currentEventIndex + 1) % info.events.count
                                } else {
                                    currentEventIndex = (currentEventIndex - 1 + info.events.count) % info.events.count
                                }
                            }
                        }
                )

                Button {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        currentEventIndex = (currentEventIndex + 1) % info.events.count
                    }
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.spMuted)
                        .frame(width: 44, height: 60)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, SP.spacing4)

            HStack(spacing: 6) {
                ForEach(0..<info.events.count, id: \.self) { index in
                    Circle()
                        .fill(index == currentEventIndex ? Color.spGold : Color.spMuted.opacity(0.4))
                        .frame(width: 5, height: 5)
                }
            }
        }
    }
}

#Preview {
    HomeView(selectedTab: .constant(0))
}
