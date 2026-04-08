import SwiftUI

// MARK: - Home Screen

struct HomeView: View {
    @Binding var selectedTab: Int
    @State private var currentImageIndex = 0
    @State private var currentEventIndex = 0
    private let backgrounds = ["main1", "main2", "main3"]
    private let timer = Timer.publish(every: 4, on: .main, in: .common).autoconnect()
    private let info = BarInfo.shared

    var body: some View {
        ZStack {
            backgroundLayer

            VStack {
                Spacer()
                navIcons
                eventsCarousel

                // Background page dots
                HStack(spacing: 6) {
                    ForEach(0..<backgrounds.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentImageIndex ? Color.white : Color.white.opacity(0.3))
                            .frame(width: 5, height: 5)
                    }
                }
                .padding(.bottom, SP.spacing16)
            }
        }
        .ignoresSafeArea()
        .onReceive(timer) { _ in
            withAnimation(.easeInOut(duration: 1.0)) {
                currentImageIndex = (currentImageIndex + 1) % backgrounds.count
            }
        }
    }

    // MARK: - Background

    private var backgroundLayer: some View {
        ZStack {
            ForEach(0..<backgrounds.count, id: \.self) { index in
                Image(backgrounds[index])
                    .resizable()
                    .aspectRatio(contentMode: .fill)
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

    // MARK: - Navigation Icons (compact)

    private var navIcons: some View {
        HStack(spacing: 36) {
            navButton(icon: "wineglass", label: "Бар", tab: 1)
            navButton(icon: "fork.knife", label: "Кухня", tab: 2)
            navButton(icon: "info.circle", label: "О нас", tab: 3)
        }
        .padding(.bottom, SP.spacing24)
    }

    private func navButton(icon: String, label: String, tab: Int) -> some View {
        Button {
            selectedTab = tab
        } label: {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .light))
                Text(label)
                    .font(.system(size: 10, weight: .regular))
                    .tracking(1)
            }
            .foregroundColor(.white)
        }
    }

    // MARK: - Events Carousel

    private var eventsCarousel: some View {
        VStack(spacing: SP.spacing8) {
            // Arrow left — card — arrow right
            HStack(spacing: 0) {
                Button {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        currentEventIndex = (currentEventIndex - 1 + info.events.count) % info.events.count
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .light))
                        .foregroundColor(.white.opacity(0.6))
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                }

                // Card
                ZStack {
                    ForEach(Array(info.events.enumerated()), id: \.element.id) { index, event in
                        if index == currentEventIndex {
                            eventCard(event: event)
                                .transition(.asymmetric(
                                    insertion: .move(edge: .trailing).combined(with: .opacity),
                                    removal: .move(edge: .leading).combined(with: .opacity)
                                ))
                        }
                    }
                }
                .frame(maxWidth: .infinity)

                Button {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        currentEventIndex = (currentEventIndex + 1) % info.events.count
                    }
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .light))
                        .foregroundColor(.white.opacity(0.6))
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                }
            }
            .padding(.horizontal, SP.spacing8)

            // Event dots
            HStack(spacing: 6) {
                ForEach(0..<info.events.count, id: \.self) { index in
                    Circle()
                        .fill(index == currentEventIndex ? Color.spGold : Color.white.opacity(0.25))
                        .frame(width: 5, height: 5)
                }
            }
        }
        .padding(.bottom, SP.spacing12)
    }

    private func eventCard(event: BarEvent) -> some View {
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
        .padding(.horizontal, SP.spacing16)
    }
}

#Preview {
    HomeView(selectedTab: .constant(0))
}
