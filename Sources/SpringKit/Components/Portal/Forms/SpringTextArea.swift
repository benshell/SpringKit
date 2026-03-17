import SwiftUI

/// A styled multi-line text input for inquiry messages, notes, and special requests.
///
/// ```swift
/// @State private var notes = ""
///
/// SpringTextArea(
///     label: "Special Requests",
///     placeholder: "Dietary requirements, seating preferences…",
///     text: $notes
/// )
/// ```
public struct SpringTextArea: View {

    private let label: String
    private let placeholder: String
    private let text: Binding<String>
    private let error: String?
    private let minHeight: CGFloat
    private let maxHeight: CGFloat

    @FocusState private var isFocused: Bool

    public init(
        label: String,
        placeholder: String = "",
        text: Binding<String>,
        error: String? = nil,
        minHeight: CGFloat = 120,
        maxHeight: CGFloat = 280
    ) {
        self.label = label
        self.placeholder = placeholder
        self.text = text
        self.error = error
        self.minHeight = minHeight
        self.maxHeight = maxHeight
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: SpringSpacing.Vertical.xs) {
            Text(label)
                .font(SpringFont.prose(size: SpringFontSize.caption, weight: .medium))
                .foregroundStyle(isFocused ? SpringColor.Object.primary : SpringColor.Text.secondary)
                .animation(.easeOut(duration: 0.15), value: isFocused)

            ZStack(alignment: .topLeading) {
                if text.wrappedValue.isEmpty {
                    Text(placeholder)
                        .font(SpringFont.prose(size: SpringFontSize.body))
                        .foregroundStyle(SpringColor.Text.muted)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 8)
                        .allowsHitTesting(false)
                        .accessibilityHidden(true)
                }

                TextEditor(text: text)
                    .font(SpringFont.prose(size: SpringFontSize.body))
                    .foregroundStyle(SpringColor.Text.primary)
                    .scrollContentBackground(.hidden)
                    .focused($isFocused)
                    .frame(minHeight: minHeight, maxHeight: maxHeight)
            }
            .padding(.horizontal, SpringSpacing.Horizontal.sm)
            .padding(.vertical, SpringSpacing.Vertical.xs)
            .background(SpringColor.Background.surface)
            .clipShape(.rect(cornerRadius: SpringSpacing.CornerRadius.sm))
            .overlay(
                RoundedRectangle(cornerRadius: SpringSpacing.CornerRadius.sm)
                    .stroke(borderColor, lineWidth: isFocused ? 1.5 : 1)
            )

            if let error {
                Text(error)
                    .font(SpringFont.prose(size: SpringFontSize.caption))
                    .foregroundStyle(SpringColor.Object.destructive)
                    .accessibilityLabel("Error: \(error)")
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(label)
    }

    private var borderColor: Color {
        if error != nil { return SpringColor.Object.destructive }
        return isFocused ? SpringColor.Object.primary : SpringColor.Object.border
    }
}

// MARK: - Preview

#Preview("SpringTextArea") {
    @Previewable @State var notes = ""

    VStack(spacing: SpringSpacing.Vertical.md) {
        SpringTextArea(
            label: "Special Requests",
            placeholder: "Dietary requirements, seating preferences, occasion details…",
            text: $notes
        )
        SpringTextArea(
            label: "Inquiry Message",
            placeholder: "Tell us about your event…",
            text: $notes,
            error: "Message is required"
        )
    }
    .padding()
    .background(SpringColor.Background.primary)
}
