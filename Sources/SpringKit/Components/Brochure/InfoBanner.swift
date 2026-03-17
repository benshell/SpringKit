import SwiftUI

/// A full-width contextual banner for announcements, seasonal messaging,
/// or promotional copy.
///
/// ```swift
/// InfoBanner(
///     style: .seasonal,
///     icon: Image(systemName: "leaf.fill"),
///     message: "Spring bookings now open for garden ceremonies.",
///     actionLabel: "Reserve Now"
/// ) {
///     // navigate to booking
/// }
/// ```
public struct InfoBanner: View {

    // MARK: - Style

    public enum Style {
        /// Forest green — general information or brand announcements.
        case info
        /// Harvest orange — time-sensitive promotions.
        case seasonal
        /// Champagne gold — premium or exclusive offers.
        case premium
        /// Destructive red — important warnings.
        case warning
    }

    // MARK: - Properties

    private let style: Style
    private let icon: Image?
    private let message: String
    private let actionLabel: String?
    private let action: (() -> Void)?

    // MARK: - Init

    public init(
        style: Style = .info,
        icon: Image? = nil,
        message: String,
        actionLabel: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.style = style
        self.icon = icon
        self.message = message
        self.actionLabel = actionLabel
        self.action = action
    }

    // MARK: - Body

    public var body: some View {
        HStack(spacing: SpringSpacing.Horizontal.sm) {
            if let icon {
                icon
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(style.iconColor)
                    .accessibilityHidden(true)
            }

            Text(message)
                .font(SpringFont.prose(size: SpringFontSize.footnote, weight: .medium))
                .foregroundStyle(style.textColor)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)

            if let label = actionLabel, let action {
                Button(label, action: action)
                    .font(SpringFont.prose(size: SpringFontSize.footnote, weight: .semibold))
                    .foregroundStyle(style.textColor)
                    .underline()
                    .accessibilityHint("Activates: \(label)")
            }
        }
        .padding(.horizontal, SpringSpacing.Horizontal.md)
        .padding(.vertical, SpringSpacing.Vertical.sm)
        .background(style.backgroundColor)
        .accessibilityElement(children: .combine)
        .accessibilityLabel([message, actionLabel].compactMap { $0 }.joined(separator: ". "))
    }
}

// MARK: - Style Properties

private extension InfoBanner.Style {
    var backgroundColor: Color {
        switch self {
        case .info:     SpringColor.Background.secondary
        case .seasonal: SpringColor.Background.accent
        case .premium:  SpringColor.Object.champagne.opacity(0.15)
        case .warning:  SpringColor.Object.destructive.opacity(0.12)
        }
    }

    var textColor: Color {
        switch self {
        case .info:     SpringColor.Text.primary
        case .seasonal: SpringColor.Text.primary
        case .premium:  SpringColor.Text.primary
        case .warning:  SpringColor.Object.destructive
        }
    }

    var iconColor: Color {
        switch self {
        case .info:     SpringColor.Object.secondary
        case .seasonal: SpringColor.Object.accent
        case .premium:  SpringColor.Object.champagne
        case .warning:  SpringColor.Object.destructive
        }
    }
}

// MARK: - Preview

#Preview("InfoBanner") {
    VStack(spacing: 0) {
        InfoBanner(
            style: .seasonal,
            icon: Image(systemName: "leaf.fill"),
            message: "Spring bookings are now open for garden ceremonies.",
            actionLabel: "Reserve Now"
        ) { }

        InfoBanner(
            style: .premium,
            icon: Image(systemName: "star.fill"),
            message: "Members receive complimentary tastings on every visit."
        )

        InfoBanner(
            style: .info,
            icon: Image(systemName: "info.circle.fill"),
            message: "The estate will be closed on 25 December."
        )

        InfoBanner(
            style: .warning,
            icon: Image(systemName: "exclamationmark.triangle.fill"),
            message: "Outdoor dining may be affected by weather. Please contact us before visiting."
        )
    }
    .background(SpringColor.Background.primary)
}
