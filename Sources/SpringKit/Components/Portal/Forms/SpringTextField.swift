import SwiftUI

/// A styled single-line text input with a floating label and optional error state.
///
/// ```swift
/// @State private var name = ""
/// @State private var nameError: String? = nil
///
/// SpringTextField(
///     label: "Full Name",
///     placeholder: "e.g. Sophie Williams",
///     text: $name,
///     error: nameError
/// )
/// ```
public struct SpringTextField: View {

    // MARK: - Properties

    private let label: String
    private let placeholder: String
    private let text: Binding<String>
    private let error: String?
    private let isSecure: Bool
    private let keyboardType: UIKeyboardType
    private let submitLabel: SubmitLabel
    private let onSubmit: (() -> Void)?

    @FocusState private var isFocused: Bool

    // MARK: - Init

    public init(
        label: String,
        placeholder: String = "",
        text: Binding<String>,
        error: String? = nil,
        isSecure: Bool = false,
        keyboardType: UIKeyboardType = .default,
        submitLabel: SubmitLabel = .done,
        onSubmit: (() -> Void)? = nil
    ) {
        self.label = label
        self.placeholder = placeholder
        self.text = text
        self.error = error
        self.isSecure = isSecure
        self.keyboardType = keyboardType
        self.submitLabel = submitLabel
        self.onSubmit = onSubmit
    }

    // MARK: - Body

    public var body: some View {
        VStack(alignment: .leading, spacing: SpringSpacing.Vertical.xs) {
            Text(label)
                .font(SpringFont.prose(size: SpringFontSize.caption, weight: .medium))
                .foregroundStyle(isFocused ? SpringColor.Object.primary : SpringColor.Text.secondary)
                .animation(.easeOut(duration: 0.15), value: isFocused)

            inputField
                .keyboardType(keyboardType)
                .submitLabel(submitLabel)
                .onSubmit { onSubmit?() }
                .focused($isFocused)
                .padding(.horizontal, SpringSpacing.Horizontal.md)
                .padding(.vertical, SpringSpacing.Vertical.sm + 2)
                .frame(minHeight: SpringSpacing.minimumTapTarget)
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
        .accessibilityHint(placeholder.isEmpty ? "" : "Placeholder: \(placeholder)")
    }

    @ViewBuilder
    private var inputField: some View {
        if isSecure {
            SecureField(placeholder, text: text)
                .font(SpringFont.prose(size: SpringFontSize.body))
                .foregroundStyle(SpringColor.Text.primary)
        } else {
            TextField(placeholder, text: text)
                .font(SpringFont.prose(size: SpringFontSize.body))
                .foregroundStyle(SpringColor.Text.primary)
        }
    }

    private var borderColor: Color {
        if error != nil { return SpringColor.Object.destructive }
        return isFocused ? SpringColor.Object.primary : SpringColor.Object.border
    }
}

// MARK: - Preview

#Preview("SpringTextField") {
    @Previewable @State var name = ""
    @Previewable @State var email = ""
    @Previewable @State var password = ""

    VStack(spacing: SpringSpacing.Vertical.md) {
        SpringTextField(label: "Full Name", placeholder: "e.g. Sophie Williams", text: $name)
        SpringTextField(label: "Email", placeholder: "your@email.com", text: $email, keyboardType: .emailAddress)
        SpringTextField(label: "Password", text: $password, isSecure: true)
        SpringTextField(label: "Phone", placeholder: "Enter phone number", text: $name, error: "Please enter a valid phone number")
    }
    .padding()
    .background(SpringColor.Background.primary)
}
