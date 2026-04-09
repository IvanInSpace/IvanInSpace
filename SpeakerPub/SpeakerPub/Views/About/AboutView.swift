import SwiftUI
import MapKit

// MARK: - About View

struct AboutView: View {
    private let info = BarInfo.shared
    private let photoCount = 12
    @State private var expandedPhoto: Int? = nil
    @State private var copiedField: String? = nil

    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(spacing: SP.spacing32) {
                        logoSection
                        aboutSection
                        atmosphereGrid
                        contactsSection
                        mapSection
                    }
                    .padding(.bottom, 90)
                }
                .background(Color.spDark)

                // Expanded photo overlay with swipe
                if expandedPhoto != nil {
                    expandedPhotoOverlay
                }
            }
            .navigationTitle("О нас")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }

    // MARK: - Logo

    private var logoSection: some View {
        Image("layer")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 60)
            .padding(.top, SP.spacing16)
    }

    // MARK: - About

    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: SP.spacing16) {
            Text("О ЗАВЕДЕНИИ")
                .font(.spBrandSmall)
                .tracking(3)
                .foregroundColor(.spGold)

            Text(info.aboutText)
                .font(.spBody)
                .foregroundColor(.spCream.opacity(0.85))
                .lineSpacing(6)
        }
        .padding(.horizontal, SP.horizontalPadding)
    }

    // MARK: - Atmosphere Grid (12 photos, 3 per row)

    private var atmosphereGrid: some View {
        VStack(alignment: .leading, spacing: SP.spacing12) {
            Text("АТМОСФЕРА")
                .font(.spBrandSmall)
                .tracking(3)
                .foregroundColor(.spGold)
                .padding(.horizontal, SP.horizontalPadding)

            let spacing: CGFloat = 3
            let columns = [
                GridItem(.flexible(), spacing: spacing),
                GridItem(.flexible(), spacing: spacing),
                GridItem(.flexible(), spacing: spacing)
            ]

            LazyVGrid(columns: columns, spacing: spacing) {
                ForEach(1...photoCount, id: \.self) { index in
                    Color.clear
                        .aspectRatio(1, contentMode: .fit)
                        .overlay(
                            Image("atmo\(index)")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        )
                        .clipped()
                        .clipShape(Rectangle())
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                expandedPhoto = index
                            }
                        }
                }
            }
            .padding(.horizontal, SP.horizontalPadding)
        }
    }

    // MARK: - Expanded Photo Overlay (swipeable)

    private var expandedPhotoOverlay: some View {
        GeometryReader { geo in
            ZStack {
                Color.black.opacity(0.9)
                    .ignoresSafeArea()

                if let current = expandedPhoto {
                    Image("atmo\(current)")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: geo.size.width * 0.9,
                               maxHeight: geo.size.height * 0.75)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .id(current)
                        .transition(.opacity)
                        .gesture(
                            DragGesture(minimumDistance: 40)
                                .onEnded { value in
                                    withAnimation(.easeInOut(duration: 0.25)) {
                                        if value.translation.width < 0 {
                                            expandedPhoto = current % photoCount + 1
                                        } else {
                                            expandedPhoto = (current - 2 + photoCount) % photoCount + 1
                                        }
                                    }
                                }
                        )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.25)) {
                    expandedPhoto = nil
                }
            }
        }
    }

    // MARK: - Contacts (with hours)

    private var contactsSection: some View {
        VStack(alignment: .leading, spacing: SP.spacing16) {
            Text("КОНТАКТЫ")
                .font(.spBrandSmall)
                .tracking(3)
                .foregroundColor(.spGold)

            VStack(spacing: 0) {
                copyableContactRow(icon: "mappin", title: info.address, copyText: info.address)
                separator
                contactRow(icon: "tram.fill", title: "м. \(info.metro)")
                separator

                Button {
                    UIApplication.shared.open(info.phoneURL)
                } label: {
                    copyableContactRow(icon: "phone", title: info.phone, copyText: info.phone, isLink: true)
                }
                .buttonStyle(.plain)

                separator

                Button {
                    UIApplication.shared.open(info.telegram)
                } label: {
                    copyableContactRow(icon: "paperplane", title: info.telegramHandle, copyText: info.telegramHandle, isLink: true)
                }
                .buttonStyle(.plain)

                separator

                ForEach(Array(info.workingHours.enumerated()), id: \.offset) { index, schedule in
                    HStack(spacing: SP.spacing12) {
                        Image(systemName: "clock")
                            .font(.system(size: 14))
                            .foregroundColor(index == 0 ? .spMuted : .clear)
                            .frame(width: 20)

                        Text(schedule.day)
                            .font(.spBody)
                            .foregroundColor(.spCream)
                            .frame(width: 60, alignment: .leading)

                        Spacer()

                        Text(schedule.hours)
                            .font(.spBody)
                            .foregroundColor(.spMuted)
                    }
                    .padding(.vertical, SP.spacing8)
                    .padding(.horizontal, SP.spacing16)
                }
            }
            .background(Color.spCard)
            .clipShape(RoundedRectangle(cornerRadius: SP.radiusSmall))
        }
        .padding(.horizontal, SP.horizontalPadding)
    }

    private var separator: some View {
        Divider()
            .background(Color.spDivider)
            .padding(.leading, 52)
    }

    private func contactRow(icon: String, title: String, isLink: Bool = false) -> some View {
        HStack(spacing: SP.spacing12) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(.spMuted)
                .frame(width: 20)

            Text(title)
                .font(.spBody)
                .foregroundColor(isLink ? .spGold : .spCream)

            Spacer()
        }
        .padding(.vertical, SP.spacing12)
        .padding(.horizontal, SP.spacing16)
        .contentShape(Rectangle())
    }

    private func copyableContactRow(icon: String, title: String, copyText: String, isLink: Bool = false) -> some View {
        HStack(spacing: SP.spacing12) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(.spMuted)
                .frame(width: 20)

            Text(title)
                .font(.spBody)
                .foregroundColor(isLink ? .spGold : .spCream)

            Spacer()

            Button {
                UIPasteboard.general.string = copyText
                withAnimation { copiedField = copyText }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation { copiedField = nil }
                }
            } label: {
                Image(systemName: copiedField == copyText ? "checkmark" : "doc.on.doc")
                    .font(.system(size: 12))
                    .foregroundColor(copiedField == copyText ? .spGreen : .spMuted)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, SP.spacing12)
        .padding(.horizontal, SP.spacing16)
        .contentShape(Rectangle())
    }

    // MARK: - Map

    private var mapSection: some View {
        VStack(alignment: .leading, spacing: SP.spacing12) {
            Map(initialPosition: .region(MKCoordinateRegion(
                center: info.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            ))) {
                Marker(info.name, coordinate: info.coordinate)
                    .tint(Color.spGreen)
            }
            .frame(height: 200)
            .clipShape(RoundedRectangle(cornerRadius: SP.radiusSmall))

            // Построить маршрут — Яндекс.Карты
            Button {
                let appURL = info.yandexMapsURL
                if UIApplication.shared.canOpenURL(appURL) {
                    UIApplication.shared.open(appURL)
                } else {
                    UIApplication.shared.open(info.yandexMapsWebURL)
                }
            } label: {
                HStack(spacing: SP.spacing8) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 13))
                    Text("Построить маршрут")
                        .font(.spBodyMedium)
                }
                .foregroundColor(.spGold)
                .frame(maxWidth: .infinity)
                .padding(.vertical, SP.spacing12)
                .background(Color.spCard)
                .clipShape(RoundedRectangle(cornerRadius: SP.radiusSmall))
            }

            Button {
                UIApplication.shared.open(info.phoneURL)
            } label: {
                HStack(spacing: SP.spacing8) {
                    Image(systemName: "phone.fill")
                        .font(.system(size: 13))
                    Text("Забронировать переговорную")
                        .font(.spBodyMedium)
                }
                .foregroundColor(.spGold)
                .frame(maxWidth: .infinity)
                .padding(.vertical, SP.spacing12)
                .background(Color.spCard)
                .clipShape(RoundedRectangle(cornerRadius: SP.radiusSmall))
            }
        }
        .padding(.horizontal, SP.horizontalPadding)
    }
}

#Preview {
    AboutView()
}
