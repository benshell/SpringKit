import SwiftUI

/// A section heading with an optional subtitle and decorative botanical divider.
///
/// The title can optionally use the Great Vibes accent font for added elegance.
/// The divider is rendered as a champagne-gold horizontal rule flanked by
/// decorative leaf symbols.
///
/// ```swift
/// SectionHeader(
///     title: "Our Story",
///     subtitle: "A vineyard born of passion, cultivated with care.",
///     useAccentFont: true
/// )
/// ```
public struct SectionHeader: View {

    // MARK: - Properties

    private let title: String
    private let subtitle: String?
    private let useAccentFont: Bool
    private let alignment: HorizontalAlignment

    // MARK: - Init

    /// - Parameters:
    ///   - title: Section title text.
    ///   - subtitle: Optional supporting text displayed below the title.
    ///   - useAccentFont: Use Great Vibes for the title. Defaults to `false`.
    ///   - alignment: Content alignment. Defaults to `.center`.
    public init(
        title: String,
        subtitle: String? = nil,
        useAccentFont: Bool = false,
        alignment: HorizontalAlignment = .center
    ) {
        self.title = title
        self.subtitle = subtitle
        self.useAccentFont = useAccentFont
        self.alignment = alignment
    }

    // MARK: - Body

    public var body: some View {
        VStack(alignment: alignment, spacing: SpringSpacing.Vertical.sm) {
            Text(title)
                .font(
                    useAccentFont
                        ? SpringFont.accent(size: SpringFontSize.heading1)
                        : SpringFont.prose(size: SpringFontSize.heading2, weight: .semibold)
                )
                .foregroundStyle(SpringColor.Text.primary)
                .multilineTextAlignment(textAlignment)

            if let subtitle {
                Text(subtitle)
                    .font(SpringFont.prose(size: SpringFontSize.body, weight: .light))
                    .foregroundStyle(SpringColor.Text.secondary)
                    .multilineTextAlignment(textAlignment)
            }

            botanicalDivider
        }
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isHeader)
        .accessibilityLabel([title, subtitle].compactMap { $0 }.joined(separator: ". "))
    }

    private var textAlignment: TextAlignment {
        switch alignment {
        case .leading: return .leading
        case .trailing: return .trailing
        default: return .center
        }
    }

    private var botanicalDivider: some View {
        HStack(spacing: SpringSpacing.Horizontal.sm) {
            if alignment != .leading {
                line
            }

            Image(systemName: "leaf.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 12, height: 12)
                .foregroundStyle(SpringColor.Object.champagne)
                .rotationEffect(.degrees(-45))

            line

            if alignment == .center {
                Image(systemName: "leaf.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 12, height: 12)
                    .foregroundStyle(SpringColor.Object.champagne)
                    .rotationEffect(.degrees(135))

                if alignment != .trailing {
                    line
                }
            }
        }
        .frame(maxWidth: alignment == .center ? 200 : .infinity)
        .accessibilityHidden(true)
    }

    private var line: some View {
        Rectangle()
            .fill(SpringColor.Object.champagne.opacity(0.6))
            .frame(height: 1)
    }
}

// MARK: - Preview

#Preview("SectionHeader") {
    VStack(spacing: SpringSpacing.Vertical.xl) {
        SectionHeader(
            title: "Vineyard Estate",
            subtitle: "A place where time slows and beauty is ever-present.",
            useAccentFont: true
        )

        SectionHeader(
            title: "Our Offerings",
            subtitle: "Curated experiences for every occasion.",
            alignment: .leading
        )

        SectionHeader(title: "Gallery")
    }
    .padding(SpringSpacing.Horizontal.lg)
    .background(SpringColor.Background.primary)
}
