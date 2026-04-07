import SwiftUI

// MARK: - Speaker Pub Color Palette
// Derived from the bar's brand identity: classic British pub with Russian soul.
// Deep greens, warm cream, dark accents, gold details.

extension Color {
    // Primary brand green — used in decorative borders and accents on the menu
    static let speakerGreen = Color(red: 0.278, green: 0.427, blue: 0.325)       // #477053

    // Dark green for headers and emphasis
    static let speakerGreenDark = Color(red: 0.180, green: 0.310, blue: 0.220)    // #2E4F38

    // Cream/ivory background — the warm paper tone of the menu
    static let speakerCream = Color(red: 0.965, green: 0.953, blue: 0.929)         // #F7F3ED

    // Slightly warmer cream for cards
    static let speakerCreamLight = Color(red: 0.980, green: 0.973, blue: 0.957)    // #FAF8F4

    // Deep dark brown/charcoal — primary text color
    static let speakerDark = Color(red: 0.145, green: 0.129, blue: 0.118)          // #25211E

    // Gold accent for prices and highlights
    static let speakerGold = Color(red: 0.690, green: 0.580, blue: 0.380)          // #B09461

    // Muted text color
    static let speakerMuted = Color(red: 0.478, green: 0.447, blue: 0.412)         // #7A7269

    // Separator/border color
    static let speakerBorder = Color(red: 0.835, green: 0.812, blue: 0.776)        // #D5CFC6

    // Warm white for surfaces
    static let speakerSurface = Color.white
}

// MARK: - Semantic Colors
extension Color {
    static let spBackground = Color.speakerCream
    static let spCardBackground = Color.speakerCreamLight
    static let spPrimaryText = Color.speakerDark
    static let spSecondaryText = Color.speakerMuted
    static let spAccent = Color.speakerGreen
    static let spAccentDark = Color.speakerGreenDark
    static let spPrice = Color.speakerGold
    static let spDivider = Color.speakerBorder
}
