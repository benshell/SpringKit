import SwiftUI

/// Harvest-orange filled button for high-priority calls to action.
///
/// Use for the single most important action on a screen — "Book Now",
/// "Order", "Enquire". Avoid using more than once per view.
///
/// ```swift
/// AccentButton("Book a Table") { startBooking() }
/// AccentButton("Reserve Now", isFullWidth: true) { }
/// ```
public struct AccentButton: View {

    private let label: String
    private let icon: Image?
    private let isLoading: Bool
    private let isFullWidth: Bool
    private let action: () -> Void

    public init(
        _ label: String,
        icon: Image? = nil,
        isLoading: Bool = false,
        isFullWidth: Bool = false,
        action: @escaping () -> Void
    ) {
        self.label = label
        self.icon = icon
        self.isLoading = isLoading
        self.isFullWidth = isFullWidth
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: SpringSpacing.Horizontal.xs) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(SpringColor.Text.inverted)
                        .scaleEffect(0.8)
                } else {
                    if let icon {
                        icon.resizable().scaledToFit().frame(width: 16, height: 16)
                    }
                    Text(label)
                }
            }
            .font(SpringFont.prose(size: SpringFontSize.body, weight: .semibold))
            .foregroundStyle(SpringColor.Text.inverted)
            .padding(.horizontal, SpringSpacing.Horizontal.lg)
            .padding(.vertical, SpringSpacing.Vertical.sm + 2)
            .frame(minHeight: SpringSpacing.minimumTapTarget)
            .frame(maxWidth: isFullWidth ? .infinity : nil)
        }
        .buttonStyle(SpringAccentButtonStyle())
        .disabled(isLoading)
        .accessibilityLabel(label)
        .accessibilityHint(isLoading ? "Loading" : "")
    }
}

private struct SpringAccentButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                SpringColor.Object.accent,
                in: .rect(cornerRadius: SpringSpacing.CornerRadius.sm)
            )
            .opacity(configuration.isPressed ? 0.85 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

// MARK: - Preview

#Preview("AccentButton") {
    VStack(spacing: SpringSpacing.Vertical.md) {
        AccentButton("Book a Table") { }
        AccentButton("Reserve Now", isLoading: true) { }
        AccentButton("Begin Planning", isFullWidth: true) { }
        AccentButton("Order Now", icon: Image(systemName: "cart.fill")) { }
    }
    .padding()
    .background(SpringColor.Background.primary)
}
