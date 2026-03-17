import SwiftUI

/// Transparent, text-only button for tertiary or destructive actions.
///
/// ```swift
/// GhostButton("Cancel") { }
/// GhostButton("Remove", style: .destructive) { }
/// ```
public struct GhostButton: View {

    public enum Style {
        case `default`
        case destructive
    }

    private let label: String
    private let icon: Image?
    private let style: Style
    private let isFullWidth: Bool
    private let action: () -> Void

    public init(
        _ label: String,
        icon: Image? = nil,
        style: Style = .default,
        isFullWidth: Bool = false,
        action: @escaping () -> Void
    ) {
        self.label = label
        self.icon = icon
        self.style = style
        self.isFullWidth = isFullWidth
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: SpringSpacing.Horizontal.xs) {
                if let icon {
                    icon.resizable().scaledToFit().frame(width: 16, height: 16)
                }
                Text(label)
            }
            .font(SpringFont.prose(size: SpringFontSize.body, weight: .medium))
            .foregroundStyle(foregroundColor)
            .padding(.horizontal, SpringSpacing.Horizontal.md)
            .padding(.vertical, SpringSpacing.Vertical.sm)
            .frame(minHeight: SpringSpacing.minimumTapTarget)
            .frame(maxWidth: isFullWidth ? .infinity : nil)
        }
        .buttonStyle(SpringGhostButtonStyle())
        .accessibilityLabel(label)
    }

    private var foregroundColor: Color {
        style == .destructive ? SpringColor.Object.destructive : SpringColor.Text.muted
    }
}

private struct SpringGhostButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.5 : 1.0)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

// MARK: - Preview

#Preview("GhostButton") {
    VStack(spacing: SpringSpacing.Vertical.md) {
        GhostButton("Cancel") { }
        GhostButton("Not Now") { }
        GhostButton("Remove Reservation", style: .destructive) { }
        GhostButton("Skip", isFullWidth: true) { }
    }
    .padding()
    .background(SpringColor.Background.primary)
}
