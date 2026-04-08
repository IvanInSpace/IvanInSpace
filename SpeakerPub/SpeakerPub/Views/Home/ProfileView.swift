import SwiftUI

// MARK: - Profile View (Coming Soon)

struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Background image
                Image("profile_bg")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()

                Color.black.opacity(0.65)

                VStack(spacing: SP.spacing24) {
                    Spacer()

                    Image(systemName: "person.circle")
                        .font(.system(size: 56, weight: .ultraLight))
                        .foregroundColor(.spMuted)

                    Text("Профиль")
                        .font(.spTitle)
                        .foregroundColor(.spCream)

                    Text("Скоро здесь появится личный кабинет\nс персональной скидочной картой")
                        .font(.spBody)
                        .foregroundColor(.spMuted)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, SP.spacing40)

                    Spacer()
                }

                // Close button — top right, below safe area
                VStack {
                    HStack {
                        Spacer()
                        VStack(spacing: 4) {
                            CloseButton {
                                dismiss()
                            }
                            Text("выйти")
                                .font(.system(size: 9, weight: .regular))
                                .foregroundColor(.white.opacity(0.5))
                        }
                        .padding(.trailing, SP.spacing16)
                    }
                    .padding(.top, geo.safeAreaInsets.top + 20)
                    Spacer()
                }
            }
        }
        .ignoresSafeArea()
    }
}

// MARK: - Reusable Close Button (thin X, not system style)

struct CloseButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.15))
                    .frame(width: 32, height: 32)

                // Thin custom X
                Image(systemName: "xmark")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
            }
        }
    }
}

#Preview {
    ProfileView()
}
