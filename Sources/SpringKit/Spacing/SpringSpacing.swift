import CoreGraphics

/// SpringKit spacing and sizing token system.
///
/// All layout values — padding, gaps, margins — must come from this file.
/// Never hardcode a numeric spacing literal in a component.
///
/// ## Fixed-Multiplier Utility
/// The ``fixed(_:)`` function derives any size from the 8pt base unit:
/// ```swift
/// SpringSpacing.fixed(0.5)  // →  4pt
/// SpringSpacing.fixed(1)    // →  8pt
/// SpringSpacing.fixed(2)    // → 16pt
/// SpringSpacing.fixed(3)    // → 24pt
/// SpringSpacing.fixed(20)   // → 160pt
/// ```
/// To retheme the entire spacing scale, change ``baseUnit`` in one place.
public enum SpringSpacing {

    // MARK: - Base Unit

    /// The foundational spacing unit. All ``fixed(_:)`` values derive from this.
    /// Default: 8pt.
    public static let baseUnit: CGFloat = 8

    /// Returns a size equal to `baseUnit × multiplier`.
    ///
    /// - Parameter multiplier: Any positive CGFloat. Common values: 0.5, 1, 1.5, 2, 3, 4, 5, 8, 10.
    public static func fixed(_ multiplier: CGFloat) -> CGFloat {
        baseUnit * multiplier
    }

    // MARK: - Vertical Spacing

    /// Named vertical spacing tokens for padding, gaps, and section rhythm.
    public enum Vertical {

        /// 4pt — tight inline gaps (icon-to-label, badge padding).
        public static let xs: CGFloat = 4

        /// 8pt — small internal padding within a component.
        public static let sm: CGFloat = 8

        /// 16pt — standard component padding; default inset.
        public static let md: CGFloat = 16

        /// 24pt — gap between related components in a section.
        public static let lg: CGFloat = 24

        /// 40pt — visual break between content sections.
        public static let xl: CGFloat = 40

        /// 64pt — major section separator; hero-to-content transitions.
        public static let xxl: CGFloat = 64
    }

    // MARK: - Horizontal Spacing

    /// Named horizontal spacing tokens for screen margins and content insets.
    public enum Horizontal {

        /// 4pt — tight inline gaps (icon-to-label, chip padding).
        public static let xs: CGFloat = 4

        /// 8pt — small internal horizontal padding.
        public static let sm: CGFloat = 8

        /// 16pt — standard screen edge margin.
        public static let md: CGFloat = 16

        /// 24pt — content padding; preferred reading inset.
        public static let lg: CGFloat = 24

        /// 40pt — wide layout insets; tablet-style content columns.
        public static let xl: CGFloat = 40

        /// 64pt — full-width section padding; generous breathing room.
        public static let xxl: CGFloat = 64
    }

    // MARK: - Corner Radii

    /// Standard corner radius tokens for cards, buttons, and inputs.
    public enum CornerRadius {

        /// 4pt — subtle rounding for chips and small badges.
        public static let xs: CGFloat = 4

        /// 8pt — default button and input field radius.
        public static let sm: CGFloat = 8

        /// 12pt — standard card radius.
        public static let md: CGFloat = 12

        /// 16pt — prominent card and sheet radius.
        public static let lg: CGFloat = 16

        /// 24pt — large modal and hero card radius.
        public static let xl: CGFloat = 24

        /// 9999pt — fully rounded pill shape.
        public static let pill: CGFloat = 9999
    }

    // MARK: - Minimum Tap Target

    /// Minimum interactive element size per Apple HIG: 44×44pt.
    public static let minimumTapTarget: CGFloat = 44
}
