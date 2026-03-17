import SwiftUI

/// A full-bleed hero section with a background image, gradient overlay,
/// headline (accent font), optional subheadline, and an optional CTA button.
///
/// Designed for the top of brochure-style screens: landing pages, venue
/// overviews, and seasonal feature banners.
///
/// ```swift
/// HeroView(
///     image: Image("vineyard-sunset"),
///     headline: "Timeless Celebrations",
///     subheadline: "Where every detail tells your story.",
///     ctaLabel: "Explore the Estate"
/// ) {
///     // CTA action
/// }
/// ```
public struct HeroView: View {

    // MARK: - Configuration

    public struct Configuration {
        public var image: Image
        public var headline: String
        public var subheadline: String?
        public var ctaLabel: String?
        public var ctaAction: (() -> Void)?
        /// Minimum height of the hero. Defaults to 480pt.
        public var minimumHeight: CGFloat
        /// Gradient overlay opacity — increase for legibility on bright images.
        public var overlayOpacity: Double

        public init(
            image: Image,
            headline: String,
            subheadline: String? = nil,
            ctaLabel: String? = nil,
            minimumHeight: CGFloat = 480,
            overlayOpacity: Double = 0.45,
            ctaAction: (() -> Void)? = nil
        ) {
            self.image = image
            self.headline = headline
            self.subheadline = subheadline
            self.ctaLabel = ctaLabel
            self.minimumHeight = minimumHeight
            self.overlayOpacity = overlayOpacity
            self.ctaAction = ctaAction
        }
    }

    // MARK: - Init

    private let config: Configuration

    public init(
        image: Image,
        headline: String,
        subheadline: String? = nil,
        ctaLabel: String? = nil,
        minimumHeight: CGFloat = 480,
        overlayOpacity: Double = 0.45,
        ctaAction: (() -> Void)? = nil
    ) {
        self.config = Configuration(
            image: image,
            headline: headline,
            subheadline: subheadline,
            ctaLabel: ctaLabel,
            minimumHeight: minimumHeight,
            overlayOpacity: overlayOpacity,
            ctaAction: ctaAction
        )
    }

    // MARK: - Body

    public var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                config.image
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: max(config.minimumHeight, geo.size.height))
                    .clipped()

                // Gradient overlay for text legibility
                LinearGradient(
                    colors: [
                        Color.black.opacity(0),
                        Color.black.opacity(config.overlayOpacity * 0.4),
                        Color.black.opacity(config.overlayOpacity)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )

                // Text content
                VStack(alignment: .leading, spacing: SpringSpacing.Vertical.sm) {
                    Text(config.headline)
                        .font(SpringFont.accent(size: SpringFontSize.display))
                        .foregroundStyle(SpringColor.Text.inverted)
                        .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)

                    if let subheadline = config.subheadline {
                        Text(subheadline)
                            .font(SpringFont.prose(size: SpringFontSize.callout, weight: .light))
                            .foregroundStyle(SpringColor.Text.inverted.opacity(0.90))
                    }

                    if let label = config.ctaLabel, let action = config.ctaAction {
                        AccentButton(label, action: action)
                            .padding(.top, SpringSpacing.Vertical.sm)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, SpringSpacing.Horizontal.lg)
                .padding(.bottom, SpringSpacing.Vertical.xl)
            }
        }
        .frame(minHeight: config.minimumHeight)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
    }

    private var accessibilityLabel: String {
        var parts = [config.headline]
        if let sub = config.subheadline { parts.append(sub) }
        if let cta = config.ctaLabel { parts.append(cta) }
        return parts.joined(separator: ". ")
    }
}

// MARK: - Preview

#Preview("HeroView — Light") {
    ScrollView {
        HeroView(
            image: Image(systemName: "photo.fill"),
            headline: "Vineyard Estate",
            subheadline: "Where every celebration becomes a cherished memory.",
            ctaLabel: "Explore the Estate"
        ) { }
    }
    .ignoresSafeArea()
}

#Preview("HeroView — No CTA") {
    HeroView(
        image: Image(systemName: "photo.fill"),
        headline: "Timeless Celebrations"
    )
    .ignoresSafeArea()
}
