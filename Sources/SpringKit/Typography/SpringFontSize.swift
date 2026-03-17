import CoreGraphics

/// Standard text size tokens for SpringKit.
///
/// All sizes are in points. Use these constants everywhere a font size is
/// needed — never hardcode a numeric literal in a component file.
///
/// To use a non-standard size, use ``SpringSpacing/fixed(_:)`` to derive a
/// value from the 8pt base unit:
/// ```swift
/// SpringFont.prose(size: SpringSpacing.fixed(1.75), weight: .medium) // 14pt
/// ```
public enum SpringFontSize {

    // MARK: - Text Sizes

    /// 11pt — fine print, legal copy, metadata labels.
    public static let caption: CGFloat = 11

    /// 13pt — supporting info, timestamps, photo credits.
    public static let footnote: CGFloat = 13

    /// 16pt — primary reading text; default body size.
    public static let body: CGFloat = 16

    /// 18pt — featured callout text, lead paragraphs.
    public static let callout: CGFloat = 18

    /// 20pt — section subheadings.
    public static let subheading: CGFloat = 20

    /// 24pt — H3 headings.
    public static let heading3: CGFloat = 24

    /// 28pt — H2 headings.
    public static let heading2: CGFloat = 28

    /// 34pt — H1 headings; prose font recommended.
    public static let heading1: CGFloat = 34

    /// 44pt — display text; primary size for the accent (Great Vibes) font.
    public static let display: CGFloat = 44

    /// 56pt — full-bleed hero displays; accent font only.
    public static let hero: CGFloat = 56
}
