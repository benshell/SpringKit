import SwiftUI

/// A card that showcases a venue feature, amenity, or service offering.
///
/// Displays an optional image, an optional icon, a title, and a body description.
/// Use in a `LazyVGrid` or `ScrollView` to present a set of offerings.
///
/// ```swift
/// FeatureCard(
///     image: Image("ceremony-garden"),
///     icon: Image(systemName: "leaf.fill"),
///     title: "Garden Ceremonies",
///     body: "Exchange vows beneath a canopy of wisteria and climbing roses."
/// )
/// ```
public struct FeatureCard: View {

    // MARK: - Properties

    private let image: Image?
    private let icon: Image?
    private let title: String
    private let body: String
    private let onTap: (() -> Void)?

    // MARK: - Init

    public init(
        image: Image? = nil,
        icon: Image? = nil,
        title: String,
        body: String,
        onTap: (() -> Void)? = nil
    ) {
        self.image = image
        self.icon = icon
        self.title = title
        self.body = body
        self.onTap = onTap
    }

    // MARK: - Body

    public var body: some View {
        Group {
            if let action = onTap {
                Button(action: action) { cardContent }
                    .buttonStyle(.plain)
            } else {
                cardContent
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title). \(body)")
        .accessibilityAddTraits(onTap != nil ? .isButton : [])
    }

    private var cardContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let image {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(height: 180)
                    .clipped()
            }

            VStack(alignment: .leading, spacing: SpringSpacing.Vertical.xs) {
                HStack(spacing: SpringSpacing.Horizontal.xs) {
                    if let icon {
                        icon
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 18)
                            .foregroundStyle(SpringColor.Object.champagne)
                    }

                    Text(title)
                        .font(SpringFont.prose(size: SpringFontSize.subheading, weight: .semibold))
                        .foregroundStyle(SpringColor.Text.primary)
                }

                Text(body)
                    .font(SpringFont.prose(size: SpringFontSize.body))
                    .foregroundStyle(SpringColor.Text.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(SpringSpacing.Vertical.md)
        }
        .background(SpringColor.Background.surface)
        .clipShape(.rect(cornerRadius: SpringSpacing.CornerRadius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: SpringSpacing.CornerRadius.lg)
                .stroke(SpringColor.Object.border, lineWidth: 1)
        )
        .shadow(color: SpringColor.Object.primary.opacity(0.06), radius: 8, x: 0, y: 3)
    }
}

// MARK: - Preview

#Preview("FeatureCard") {
    ScrollView {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: SpringSpacing.Vertical.md) {
            FeatureCard(
                icon: Image(systemName: "leaf.fill"),
                title: "Garden Ceremonies",
                body: "Exchange vows beneath a canopy of wisteria and climbing roses."
            )
            FeatureCard(
                icon: Image(systemName: "fork.knife"),
                title: "Fine Dining",
                body: "A seasonally-changing menu celebrating local produce and craft wines."
            )
            FeatureCard(
                icon: Image(systemName: "wineglass.fill"),
                title: "Private Wine Tastings",
                body: "Curated cellar tours and guided tastings for intimate groups."
            )
            FeatureCard(
                icon: Image(systemName: "music.note"),
                title: "Live Entertainment",
                body: "From string quartets to jazz ensembles for every occasion."
            )
        }
        .padding(SpringSpacing.Horizontal.md)
    }
    .background(SpringColor.Background.primary)
}
