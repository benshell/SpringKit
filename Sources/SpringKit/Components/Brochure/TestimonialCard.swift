import SwiftUI

/// A testimonial quote card with attribution, optional avatar, and star rating.
///
/// Use in a horizontal `ScrollView` or a stacked list to display guest reviews.
///
/// ```swift
/// TestimonialCard(
///     quote: "An absolutely magical evening. Every detail was perfection.",
///     attribution: "Sophie & James",
///     subtitle: "Wedding, September 2025",
///     rating: 5
/// )
/// ```
public struct TestimonialCard: View {

    // MARK: - Properties

    private let quote: String
    private let attribution: String
    private let subtitle: String?
    private let avatar: Image?
    private let rating: Int

    // MARK: - Init

    /// - Parameters:
    ///   - quote: The testimonial text.
    ///   - attribution: Guest name or couple's names.
    ///   - subtitle: Optional context, e.g. "Wedding, September 2025".
    ///   - avatar: Optional guest photo.
    ///   - rating: Star rating from 1–5. Defaults to 5.
    public init(
        quote: String,
        attribution: String,
        subtitle: String? = nil,
        avatar: Image? = nil,
        rating: Int = 5
    ) {
        self.quote = quote
        self.attribution = attribution
        self.subtitle = subtitle
        self.avatar = avatar
        self.rating = min(max(rating, 1), 5)
    }

    // MARK: - Body

    public var body: some View {
        VStack(alignment: .leading, spacing: SpringSpacing.Vertical.md) {
            // Stars
            HStack(spacing: 3) {
                ForEach(0..<5, id: \.self) { index in
                    Image(systemName: index < rating ? "star.fill" : "star")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 14, height: 14)
                        .foregroundStyle(index < rating ? SpringColor.Object.champagne : SpringColor.Object.border)
                }
            }
            .accessibilityLabel("\(rating) out of 5 stars")

            // Quote
            Text(""\(quote)"")
                .font(SpringFont.prose(size: SpringFontSize.callout, weight: .light))
                .foregroundStyle(SpringColor.Text.primary)
                .italic()
                .fixedSize(horizontal: false, vertical: true)

            // Attribution row
            HStack(spacing: SpringSpacing.Horizontal.sm) {
                if let avatar {
                    avatar
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipShape(.circle)
                        .overlay(Circle().stroke(SpringColor.Object.champagne, lineWidth: 1.5))
                } else {
                    Circle()
                        .fill(SpringColor.Background.secondary)
                        .frame(width: 40, height: 40)
                        .overlay(
                            Text(String(attribution.prefix(1)))
                                .font(SpringFont.prose(size: SpringFontSize.callout, weight: .semibold))
                                .foregroundStyle(SpringColor.Text.secondary)
                        )
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(attribution)
                        .font(SpringFont.prose(size: SpringFontSize.footnote, weight: .semibold))
                        .foregroundStyle(SpringColor.Text.primary)
                    if let subtitle {
                        Text(subtitle)
                            .font(SpringFont.prose(size: SpringFontSize.caption))
                            .foregroundStyle(SpringColor.Text.muted)
                    }
                }
            }
        }
        .padding(SpringSpacing.Vertical.lg)
        .background(SpringColor.Background.surface)
        .clipShape(.rect(cornerRadius: SpringSpacing.CornerRadius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: SpringSpacing.CornerRadius.lg)
                .stroke(SpringColor.Object.border, lineWidth: 1)
        )
        .shadow(color: SpringColor.Object.primary.opacity(0.06), radius: 10, x: 0, y: 3)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(rating) stars. "\(quote)" — \(attribution)\(subtitle.map { ", \($0)" } ?? "")")
    }
}

// MARK: - Preview

#Preview("TestimonialCard") {
    ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: SpringSpacing.Horizontal.md) {
            TestimonialCard(
                quote: "An absolutely magical evening. Every detail was perfection, from the ceremony in the rose garden to the very last dance.",
                attribution: "Sophie & James",
                subtitle: "Wedding, September 2025",
                rating: 5
            )
            .frame(width: 300)

            TestimonialCard(
                quote: "Our corporate dinner exceeded all expectations. The team handled every detail with grace and professionalism.",
                attribution: "Eleanor Voss",
                subtitle: "Private Dinner, March 2025",
                rating: 5
            )
            .frame(width: 300)
        }
        .padding(SpringSpacing.Horizontal.md)
    }
    .background(SpringColor.Background.primary)
}
