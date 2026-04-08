import SwiftUI

// MARK: - Home Screen

struct HomeView: View {
    @Binding var selectedTab: Int
    @State private var currentImageIndex = 0
    @State private var currentEventIndex = 0
    @State private var showProfile = false
    @State private var colonVisible = true
    private let backgrounds = ["main1", "main2", "main3"]
    private let timer = Timer.publish(every: 4, on: .main, in: .common).autoconnect()
    private let blinkTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private let info = BarInfo.shared

    var body: some View {
        GeometryReader { geo in
            ZStack {
                backgroundLayer(size: geo.size)

                // Top center: working hours
                VStack {
                    workingHoursBar
                        .padding(.top, geo.safeAreaInsets.top + geo.size.height * 0.12)
                    Spacer()
                }

                VStack(spacing: 0) {
                    Spacer()
                    navIcons
                    eventsCarousel
                        .padding(.bottom, SP.spacing32)
                }
            }
        }
        .ignoresSafeArea()
        .onReceive(timer) { _ in
            withAnimation(.easeInOut(duration: 1.0)) {
                currentImageIndex = (currentImageIndex + 1) % backgrounds.count
            }
        }
        .onReceive(blinkTimer) { _ in
            colonVisible.toggle()
        }
        .fullScreenCover(isPresented: $showProfile) {
            ProfileView()
        }
    }

    // MARK: - Background

    private func backgroundLayer(size: CGSize) -> some View {
        ZStack {
            ForEach(0..<backgrounds.count, id: \.self) { index in
                Image(backgrounds[index])
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                    .clipped()
                    .opacity(index == currentImageIndex ? 1 : 0)
            }

            LinearGradient(
                stops: [
                    .init(color: .clear, location: 0.0),
                    .init(color: .black.opacity(0.4), location: 0.5),
                    .init(color: .black.opacity(0.9), location: 1.0)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }

    // MARK: - Working Hours Bar

    private var workingHoursBar: some View {
        let status = info.currentStatus()
        let time = status.isOpen ? status.closingTime : status.closingTime
        let parts = time.split(separator: ":")
        let hours = parts.count > 0 ? String(parts[0]) : "00"
        let minutes = parts.count > 1 ? String(parts[1]) : "00"

        return HStack(spacing: 0) {
            Text(status.isOpen ? "сегодня работаем до " : "откроемся в ")
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(.white.opacity(0.7))
            Text(hours)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.white.opacity(0.9))
            Text(":")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.white.opacity(colonVisible ? 0.9 : 0.0))
            Text(minutes)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.white.opacity(0.9))
        }
        .padding(.horizontal, SP.spacing16)
        .padding(.vertical, SP.spacing6)
        .background(Color.black.opacity(0.35))
        .background(.ultraThinMaterial.opacity(0.4))
        .clipShape(Capsule())
    }

    // MARK: - Navigation Icons (two rows)

    private var navIcons: some View {
        VStack(spacing: 20) {
            // Row 1: Бар, Кухня
            HStack(spacing: 36) {
                navButton(icon: "wineglass", label: "Бар", tab: 1)
                navButton(icon: "fork.knife", label: "Кухня", tab: 2)
            }

            // Row 2: Профиль, Бронь, О нас
            HStack(spacing: 36) {
                Button {
                    showProfile = true
                } label: {
                    iconLabel(icon: "person.circle", label: "Профиль")
                }

                Button {
                    UIApplication.shared.open(BarInfo.shared.phoneURL)
                } label: {
                    iconLabel(icon: "phone", label: "Бронь")
                }

                navButton(icon: "info.circle", label: "О нас", tab: 3)
            }
        }
        .padding(.bottom, SP.spacing24)
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
        .foregroundColor(.white)
        .frame(width: 60)
    }

    private func navButton(icon: String, label: String, tab: Int) -> some View {
        Button {
            selectedTab = tab
        } label: {
            iconLabel(icon: icon, label: label)
        }
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
                        .foregroundColor(.white.opacity(0.6))
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
                                    .foregroundColor(.white)

                                Text(event.description)
                                    .font(.spCaption)
                                    .foregroundColor(.white.opacity(0.6))
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
                        .foregroundColor(.white.opacity(0.6))
                        .frame(width: 44, height: 60)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, SP.spacing4)

            HStack(spacing: 6) {
                ForEach(0..<info.events.count, id: \.self) { index in
                    Circle()
                        .fill(index == currentEventIndex ? Color.spGold : Color.white.opacity(0.25))
                        .frame(width: 5, height: 5)
                }
            }
        }
    }
}

#Preview {
    HomeView(selectedTab: .constant(0))
}
