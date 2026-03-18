import SwiftUI

/// A transient floating message overlay that auto-dismisses after a duration.
///
/// Present using the `.springToast(...)` view modifier on a root view.
///
/// ```swift
/// @State private var toast: SpringToast.Message? = nil
///
/// ContentView()
///     .springToast($toast)
///
/// // Trigger a toast:
/// toast = .init("Booking confirmed!", style: .success)
/// ```
public struct SpringToast: View {

    // MARK: - Message Model

    public struct Message: Equatable, Sendable {
        public var text: String
        public var style: Style
        public var duration: TimeInterval

        public init(
            _ text: String,
            style: Style = .info,
            duration: TimeInterval = 3.0
        ) {
            self.text = text
            self.style = style
            self.duration = duration
        }
    }

    // MARK: - Style

    @frozen public enum Style: Sendable {
        case success
        case info
        case warning
        case error
    }

    // MARK: - Properties

    private let message: Message

    public init(_ message: Message) {
        self.message = message
    }

    // MARK: - Body

    public var body: some View {
        HStack(spacing: SpringSpacing.Horizontal.sm) {
            Image(systemName: message.style.icon)
                .foregroundStyle(message.style.iconColor)
                .accessibilityHidden(true)

            Text(message.text)
                .font(SpringFont.prose(size: SpringFontSize.footnote, weight: .medium))
                .foregroundStyle(SpringColor.Text.inverted)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, SpringSpacing.Horizontal.md)
        .padding(.vertical, SpringSpacing.Vertical.sm)
        .background(.regularMaterial)
        .background(Color.black.opacity(0.72))
        .clipShape(.capsule)
        .shadow(color: .black.opacity(0.2), radius: 12, x: 0, y: 4)
        .accessibilityLabel(message.text)
        .accessibilityAddTraits(.isStaticText)
    }
}

// MARK: - View Modifier

public extension View {

    /// Presents a `SpringToast` message over the modified view.
    ///
    /// The toast auto-dismisses after `message.duration` seconds.
    /// Set the binding to `nil` to dismiss manually.
    func springToast(_ message: Binding<SpringToast.Message?>) -> some View {
        self.modifier(SpringToastModifier(message: message))
    }
}

private struct SpringToastModifier: ViewModifier {
    @Binding var message: SpringToast.Message?
    @Environment(\.accessibilityVoiceOverEnabled) private var voiceOverEnabled

    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content

            if let msg = message {
                SpringToast(msg)
                    .padding(.bottom, SpringSpacing.Vertical.xl)
                    .padding(.horizontal, SpringSpacing.Horizontal.lg)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .task(id: msg) {
                        // Give VoiceOver users extra time to hear the announcement
                        let delay = voiceOverEnabled ? msg.duration * 2.5 : msg.duration
                        try? await Task.sleep(for: .seconds(delay))
                        withAnimation(.easeOut(duration: 0.25)) {
                            message = nil
                        }
                    }
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: message)
    }
}

// MARK: - Style Properties

private extension SpringToast.Style {
    var icon: String {
        switch self {
        case .success: "checkmark.circle.fill"
        case .info:    "info.circle.fill"
        case .warning: "exclamationmark.triangle.fill"
        case .error:   "xmark.circle.fill"
        }
    }

    var iconColor: Color {
        switch self {
        case .success: SpringColor.Object.secondary
        case .info:    SpringColor.Object.primary.opacity(0.7)
        case .warning: SpringColor.Object.accent
        case .error:   SpringColor.Object.destructive
        }
    }
}

// MARK: - Preview

#Preview("SpringToast") {
    @Previewable @State var toast: SpringToast.Message? = .init("Booking confirmed!", style: .success)

    VStack {
        Spacer()
        Button("Show Toast") {
            toast = .init("Reservation added to your account.", style: .success)
        }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(SpringColor.Background.primary)
    .springToast($toast)
}
