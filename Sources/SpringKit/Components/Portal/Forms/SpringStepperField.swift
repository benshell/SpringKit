import SwiftUI

/// A branded numeric stepper with label and optional bounds, for guest count
/// and quantity selection.
///
/// ```swift
/// @State private var guests = 2
///
/// SpringStepperField(label: "Number of Guests", value: $guests, range: 1...20)
/// ```
public struct SpringStepperField: View {

    private let label: String
    private let value: Binding<Int>
    private let range: ClosedRange<Int>
    private let step: Int
    private let unit: String?

    public init(
        label: String,
        value: Binding<Int>,
        range: ClosedRange<Int> = 1...99,
        step: Int = 1,
        unit: String? = nil
    ) {
        self.label = label
        self.value = value
        self.range = range
        self.step = step
        self.unit = unit
    }

    private var canDecrement: Bool { value.wrappedValue > range.lowerBound }
    private var canIncrement: Bool { value.wrappedValue < range.upperBound }

    public var body: some View {
        VStack(alignment: .leading, spacing: SpringSpacing.Vertical.xs) {
            Text(label)
                .font(SpringFont.prose(size: SpringFontSize.caption, weight: .medium))
                .foregroundStyle(SpringColor.Text.secondary)

            HStack {
                Text(valueLabel)
                    .font(SpringFont.prose(size: SpringFontSize.body, weight: .semibold))
                    .foregroundStyle(SpringColor.Text.primary)
                    .monospacedDigit()

                Spacer()

                HStack(spacing: SpringSpacing.Horizontal.xs) {
                    stepButton(icon: "minus", enabled: canDecrement) {
                        if canDecrement { value.wrappedValue -= step }
                    }

                    stepButton(icon: "plus", enabled: canIncrement) {
                        if canIncrement { value.wrappedValue += step }
                    }
                }
            }
            .padding(.horizontal, SpringSpacing.Horizontal.md)
            .frame(minHeight: SpringSpacing.minimumTapTarget)
            .background(SpringColor.Background.surface)
            .clipShape(.rect(cornerRadius: SpringSpacing.CornerRadius.sm))
            .overlay(
                RoundedRectangle(cornerRadius: SpringSpacing.CornerRadius.sm)
                    .stroke(SpringColor.Object.border, lineWidth: 1)
            )
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("\(label): \(valueLabel)")
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment: if canIncrement { value.wrappedValue += step }
            case .decrement: if canDecrement { value.wrappedValue -= step }
            @unknown default: break
            }
        }
    }

    private var valueLabel: String {
        if let unit { return "\(value.wrappedValue) \(unit)" }
        return "\(value.wrappedValue)"
    }

    private func stepButton(icon: String, enabled: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 14, height: 14)
                .foregroundStyle(enabled ? SpringColor.Object.primary : SpringColor.Object.border)
                .frame(width: SpringSpacing.minimumTapTarget, height: SpringSpacing.minimumTapTarget)
        }
        .disabled(!enabled)
        .accessibilityLabel(icon == "plus" ? "Increase \(label)" : "Decrease \(label)")
    }
}

// MARK: - Preview

#Preview("SpringStepperField") {
    @Previewable @State var guests = 2
    @Previewable @State var bottles = 1

    VStack(spacing: SpringSpacing.Vertical.md) {
        SpringStepperField(label: "Number of Guests", value: $guests, range: 1...30, unit: "guests")
        SpringStepperField(label: "Bottles of Wine", value: $bottles, range: 1...12, unit: "bottles")
    }
    .padding()
    .background(SpringColor.Background.primary)
}
