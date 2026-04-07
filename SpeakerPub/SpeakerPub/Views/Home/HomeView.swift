import SwiftUI

// MARK: - Home Screen

struct HomeView: View {
    @State private var currentImageIndex = 0
    private let backgrounds = ["main1", "main2", "main3"]
    private let timer = Timer.publish(every: 4, on: .main, in: .common).autoconnect()
    private let info = BarInfo.shared

    var body: some View {
        ZStack {
            // Rotating background
            backgroundLayer

            // Content overlay
            VStack {
                Spacer()
                eventsSection
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

            // Gradient overlay: dark at bottom for readability
            LinearGradient(
                stops: [
                    .init(color: .clear, location: 0.0),
                    .init(color: .black.opacity(0.3), location: 0.4),
                    .init(color: .black.opacity(0.85), location: 1.0)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }

    // MARK: - Events

    private var eventsSection: some View {
        VStack(alignment: .leading, spacing: SP.spacing16) {
            Text("СОБЫТИЯ")
                .font(.spBrandSmall)
                .tracking(3)
                .foregroundColor(.spMuted)
                .padding(.horizontal, SP.horizontalPadding)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: SP.spacing12) {
                    ForEach(info.events) { event in
                        EventCard(event: event)
                    }
                }
                .padding(.horizontal, SP.horizontalPadding)
            }

            // Page dots for background
            HStack(spacing: 6) {
                ForEach(0..<backgrounds.count, id: \.self) { index in
                    Circle()
                        .fill(index == currentImageIndex ? Color.spCream : Color.spMuted.opacity(0.4))
                        .frame(width: 6, height: 6)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, SP.spacing8)
        }
        .padding(.bottom, SP.spacing24)
    }
}

// MARK: - Event Card (Minimal)

struct EventCard: View {
    let event: BarEvent

    var body: some View {
        VStack(alignment: .leading, spacing: SP.spacing8) {
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
        }
        .frame(width: 200, alignment: .leading)
        .padding(SP.spacing16)
        .background(Color.spCard.opacity(0.85))
        .clipShape(RoundedRectangle(cornerRadius: SP.radiusSmall))
        .overlay(
            RoundedRectangle(cornerRadius: SP.radiusSmall)
                .stroke(Color.spDivider, lineWidth: 0.5)
        )
    }
}

#Preview {
    HomeView()
}
