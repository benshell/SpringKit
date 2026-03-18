import SwiftUI

/// SpringKit color token system.
///
/// Colors are organized into three independent namespaces — ``Text``, ``Object``,
/// and ``Background`` — because a "primary" text color is not the same hue as a
/// "primary" background color. Each token automatically resolves for Light, Dark,
/// and High Contrast modes via the bundled asset catalog.
///
/// ## Usage
/// ```swift
/// Text("Hello")
///     .foregroundStyle(SpringColor.Text.primary)
///
/// Rectangle()
///     .fill(SpringColor.Background.primary)
///
/// Divider()
///     .foregroundStyle(SpringColor.Object.border)
/// ```
@frozen public enum SpringColor {

    // MARK: - Text

    /// Semantic color tokens for text and typographic elements.
    @frozen public enum Text {

        /// Dominant body and heading text. High contrast against all backgrounds.
        public static let primary = Color("SKTextPrimary", bundle: .module)

        /// Supporting text: captions, metadata, helper labels.
        public static let secondary = Color("SKTextSecondary", bundle: .module)

        /// Harvest orange emphasis — used sparingly for highlighted words or callouts.
        public static let accent = Color("SKTextAccent", bundle: .module)

        /// De-emphasized text: placeholders, disabled states, fine print.
        public static let muted = Color("SKTextMuted", bundle: .module)

        /// Text intended to appear on dark/colored surfaces (e.g., inside buttons).
        public static let inverted = Color("SKTextInverted", bundle: .module)

        /// Interactive text links.
        public static let link = Color("SKTextLink", bundle: .module)
    }

    // MARK: - Object

    /// Semantic color tokens for UI elements: icons, borders, interactive controls.
    @frozen public enum Object {

        /// Primary UI control color — buttons, active indicators, key icons.
        public static let primary = Color("SKObjectPrimary", bundle: .module)

        /// Secondary UI control color — supporting icons, inactive states.
        public static let secondary = Color("SKObjectSecondary", bundle: .module)

        /// Harvest orange accent — call-to-action highlights, badges, emphasis strokes.
        public static let accent = Color("SKObjectAccent", bundle: .module)

        /// Champagne gold — decorative elements, premium indicators, dividers.
        public static let champagne = Color("SKObjectChampagne", bundle: .module)

        /// Subtle border and separator color.
        public static let border = Color("SKObjectBorder", bundle: .module)

        /// Destructive actions: delete, cancel, error states.
        public static let destructive = Color("SKObjectDestructive", bundle: .module)
    }

    // MARK: - Background

    /// Semantic color tokens for view and container backgrounds.
    @frozen public enum Background {

        /// Root screen background — the base canvas.
        public static let primary = Color("SKBackgroundPrimary", bundle: .module)

        /// Secondary screen regions: sidebars, grouped list backgrounds.
        public static let secondary = Color("SKBackgroundSecondary", bundle: .module)

        /// Card and sheet surfaces that sit above the primary background.
        public static let surface = Color("SKBackgroundSurface", bundle: .module)

        /// Elevated surfaces: popovers, menus, floating panels.
        public static let elevated = Color("SKBackgroundElevated", bundle: .module)

        /// Subtle harvest-orange tint for highlighted or featured regions.
        public static let accent = Color("SKBackgroundAccent", bundle: .module)

        /// Semi-transparent overlay for modals, bottom sheets, and lightboxes.
        public static let overlay = Color("SKBackgroundOverlay", bundle: .module)
    }
}
