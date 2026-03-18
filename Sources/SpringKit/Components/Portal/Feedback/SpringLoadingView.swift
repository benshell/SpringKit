import SwiftUI

/// A branded loading state view for async operations.
///
/// ```swift
/// if isLoading {
///     SpringLoadingView(message: "Confirming your reservation…")
/// }
/// ```
public struct SpringLoadingView: View {

    // MARK: - Style

    @frozen public enum Style: Sendable {
        /// Inline spinner with optional label — use inside cards and forms.
        case inline
        /// Full-screen overlay with glass background.
        case overlay
    }

    // MARK: - Properties

    private let message: String?
    private let style: Style

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    public init(message: String? = nil, style: Style = .inline) {
        self.message = message
        self.style = style
    }

    // MARK: - Body

    public var body: some View {
        switch style {
        case .inline:
            inlineContent
        case .overlay:
            overlayContent
        }
    }

    private var inlineContent: some View {
        VStack(spacing: SpringSpacing.Vertical.sm) {
            spinner

            if let message {
                Text(message)
                    .font(SpringFont.prose(size: SpringFontSize.footnote, weight: .medium))
                    .foregroundStyle(SpringColor.Text.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .accessibilityLabel(message ?? "Loading")
        .accessibilityAddTraits(.updatesFrequently)
    }

    private var overlayContent: some View {
        ZStack {
            SpringColor.Background.overlay
                .ignoresSafeArea()

            VStack(spacing: SpringSpacing.Vertical.md) {
                spinner

                if let message {
                    Text(message)
                        .font(SpringFont.prose(size: SpringFontSize.body, weight: .medium))
                        .foregroundStyle(SpringColor.Text.primary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, SpringSpacing.Horizontal.lg)
                }
            }
            .padding(SpringSpacing.Vertical.xl)
            .springGlassCard()
        }
        .accessibilityLabel(message ?? "Loading")
        .accessibilityAddTraits(.updatesFrequently)
    }

    private var spinner: some View {
        ProgressView()
            .progressViewStyle(.circular)
            .tint(SpringColor.Object.primary)
            .scaleEffect(reduceMotion ? 1.0 : 1.2)
    }
}

// MARK: - View Modifier

public extension View {

    /// Overlays a `SpringLoadingView` when `isLoading` is `true`.
    func springLoadingOverlay(isLoading: Bool, message: String? = nil) -> some View {
        self.overlay {
            if isLoading {
                SpringLoadingView(message: message, style: .overlay)
                    .transition(.opacity)
            }
        }
        .animation(.easeOut(duration: 0.2), value: isLoading)
    }
}

// MARK: - Preview

#Preview("SpringLoadingView — Inline") {
    VStack(spacing: SpringSpacing.Vertical.xl) {
        SpringLoadingView()
        SpringLoadingView(message: "Checking availability…")
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(SpringColor.Background.primary)
}

#Preview("SpringLoadingView — Overlay") {
    Color.clear
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(SpringColor.Background.primary)
        .springLoadingOverlay(isLoading: true, message: "Confirming your reservation…")
}
