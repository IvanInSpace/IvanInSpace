import SwiftUI

// MARK: - Speaker Pub Typography
// Clean, minimal. System sans-serif (SF Pro) throughout for modern feel.
// Serif only for the brand name display.

extension Font {
    // Brand display — large hero text
    static let spDisplay = Font.system(size: 34, weight: .light, design: .serif)

    // Screen titles
    static let spTitle = Font.system(size: 24, weight: .light, design: .default)

    // Section headers
    static let spSection = Font.system(size: 18, weight: .medium, design: .default)

    // Subsection
    static let spSubsection = Font.system(size: 15, weight: .semibold, design: .default)

    // Body
    static let spBody = Font.system(size: 15, weight: .regular, design: .default)

    // Body emphasis
    static let spBodyMedium = Font.system(size: 15, weight: .medium, design: .default)

    // Caption
    static let spCaption = Font.system(size: 13, weight: .regular, design: .default)

    // Small labels / tags
    static let spSmall = Font.system(size: 11, weight: .medium, design: .default)

    // Price
    static let spPrice = Font.system(size: 15, weight: .regular, design: .default)

    // Large hero overlay text
    static let spHero = Font.system(size: 28, weight: .light, design: .default)

    // Tracking helper for brand text
    static let spBrandSmall = Font.system(size: 11, weight: .regular, design: .default)
}
