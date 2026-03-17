import SwiftUI

/// A styled date and/or time picker for reservation and booking flows.
///
/// ```swift
/// @State private var date = Date()
///
/// // Minimum date only (open-ended future)
/// SpringDatePicker(
///     label: "Reservation Date",
///     selection: $date,
///     components: .date,
///     minimumDate: Date()
/// )
///
/// // Bounded range
/// SpringDatePicker(
///     label: "Check-in",
///     selection: $date,
///     minimumDate: Date(),
///     maximumDate: Calendar.current.date(byAdding: .year, value: 1, to: Date())
/// )
/// ```
public struct SpringDatePicker: View {

    private let label: String
    private let selection: Binding<Date>
    private let components: DatePickerComponents
    private let minimumDate: Date?
    private let maximumDate: Date?

    public init(
        label: String,
        selection: Binding<Date>,
        components: DatePickerComponents = [.date, .hourAndMinute],
        minimumDate: Date? = nil,
        maximumDate: Date? = nil
    ) {
        self.label = label
        self.selection = selection
        self.components = components
        self.minimumDate = minimumDate
        self.maximumDate = maximumDate
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: SpringSpacing.Vertical.xs) {
            Text(label)
                .font(SpringFont.prose(size: SpringFontSize.caption, weight: .medium))
                .foregroundStyle(SpringColor.Text.secondary)

            datePicker
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

    @ViewBuilder
    private var datePicker: some View {
        if let min = minimumDate, let max = maximumDate {
            DatePicker(label, selection: selection, in: min...max, displayedComponents: components)
        } else if let min = minimumDate {
            DatePicker(label, selection: selection, in: min..., displayedComponents: components)
        } else if let max = maximumDate {
            DatePicker(label, selection: selection, in: ...max, displayedComponents: components)
        } else {
            DatePicker(label, selection: selection, displayedComponents: components)
        }
    }
}

// MARK: - Preview

#Preview("SpringDatePicker") {
    @Previewable @State var date = Date()
    @Previewable @State var time = Date()

    VStack(spacing: SpringSpacing.Vertical.md) {
        SpringDatePicker(label: "Reservation Date", selection: $date, components: .date, minimumDate: Date())
        SpringDatePicker(label: "Arrival Time", selection: $time, components: .hourAndMinute)
    }
    .padding()
    .background(SpringColor.Background.primary)
}
