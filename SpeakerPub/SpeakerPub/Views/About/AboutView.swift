import SwiftUI
import MapKit

// MARK: - About View

struct AboutView: View {
    private let info = BarInfo.shared
    @State private var expandedPhoto: Int? = nil
    @Namespace private var photoNamespace

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
                    .padding(.bottom, 80)
                }
                .background(Color.spDark)

                // Expanded photo overlay
                if let index = expandedPhoto {
                    expandedPhotoOverlay(index: index)
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

    // MARK: - Atmosphere Mosaic Grid

    private var atmosphereGrid: some View {
        VStack(alignment: .leading, spacing: SP.spacing12) {
            Text("АТМОСФЕРА")
                .font(.spBrandSmall)
                .tracking(3)
                .foregroundColor(.spGold)
                .padding(.horizontal, SP.horizontalPadding)

            // Mosaic: 2 columns, varying heights
            let spacing: CGFloat = 4
            let columns = [
                GridItem(.flexible(), spacing: spacing),
                GridItem(.flexible(), spacing: spacing)
            ]

            LazyVGrid(columns: columns, spacing: spacing) {
                ForEach(1...5, id: \.self) { index in
                    if expandedPhoto != index {
                        Image("atmo\(index)")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: index == 1 || index == 4 ? 140 : 100)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                            .matchedGeometryEffect(id: "photo_\(index)", in: photoNamespace)
                            .onTapGesture {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                                    expandedPhoto = index
                                }
                            }
                    } else {
                        // Placeholder to keep grid layout
                        Color.clear
                            .frame(height: index == 1 || index == 4 ? 140 : 100)
                    }
                }
            }
            .padding(.horizontal, SP.horizontalPadding)
        }
    }

    // MARK: - Expanded Photo Overlay

    private func expandedPhotoOverlay(index: Int) -> some View {
        ZStack {
            Color.black.opacity(0.85)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                        expandedPhoto = nil
                    }
                }

            Image("atmo\(index)")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: UIScreen.main.bounds.width * 0.8,
                       maxHeight: UIScreen.main.bounds.height * 0.8)
                .clipShape(RoundedRectangle(cornerRadius: SP.radiusSmall))
                .matchedGeometryEffect(id: "photo_\(index)", in: photoNamespace)
                .onTapGesture {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
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
                contactRow(icon: "mappin", title: info.address)
                separator
                contactRow(icon: "tram.fill", title: "м. \(info.metro)")
                separator

                Button {
                    UIApplication.shared.open(info.phoneURL)
                } label: {
                    contactRow(icon: "phone", title: info.phone, isLink: true)
                }
                .buttonStyle(.plain)

                separator

                Button {
                    UIApplication.shared.open(info.telegram)
                } label: {
                    contactRow(icon: "paperplane", title: info.telegramHandle, isLink: true)
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
            .allowsHitTesting(false)

            Button {
                let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: info.coordinate))
                mapItem.name = info.name
                mapItem.openInMaps()
            } label: {
                HStack(spacing: SP.spacing8) {
                    Image(systemName: "arrow.triangle.turn.up.right.diamond")
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
        }
        .padding(.horizontal, SP.horizontalPadding)
    }
}

#Preview {
    AboutView()
}
