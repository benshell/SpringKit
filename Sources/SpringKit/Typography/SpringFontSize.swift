import SwiftUI

/// Standard text size tokens for SpringKit.
///
/// Each token pairs a base point size with a `Font.TextStyle` that SwiftUI
/// uses to scale the font with Dynamic Type. Use these tokens everywhere a
/// font size is needed — never hardcode a numeric literal in a component file.
///
/// To use a non-standard size, use ``SpringSpacing/fixed(_:)`` to derive a
/// value from the 8pt base unit:
/// ```swift
/// SpringFont.prose(size: .init(base: SpringSpacing.fixed(1.75), relativeTo: .body), weight: .medium) // 14pt
/// ```
@frozen public enum SpringFontSize: Sendable {

    /// A size token pairing a base point size with a Dynamic Type text style.
    public struct Token: Sendable {
        /// The base point size at the default Dynamic Type setting.
        public let base: CGFloat
        /// The text style this size scales relative to.
        public let relativeTo: Font.TextStyle

        public init(base: CGFloat, relativeTo: Font.TextStyle) {
            self.base = base
            self.relativeTo = relativeTo
        }
    }

    // MARK: - Text Sizes

    /// 11pt — fine print, legal copy, metadata labels.
    public static let caption = Token(base: 11, relativeTo: .caption)

    /// 13pt — supporting info, timestamps, photo credits.
    public static let footnote = Token(base: 13, relativeTo: .footnote)

    /// 16pt — primary reading text; default body size.
    public static let body = Token(base: 16, relativeTo: .body)

    /// 18pt — featured callout text, lead paragraphs.
    public static let callout = Token(base: 18, relativeTo: .callout)

    /// 20pt — section subheadings.
    public static let subheading = Token(base: 20, relativeTo: .subheadline)

    /// 24pt — H3 headings.
    public static let heading3 = Token(base: 24, relativeTo: .title3)

    /// 28pt — H2 headings.
    public static let heading2 = Token(base: 28, relativeTo: .title2)

    /// 34pt — H1 headings; prose font recommended.
    public static let heading1 = Token(base: 34, relativeTo: .title)

    /// 44pt — display text; primary size for the accent (Great Vibes) font.
    public static let display = Token(base: 44, relativeTo: .largeTitle)

    /// 56pt — full-bleed hero displays; accent font only.
    public static let hero = Token(base: 56, relativeTo: .largeTitle)
}
