import SwiftUI
import CoreText

/// SpringKit typography system.
///
/// SpringKit defines two font types:
/// - **Prose** (`SpringFont.prose`) — SF Pro (system font). Used for all body
///   copy, UI labels, and headings. Supports the full weight range.
/// - **Accent** (`SpringFont.accent`) — Great Vibes, a flowing calligraphic script
///   by TypeSETit (SIL Open Font License). Used sparingly for decorative headings,
///   hero text, and section headers to evoke elegance and occasion.
///
/// ## Usage
/// ```swift
/// // System prose font
/// Text("Reserve a Table")
///     .font(SpringFont.prose(size: SpringFontSize.heading2, weight: .semibold))
///
/// // Accent cursive font — for decorative headings only
/// Text("Vineyard Estate")
///     .font(SpringFont.accent(size: SpringFontSize.display))
///
/// // View modifier equivalents
/// Text("Welcome").springAccentFont(size: SpringFontSize.hero)
/// Text("Your booking").springProseFont(size: SpringFontSize.body)
/// ```
public enum SpringFont {

    // MARK: - Font Registration

    /// One-time registration of bundled custom fonts. Thread-safe via static let.
    private static let _fontRegistration: Bool = {
        registerFont(named: "GreatVibes-Regular", withExtension: "ttf")
        return true
    }()

    private static func registerFont(named name: String, withExtension ext: String) {
        guard let url = Bundle.module.url(forResource: name, withExtension: ext) else {
            assertionFailure("SpringKit: Font resource '\(name).\(ext)' not found in module bundle.")
            return
        }
        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error) {
            assertionFailure("SpringKit: Failed to register font '\(name)': \(String(describing: error))")
        }
    }

    // MARK: - Prose (SF Pro)

    /// Returns an SF Pro system font at the given size and weight.
    ///
    /// - Parameters:
    ///   - size: Point size. Use a ``SpringFontSize`` constant or ``SpringSpacing/fixed(_:)``.
    ///   - weight: Font weight. Defaults to `.regular`.
    public static func prose(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .default)
    }

    // MARK: - Accent (Great Vibes)

    /// Returns the Great Vibes cursive font at the given size.
    ///
    /// This font should be used **sparingly** — decorative headings and hero text only.
    /// It is not suitable for body copy, UI labels, or interactive elements.
    ///
    /// - Parameter size: Point size. ``SpringFontSize/display`` and ``SpringFontSize/hero``
    ///   are the recommended sizes. Avoid using below ``SpringFontSize/heading2``.
    public static func accent(size: CGFloat) -> Font {
        _ = _fontRegistration
        return .custom("GreatVibes-Regular", size: size)
    }
}

// MARK: - View Modifiers

public extension View {

    /// Applies the SF Pro system font with the specified size and weight.
    func springProseFont(size: CGFloat, weight: Font.Weight = .regular) -> some View {
        self.font(SpringFont.prose(size: size, weight: weight))
    }

    /// Applies the Great Vibes accent font at the specified size.
    ///
    /// Use only for decorative display text. Not suitable for body copy or UI labels.
    func springAccentFont(size: CGFloat) -> some View {
        self.font(SpringFont.accent(size: size))
    }
}
