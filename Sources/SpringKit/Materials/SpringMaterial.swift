import SwiftUI

/// SpringKit Liquid Glass material system (iOS 26).
///
/// Wraps iOS 26's `glassEffect()` modifier to provide consistent, on-brand
/// glass surfaces across the SpringKit component library.
///
/// ## Usage
/// ```swift
/// // Glass background on a card
/// MyCardContent()
///     .springGlassCard()
///
/// // Tinted glass with custom corner radius
/// SomeView()
///     .springGlass(.forest, cornerRadius: 20)
///
/// // Group multiple glass views so they merge their edges
/// SpringGlassContainer {
///     TopPanel()
///     BottomPanel()
/// }
///
/// // Frosted overlay behind a modal
/// Color.clear
///     .springFrostedOverlay()
/// ```
public enum SpringMaterial {

    /// Available SpringKit glass variants.
    public enum Variant {
        /// Standard Liquid Glass — general surfaces, cards, panels.
        case `default`
        /// Thin glass — lightweight overlays and secondary panels.
        case thin
        /// Thick glass — prominent cards and modal surfaces.
        case thick
        /// Forest-tinted glass — navigation bars and brand-forward surfaces.
        case forest
        /// Harvest-orange tinted glass — call-to-action highlights.
        case harvest
    }
}

// MARK: - Glass View Modifiers

public extension View {

    /// Applies a Liquid Glass background material.
    ///
    /// - Parameters:
    ///   - variant: The SpringKit glass variant. Defaults to `.default`.
    ///   - cornerRadius: Shape corner radius. Defaults to `SpringSpacing.CornerRadius.lg` (16pt).
    func springGlass(
        _ variant: SpringMaterial.Variant = .default,
        cornerRadius: CGFloat = SpringSpacing.CornerRadius.lg
    ) -> some View {
        self.modifier(SpringGlassModifier(variant: variant, cornerRadius: cornerRadius))
    }

    /// Applies a Liquid Glass card — glass background + padding + shadow.
    ///
    /// - Parameters:
    ///   - variant: The SpringKit glass variant. Defaults to `.default`.
    ///   - cornerRadius: Shape corner radius. Defaults to `SpringSpacing.CornerRadius.lg`.
    func springGlassCard(
        _ variant: SpringMaterial.Variant = .default,
        cornerRadius: CGFloat = SpringSpacing.CornerRadius.lg
    ) -> some View {
        self.modifier(SpringGlassCardModifier(variant: variant, cornerRadius: cornerRadius))
    }

    /// Applies a frosted semi-transparent overlay — used for modal backdrops
    /// and image overlays.
    func springFrostedOverlay() -> some View {
        self.modifier(SpringFrostedOverlayModifier())
    }

    /// Applies Liquid Glass styling appropriate for a navigation bar surface.
    func springNavigationMaterial() -> some View {
        self.modifier(SpringNavigationMaterialModifier())
    }
}

// MARK: - Modifiers

private struct SpringGlassModifier: ViewModifier {
    let variant: SpringMaterial.Variant
    let cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content
            .glassEffect(.regular, in: .rect(cornerRadius: cornerRadius))
            .overlay(variantTint(cornerRadius: cornerRadius))
    }

    @ViewBuilder
    private func variantTint(cornerRadius: CGFloat) -> some View {
        switch variant {
        case .default, .thin, .thick:
            EmptyView()
        case .forest:
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(SpringColor.Object.primary.opacity(0.12))
        case .harvest:
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(SpringColor.Object.accent.opacity(0.12))
        }
    }
}

private struct SpringGlassCardModifier: ViewModifier {
    let variant: SpringMaterial.Variant
    let cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content
            .padding(SpringSpacing.Vertical.md)
            .glassEffect(.regular, in: .rect(cornerRadius: cornerRadius))
            .shadow(
                color: SpringColor.Object.primary.opacity(0.08),
                radius: 12,
                x: 0,
                y: 4
            )
    }
}

private struct SpringFrostedOverlayModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .glassEffect(.regular, in: .rect)
            .opacity(0.85)
    }
}

private struct SpringNavigationMaterialModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .glassEffect(.regular, in: .rect)
    }
}

// MARK: - Glass Container

/// A container that groups multiple glass-effect views so their edges merge
/// into a single unified Liquid Glass surface (iOS 26 behavior).
///
/// ```swift
/// SpringGlassContainer {
///     HeaderBar()
///     ContentPanel()
/// }
/// ```
public struct SpringGlassContainer<Content: View>: View {

    private let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        GlassEffectContainer {
            content
        }
    }
}
