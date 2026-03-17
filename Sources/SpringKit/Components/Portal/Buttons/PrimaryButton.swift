import SwiftUI

/// Filled Forest-green button for primary confirmation actions.
///
/// ```swift
/// PrimaryButton("Confirm Booking", action: confirmBooking)
/// PrimaryButton("Submit", isLoading: true, action: {})
/// PrimaryButton("Continue", isFullWidth: true, action: next)
/// ```
public struct PrimaryButton: View {

    private let label: String
    private let icon: Image?
    private let isLoading: Bool
    private let isFullWidth: Bool
    private let isDestructive: Bool
    private let action: () -> Void

    public init(
        _ label: String,
        icon: Image? = nil,
        isLoading: Bool = false,
        isFullWidth: Bool = false,
        isDestructive: Bool = false,
        action: @escaping () -> Void
    ) {
        self.label = label
        self.icon = icon
        self.isLoading = isLoading
        self.isFullWidth = isFullWidth
        self.isDestructive = isDestructive
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            buttonContent
        }
        .buttonStyle(SpringPrimaryButtonStyle(isDestructive: isDestructive))
        .frame(maxWidth: isFullWidth ? .infinity : nil)
        .disabled(isLoading)
        .accessibilityLabel(label)
        .accessibilityHint(isLoading ? "Loading" : "")
    }

    private var buttonContent: some View {
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
    }
}

private struct SpringPrimaryButtonStyle: ButtonStyle {
    let isDestructive: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                isDestructive ? SpringColor.Object.destructive : SpringColor.Object.primary,
                in: .rect(cornerRadius: SpringSpacing.CornerRadius.sm)
            )
            .opacity(configuration.isPressed ? 0.85 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

// MARK: - Preview

#Preview("PrimaryButton") {
    VStack(spacing: SpringSpacing.Vertical.md) {
        PrimaryButton("Confirm Booking") { }
        PrimaryButton("Submit", isLoading: true) { }
        PrimaryButton("Continue", isFullWidth: true) { }
        PrimaryButton("Delete Reservation", isDestructive: true, action: { })
    }
    .padding()
    .background(SpringColor.Background.primary)
}
