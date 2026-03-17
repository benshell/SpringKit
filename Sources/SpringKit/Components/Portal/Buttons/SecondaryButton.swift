import SwiftUI

/// Outlined Forest-green button for secondary actions.
///
/// ```swift
/// SecondaryButton("View Menu") { }
/// SecondaryButton("Edit Details", isFullWidth: true) { }
/// ```
public struct SecondaryButton: View {

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
                        .tint(SpringColor.Object.primary)
                        .scaleEffect(0.8)
                } else {
                    if let icon {
                        icon.resizable().scaledToFit().frame(width: 16, height: 16)
                    }
                    Text(label)
                }
            }
            .font(SpringFont.prose(size: SpringFontSize.body, weight: .semibold))
            .foregroundStyle(SpringColor.Object.primary)
            .padding(.horizontal, SpringSpacing.Horizontal.lg)
            .padding(.vertical, SpringSpacing.Vertical.sm + 2)
            .frame(minHeight: SpringSpacing.minimumTapTarget)
            .frame(maxWidth: isFullWidth ? .infinity : nil)
            .background(.clear)
            .overlay(
                RoundedRectangle(cornerRadius: SpringSpacing.CornerRadius.sm)
                    .stroke(SpringColor.Object.primary, lineWidth: 1.5)
            )
        }
        .buttonStyle(SpringSecondaryButtonStyle())
        .disabled(isLoading)
        .accessibilityLabel(label)
        .accessibilityHint(isLoading ? "Loading" : "")
    }
}

private struct SpringSecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

// MARK: - Preview

#Preview("SecondaryButton") {
    VStack(spacing: SpringSpacing.Vertical.md) {
        SecondaryButton("View Menu") { }
        SecondaryButton("Edit Details", isLoading: true) { }
        SecondaryButton("Browse Gallery", isFullWidth: true) { }
    }
    .padding()
    .background(SpringColor.Background.primary)
}
