import SwiftUI

// MARK: - Speaker Pub Typography
// The menu uses a mix of elegant serif headers and clean body text.
// On iOS we use system serif (New York) for headers and system sans-serif (SF Pro) for body.

extension Font {
    // Display — large section headers
    static let spDisplay = Font.system(size: 32, weight: .bold, design: .serif)

    // Title — screen titles
    static let spTitle = Font.system(size: 26, weight: .bold, design: .serif)

    // Section header — category names
    static let spSectionHeader = Font.system(size: 20, weight: .semibold, design: .serif)

    // Subsection — subcategory names
    static let spSubsection = Font.system(size: 17, weight: .semibold, design: .serif)

    // Body — menu item names
    static let spBody = Font.system(size: 16, weight: .regular, design: .default)

    // Body bold — emphasized items
    static let spBodyBold = Font.system(size: 16, weight: .semibold, design: .default)

    // Caption — descriptions, volume info
    static let spCaption = Font.system(size: 13, weight: .regular, design: .default)

    // Price — price display
    static let spPrice = Font.system(size: 16, weight: .medium, design: .default)

    // Small — tags, badges
    static let spSmall = Font.system(size: 11, weight: .medium, design: .default)

    // Tab bar labels
    static let spTab = Font.system(size: 10, weight: .medium, design: .default)
}

// MARK: - Text Styles
struct SPText: ViewModifier {
    enum Style {
        case display, title, sectionHeader, subsection, body, bodyBold, caption, price, small
    }

    let style: Style
    let color: Color

    init(_ style: Style, color: Color = .spPrimaryText) {
        self.style = style
        self.color = color
    }

    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundColor(color)
    }

    private var font: Font {
        switch style {
        case .display: return .spDisplay
        case .title: return .spTitle
        case .sectionHeader: return .spSectionHeader
        case .subsection: return .spSubsection
        case .body: return .spBody
        case .bodyBold: return .spBodyBold
        case .caption: return .spCaption
        case .price: return .spPrice
        case .small: return .spSmall
        }
    }
}

extension View {
    func spTextStyle(_ style: SPText.Style, color: Color = .spPrimaryText) -> some View {
        modifier(SPText(style, color: color))
    }
}
