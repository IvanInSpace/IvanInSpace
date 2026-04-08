import SwiftUI

// MARK: - Speaker Pub Color Palette
// Dark, warm pub aesthetic inspired by the website:
// dark wood panels, aged brick, warm amber lighting.

extension Color {
    // Primary dark background — deep wood/charcoal
    static let spDark = Color(red: 0.09, green: 0.08, blue: 0.07)              // #171413

    // Card background
    static let spCard = Color(red: 0.16, green: 0.14, blue: 0.13)              // #292321

    // Warm cream for primary text
    static let spCream = Color(red: 0.93, green: 0.90, blue: 0.85)             // #EDE6D9

    // Muted text (WCAG AA Large compliant on spDark)
    static let spMuted = Color(red: 0.659, green: 0.608, blue: 0.549)            // #A89B8C

    // Gold accent — amber warmth
    static let spGold = Color(red: 0.78, green: 0.65, blue: 0.42)              // #C7A66B

    // Green accent — subtle brand element
    static let spGreen = Color(red: 0.33, green: 0.47, blue: 0.36)             // #54785C

    // Divider/border
    static let spDivider = Color(red: 0.24, green: 0.21, blue: 0.19)           // #3D3630

}
