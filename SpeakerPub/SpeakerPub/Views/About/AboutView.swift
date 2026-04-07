import SwiftUI
import MapKit

// MARK: - About View

struct AboutView: View {
    private let info = BarInfo.shared

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: SP.spacing24) {
                    headerSection
                    aboutSection
                    eventsSection
                    featuresSection
                    hoursSection
                    contactSection
                    mapSection
                }
                .padding(.bottom, SP.spacing40)
            }
            .background(Color.spBackground)
            .navigationTitle("О нас")
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(spacing: SP.spacing12) {
            Spacer().frame(height: SP.spacing8)

            // Ornamental header matching the brand
            HStack(spacing: SP.spacing8) {
                ornamentLine
                Image(systemName: "star.fill")
                    .font(.system(size: 8))
                    .foregroundColor(.spAccent)
                ornamentLine
            }
            .padding(.horizontal, SP.spacing40)

            Text("THE SPEAKER PUB")
                .font(.system(size: 12, weight: .medium))
                .tracking(5)
                .foregroundColor(.spSecondaryText)

            Text("Speaker Pub")
                .font(.system(size: 34, weight: .bold, design: .serif))
                .foregroundColor(.spAccentDark)

            HStack(spacing: SP.spacing8) {
                ornamentLine
                Image(systemName: "star.fill")
                    .font(.system(size: 8))
                    .foregroundColor(.spAccent)
                ornamentLine
            }
            .padding(.horizontal, SP.spacing40)
        }
        .padding(.vertical, SP.spacing16)
    }

    private var ornamentLine: some View {
        Rectangle()
            .fill(Color.spDivider)
            .frame(height: 1)
    }

    // MARK: - About

    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: SP.spacing12) {
            Text("О заведении")
                .font(.spSectionHeader)
                .foregroundColor(.spPrimaryText)

            Text(info.aboutText)
                .font(.spBody)
                .foregroundColor(.spSecondaryText)
                .lineSpacing(4)
        }
        .padding(.horizontal, SP.horizontalPadding)
    }

    // MARK: - Events

    private var eventsSection: some View {
        VStack(alignment: .leading, spacing: SP.spacing12) {
            Text("События")
                .font(.spSectionHeader)
                .foregroundColor(.spPrimaryText)
                .padding(.horizontal, SP.horizontalPadding)

            VStack(spacing: 0) {
                ForEach(Array(info.events.enumerated()), id: \.element.id) { index, event in
                    HStack(spacing: SP.spacing12) {
                        Image(systemName: event.icon)
                            .font(.system(size: 24))
                            .foregroundColor(.spAccent)
                            .frame(width: 32)

                        VStack(alignment: .leading, spacing: SP.spacing4) {
                            Text(event.title)
                                .font(.spBodyBold)
                                .foregroundColor(.spPrimaryText)
                            Text(event.day)
                                .font(.spSmall)
                                .foregroundColor(.spAccent)
                            Text(event.description)
                                .font(.spCaption)
                                .foregroundColor(.spSecondaryText)
                        }
                    }
                    .padding(.vertical, SP.spacing12)
                    .padding(.horizontal, SP.spacing16)

                    if index < info.events.count - 1 {
                        Divider().padding(.leading, 56)
                    }
                }
            }
            .background(Color.spCardBackground)
            .clipShape(RoundedRectangle(cornerRadius: SP.cardRadius))
            .padding(.horizontal, SP.horizontalPadding)
        }
    }

    // MARK: - Features

    private var featuresSection: some View {
        VStack(alignment: .leading, spacing: SP.spacing12) {
            Text("Особенности")
                .font(.spSectionHeader)
                .foregroundColor(.spPrimaryText)
                .padding(.horizontal, SP.horizontalPadding)

            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: SP.spacing12),
                GridItem(.flexible(), spacing: SP.spacing12)
            ], spacing: SP.spacing12) {
                ForEach(info.features, id: \.self) { feature in
                    HStack(spacing: SP.spacing8) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.spAccent)
                        Text(feature)
                            .font(.spCaption)
                            .foregroundColor(.spPrimaryText)
                        Spacer()
                    }
                    .padding(.vertical, SP.spacing8)
                    .padding(.horizontal, SP.spacing12)
                    .background(Color.spCardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: SP.radiusSmall))
                }
            }
            .padding(.horizontal, SP.horizontalPadding)
        }
    }

    // MARK: - Hours

    private var hoursSection: some View {
        VStack(alignment: .leading, spacing: SP.spacing12) {
            Text("Часы работы")
                .font(.spSectionHeader)
                .foregroundColor(.spPrimaryText)

            VStack(spacing: 0) {
                ForEach(Array(info.workingHours.enumerated()), id: \.offset) { index, schedule in
                    HStack {
                        Text(schedule.day)
                            .font(.spBody)
                            .foregroundColor(.spPrimaryText)
                        Spacer()
                        Text(schedule.hours)
                            .font(.spBody)
                            .foregroundColor(.spSecondaryText)
                    }
                    .padding(.vertical, SP.spacing12)
                    .padding(.horizontal, SP.spacing16)

                    if index < info.workingHours.count - 1 {
                        Divider()
                            .padding(.leading, SP.spacing16)
                    }
                }
            }
            .background(Color.spCardBackground)
            .clipShape(RoundedRectangle(cornerRadius: SP.cardRadius))
        }
        .padding(.horizontal, SP.horizontalPadding)
    }

    // MARK: - Contact

    private var contactSection: some View {
        VStack(alignment: .leading, spacing: SP.spacing12) {
            Text("Контакты")
                .font(.spSectionHeader)
                .foregroundColor(.spPrimaryText)

            VStack(spacing: 0) {
                // Address
                contactRow(icon: "mappin.circle.fill", title: "Адрес", value: info.address)

                Divider().padding(.leading, 56)

                // Metro
                contactRow(icon: "tram.fill", title: "Метро", value: info.metro)

                Divider().padding(.leading, 56)

                // Phone
                Button {
                    UIApplication.shared.open(info.phoneURL)
                } label: {
                    contactRow(icon: "phone.circle.fill", title: "Телефон", value: info.phone, isLink: true)
                }
                .buttonStyle(.plain)

                Divider().padding(.leading, 56)

                // Telegram
                Button {
                    UIApplication.shared.open(info.telegram)
                } label: {
                    contactRow(icon: "paperplane.circle.fill", title: "Telegram", value: info.telegramHandle, isLink: true)
                }
                .buttonStyle(.plain)

                Divider().padding(.leading, 56)

                // Website
                Button {
                    UIApplication.shared.open(info.website)
                } label: {
                    contactRow(icon: "globe", title: "Сайт", value: "speakerpub.ru", isLink: true)
                }
                .buttonStyle(.plain)
            }
            .background(Color.spCardBackground)
            .clipShape(RoundedRectangle(cornerRadius: SP.cardRadius))
        }
        .padding(.horizontal, SP.horizontalPadding)
    }

    private func contactRow(icon: String, title: String, value: String, isLink: Bool = false) -> some View {
        HStack(spacing: SP.spacing12) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.spAccent)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: SP.spacing2) {
                Text(title)
                    .font(.spCaption)
                    .foregroundColor(.spSecondaryText)
                Text(value)
                    .font(.spBody)
                    .foregroundColor(isLink ? .spAccent : .spPrimaryText)
            }

            Spacer()

            if isLink {
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.spDivider)
            }
        }
        .padding(.vertical, SP.spacing12)
        .padding(.horizontal, SP.spacing16)
        .contentShape(Rectangle())
    }

    // MARK: - Map

    private var mapSection: some View {
        VStack(alignment: .leading, spacing: SP.spacing12) {
            Text("Как нас найти")
                .font(.spSectionHeader)
                .foregroundColor(.spPrimaryText)
                .padding(.horizontal, SP.horizontalPadding)

            Map(initialPosition: .region(MKCoordinateRegion(
                center: info.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            ))) {
                Marker(info.name, coordinate: info.coordinate)
                    .tint(Color.speakerGreen)
            }
            .frame(height: 200)
            .clipShape(RoundedRectangle(cornerRadius: SP.cardRadius))
            .padding(.horizontal, SP.horizontalPadding)
            .allowsHitTesting(false)

            // Open in Maps button
            Button {
                let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: info.coordinate))
                mapItem.name = info.name
                mapItem.openInMaps()
            } label: {
                HStack {
                    Image(systemName: "map.fill")
                    Text("Открыть в Картах")
                }
                .font(.spBodyBold)
                .foregroundColor(.spAccent)
                .frame(maxWidth: .infinity)
                .padding(.vertical, SP.spacing12)
                .background(Color.spAccent.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: SP.radiusSmall))
            }
            .padding(.horizontal, SP.horizontalPadding)
        }
    }
}

#Preview {
    AboutView()
}
