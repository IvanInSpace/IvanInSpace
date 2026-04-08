import SwiftUI

// MARK: - Profile View (Coming Soon)

struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.spDark.ignoresSafeArea()

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

            // Close button
            VStack {
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.spCream)
                            .frame(width: 36, height: 36)
                            .background(Color.spCard)
                            .clipShape(Circle())
                    }
                    .padding(.trailing, SP.spacing16)
                    .padding(.top, SP.spacing16)
                }
                Spacer()
            }
        }
    }
}

#Preview {
    ProfileView()
}
