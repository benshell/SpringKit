import SwiftUI

/// A styled date and/or time picker for reservation and booking flows.
///
/// ```swift
/// @State private var date = Date()
///
/// SpringDatePicker(
///     label: "Reservation Date",
///     selection: $date,
///     components: .date,
///     range: Date()...
/// )
/// ```
public struct SpringDatePicker: View {

    private let label: String
    private let selection: Binding<Date>
    private let components: DatePickerComponents
    private let range: ClosedRange<Date>?
    private let displayedComponents: DatePickerComponents

    public init(
        label: String,
        selection: Binding<Date>,
        components: DatePickerComponents = [.date, .hourAndMinute],
        range: ClosedRange<Date>? = nil
    ) {
        self.label = label
        self.selection = selection
        self.components = components
        self.range = range
        self.displayedComponents = components
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: SpringSpacing.Vertical.xs) {
            Text(label)
                .font(SpringFont.prose(size: SpringFontSize.caption, weight: .medium))
                .foregroundStyle(SpringColor.Text.secondary)

            Group {
                if let range {
                    DatePicker(
                        label,
                        selection: selection,
                        in: range,
                        displayedComponents: displayedComponents
                    )
                } else {
                    DatePicker(
                        label,
                        selection: selection,
                        displayedComponents: displayedComponents
                    )
                }
            }
            .datePickerStyle(.compact)
            .labelsHidden()
            .font(SpringFont.prose(size: SpringFontSize.body))
            .tint(SpringColor.Object.primary)
            .padding(.horizontal, SpringSpacing.Horizontal.md)
            .padding(.vertical, SpringSpacing.Vertical.xs)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(minHeight: SpringSpacing.minimumTapTarget)
            .background(SpringColor.Background.surface)
            .clipShape(.rect(cornerRadius: SpringSpacing.CornerRadius.sm))
            .overlay(
                RoundedRectangle(cornerRadius: SpringSpacing.CornerRadius.sm)
                    .stroke(SpringColor.Object.border, lineWidth: 1)
            )
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(label)
    }
}

// MARK: - Preview

#Preview("SpringDatePicker") {
    @Previewable @State var date = Date()
    @Previewable @State var time = Date()

    VStack(spacing: SpringSpacing.Vertical.md) {
        SpringDatePicker(label: "Reservation Date", selection: $date, components: .date, range: Date()...)
        SpringDatePicker(label: "Arrival Time", selection: $time, components: .hourAndMinute)
    }
    .padding()
    .background(SpringColor.Background.primary)
}
