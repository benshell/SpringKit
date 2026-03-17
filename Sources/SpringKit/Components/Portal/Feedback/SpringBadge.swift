import SwiftUI

/// A status pill or dot indicator for conveying state at a glance.
///
/// ```swift
/// SpringBadge("Confirmed", style: .success)
/// SpringBadge("Pending", style: .warning)
/// SpringBadge(style: .success)  // dot-only variant
/// ```
public struct SpringBadge: View {

    // MARK: - Style

    public enum Style {
        case success
        case warning
        case destructive
        case neutral
        case accent
    }

    // MARK: - Variant

    public enum Variant {
        /// Pill with label text.
        case pill
        /// Small filled circle, no text.
        case dot
    }

    // MARK: - Properties

    private let label: String?
    private let style: Style
    private let variant: Variant

    // MARK: - Init

    /// Pill badge with a text label.
    public init(_ label: String, style: Style = .neutral) {
        self.label = label
        self.style = style
        self.variant = .pill
    }

    /// Dot-only badge (no label).
    public init(style: Style) {
        self.label = nil
        self.style = style
        self.variant = .dot
    }

    // MARK: - Body

    public var body: some View {
        switch variant {
        case .pill:
            HStack(spacing: 4) {
                Circle()
                    .fill(style.foregroundColor)
                    .frame(width: 6, height: 6)

                if let label {
                    Text(label)
                        .font(SpringFont.prose(size: SpringFontSize.caption, weight: .semibold))
                        .foregroundStyle(style.foregroundColor)
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(style.backgroundColor)
            .clipShape(.capsule)
            .accessibilityLabel(label ?? "")
            .accessibilityAddTraits(.isStaticText)

        case .dot:
            Circle()
                .fill(style.foregroundColor)
                .frame(width: 8, height: 8)
                .accessibilityLabel(style.accessibilityDescription)
                .accessibilityAddTraits(.isStaticText)
        }
    }
}

// MARK: - Style Properties

extension SpringBadge.Style {
    var foregroundColor: Color {
        switch self {
        case .success:     SpringColor.Object.secondary
        case .warning:     SpringColor.Object.accent
        case .destructive: SpringColor.Object.destructive
        case .neutral:     SpringColor.Text.muted
        case .accent:      SpringColor.Object.champagne
        }
    }

    var backgroundColor: Color {
        switch self {
        case .success:     SpringColor.Object.secondary.opacity(0.12)
        case .warning:     SpringColor.Object.accent.opacity(0.12)
        case .destructive: SpringColor.Object.destructive.opacity(0.12)
        case .neutral:     SpringColor.Background.secondary
        case .accent:      SpringColor.Object.champagne.opacity(0.12)
        }
    }

    var accessibilityDescription: String {
        switch self {
        case .success:     "Active"
        case .warning:     "Pending"
        case .destructive: "Error"
        case .neutral:     "Inactive"
        case .accent:      "Highlighted"
        }
    }
}

// MARK: - Preview

#Preview("SpringBadge") {
    VStack(spacing: SpringSpacing.Vertical.md) {
        HStack(spacing: SpringSpacing.Horizontal.sm) {
            SpringBadge("Confirmed", style: .success)
            SpringBadge("Pending", style: .warning)
            SpringBadge("Cancelled", style: .destructive)
            SpringBadge("Completed", style: .neutral)
            SpringBadge("New", style: .accent)
        }

        HStack(spacing: SpringSpacing.Horizontal.md) {
            SpringBadge(style: .success)
            SpringBadge(style: .warning)
            SpringBadge(style: .destructive)
            SpringBadge(style: .neutral)
        }
    }
    .padding()
    .background(SpringColor.Background.primary)
}
