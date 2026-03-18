import SwiftUI
import SpringKit

struct TokensTab: View {
    @Environment(\.horizontalSizeClass) private var sizeClass

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: SpringSpacing.Vertical.lg) {

                    // MARK: Colors

                    SectionHeader(title: "Color Tokens", useAccentFont: true)

                    colorSection(title: "Text", tokens: textColorTokens)
                    colorSection(title: "Object", tokens: objectColorTokens)
                    colorSection(title: "Background", tokens: backgroundColorTokens)

                    Divider()
                        .padding(.horizontal, SpringSpacing.Horizontal.md)

                    // MARK: Typography

                    SectionHeader(title: "Typography Scale", useAccentFont: true)

                    VStack(alignment: .leading, spacing: SpringSpacing.Vertical.sm) {
                        typographyRow(label: ".hero (56pt)", text: "Vineyard", size: SpringFontSize.hero, isAccent: true)
                        typographyRow(label: ".display (44pt)", text: "Estate Dining", size: SpringFontSize.display, isAccent: true)
                        typographyRow(label: ".heading1 (34pt)", text: "Spring Tasting Menu", size: SpringFontSize.heading1, isAccent: false)
                        typographyRow(label: ".heading2 (28pt)", text: "Wine Cellar Selection", size: SpringFontSize.heading2, isAccent: false)
                        typographyRow(label: ".heading3 (24pt)", text: "Private Dining Rooms", size: SpringFontSize.heading3, isAccent: false)
                        typographyRow(label: ".subheading (20pt)", text: "Reserve Your Table", size: SpringFontSize.subheading, isAccent: false)
                        typographyRow(label: ".callout (18pt)", text: "Seasonal menus crafted with care.", size: SpringFontSize.callout, isAccent: false)
                        typographyRow(label: ".body (16pt)", text: "An experience among the vines.", size: SpringFontSize.body, isAccent: false)
                        typographyRow(label: ".footnote (13pt)", text: "Reservations open from 6 pm nightly.", size: SpringFontSize.footnote, isAccent: false)
                        typographyRow(label: ".caption (11pt)", text: "Last orders 9:30 pm. Service charge 12.5%.", size: SpringFontSize.caption, isAccent: false)
                    }
                    .padding(.horizontal, SpringSpacing.Horizontal.md)

                    Divider()
                        .padding(.horizontal, SpringSpacing.Horizontal.md)

                    // MARK: Spacing

                    SectionHeader(title: "Spacing Scale", useAccentFont: true)

                    VStack(alignment: .leading, spacing: SpringSpacing.Vertical.sm) {
                        spacingRow(label: "Vertical.xs", value: SpringSpacing.Vertical.xs)
                        spacingRow(label: "Vertical.sm", value: SpringSpacing.Vertical.sm)
                        spacingRow(label: "Vertical.md", value: SpringSpacing.Vertical.md)
                        spacingRow(label: "Vertical.lg", value: SpringSpacing.Vertical.lg)
                        spacingRow(label: "Vertical.xl", value: SpringSpacing.Vertical.xl)
                        spacingRow(label: "Vertical.xxl", value: SpringSpacing.Vertical.xxl)
                    }
                    .padding(.horizontal, SpringSpacing.Horizontal.md)

                    Divider()
                        .padding(.horizontal, SpringSpacing.Horizontal.md)

                    // MARK: Materials

                    SectionHeader(title: "Glass Materials", useAccentFont: true)

                    VStack(spacing: SpringSpacing.Vertical.md) {
                        materialRow(label: ".default", variant: .default)
                        materialRow(label: ".forest", variant: .forest)
                        materialRow(label: ".harvest", variant: .harvest)
                    }
                    .padding(.horizontal, SpringSpacing.Horizontal.md)
                }
                .padding(.vertical, SpringSpacing.Vertical.md)
                .readableContentWidth(900)
            }
            .navigationTitle("Design Tokens")
        }
    }

    // MARK: - Helpers

    private func colorSection(title: String, tokens: [(String, Color)]) -> some View {
        let columnCount = sizeClass == .regular ? 6 : 3
        let columns = Array(repeating: GridItem(.flexible()), count: columnCount)

        return VStack(alignment: .leading, spacing: SpringSpacing.Vertical.sm) {
            Text(title)
                .springProseFont(size: SpringFontSize.footnote, weight: .semibold)
                .foregroundStyle(SpringColor.Text.secondary)
                .padding(.horizontal, SpringSpacing.Horizontal.md)

            LazyVGrid(
                columns: columns,
                spacing: SpringSpacing.Vertical.sm
            ) {
                ForEach(tokens, id: \.0) { name, color in
                    VStack(spacing: SpringSpacing.Vertical.xs) {
                        RoundedRectangle(cornerRadius: SpringSpacing.CornerRadius.sm)
                            .fill(color)
                            .frame(height: 48)
                            .overlay(
                                RoundedRectangle(cornerRadius: SpringSpacing.CornerRadius.sm)
                                    .strokeBorder(SpringColor.Object.border, lineWidth: 0.5)
                            )
                        Text(name)
                            .springProseFont(size: SpringFontSize.caption, weight: .regular)
                            .foregroundStyle(SpringColor.Text.muted)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                    }
                }
            }
            .padding(.horizontal, SpringSpacing.Horizontal.md)
        }
    }

    private func typographyRow(label: String, text: String, size: SpringFontSize.Token, isAccent: Bool) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .springProseFont(size: SpringFontSize.caption, weight: .regular)
                .foregroundStyle(SpringColor.Text.muted)
            if isAccent {
                Text(text)
                    .springAccentFont(size: size)
                    .foregroundStyle(SpringColor.Text.primary)
            } else {
                Text(text)
                    .springProseFont(size: size, weight: .regular)
                    .foregroundStyle(SpringColor.Text.primary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, SpringSpacing.Vertical.xs)
    }

    private func spacingRow(label: String, value: CGFloat) -> some View {
        HStack(spacing: SpringSpacing.Horizontal.md) {
            Text(label)
                .springProseFont(size: SpringFontSize.footnote, weight: .regular)
                .foregroundStyle(SpringColor.Text.secondary)
                .frame(width: 120, alignment: .leading)

            HStack(spacing: 0) {
                Rectangle()
                    .fill(SpringColor.Object.secondary)
                    .frame(width: value, height: 20)
                    .clipShape(RoundedRectangle(cornerRadius: 2))
                Spacer()
            }

            Text("\(Int(value))pt")
                .springProseFont(size: SpringFontSize.caption, weight: .regular)
                .foregroundStyle(SpringColor.Text.muted)
        }
    }

    private func materialRow(label: String, variant: SpringMaterial.Variant) -> some View {
        let textColor: Color = switch variant {
        case .forest: SpringColor.Text.inverted
        default: SpringColor.Text.primary
        }

        return Text(label)
            .springProseFont(size: SpringFontSize.body, weight: .medium)
            .foregroundStyle(textColor)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(SpringSpacing.Vertical.md)
            .springGlassCard(variant, cornerRadius: SpringSpacing.CornerRadius.md)
    }

    // MARK: - Token Definitions

    private var textColorTokens: [(String, Color)] {
        [
            ("primary", SpringColor.Text.primary),
            ("secondary", SpringColor.Text.secondary),
            ("accent", SpringColor.Text.accent),
            ("muted", SpringColor.Text.muted),
            ("inverted", SpringColor.Text.inverted),
            ("link", SpringColor.Text.link),
        ]
    }

    private var objectColorTokens: [(String, Color)] {
        [
            ("primary", SpringColor.Object.primary),
            ("secondary", SpringColor.Object.secondary),
            ("accent", SpringColor.Object.accent),
            ("champagne", SpringColor.Object.champagne),
            ("border", SpringColor.Object.border),
            ("destructive", SpringColor.Object.destructive),
        ]
    }

    private var backgroundColorTokens: [(String, Color)] {
        [
            ("primary", SpringColor.Background.primary),
            ("secondary", SpringColor.Background.secondary),
            ("surface", SpringColor.Background.surface),
            ("elevated", SpringColor.Background.elevated),
            ("accent", SpringColor.Background.accent),
            ("overlay", SpringColor.Background.overlay),
        ]
    }
}

#Preview {
    TokensTab()
}
