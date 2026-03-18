import SwiftUI

/// A reservation summary card showing date, time, party size, venue/table, and status.
///
/// ```swift
/// BookingCard(booking: .init(
///     id: "BK-1042",
///     venueName: "The Rose Garden",
///     date: Date(),
///     partySize: 4,
///     status: .confirmed
/// ))
/// ```
public struct BookingCard: View {

    // MARK: - Data Model

    public struct Booking: Identifiable, Sendable {
        public var id: String
        public var venueName: String
        public var date: Date
        public var partySize: Int
        public var status: Status
        public var notes: String?

        public init(
            id: String,
            venueName: String,
            date: Date,
            partySize: Int,
            status: Status,
            notes: String? = nil
        ) {
            self.id = id
            self.venueName = venueName
            self.date = date
            self.partySize = partySize
            self.status = status
            self.notes = notes
        }
    }

    @frozen public enum Status: String, Sendable {
        case pending   = "Pending"
        case confirmed = "Confirmed"
        case cancelled = "Cancelled"
        case completed = "Completed"
    }

    // MARK: - Properties

    private let booking: Booking
    private let onTap: (() -> Void)?

    // MARK: - Init

    public init(booking: Booking, onTap: (() -> Void)? = nil) {
        self.booking = booking
        self.onTap = onTap
    }

    // MARK: - Formatters

    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .long
        return f
    }()

    private static let timeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.timeStyle = .short
        return f
    }()

    // MARK: - Body

    public var body: some View {
        Button {
            onTap?()
        } label: {
            VStack(alignment: .leading, spacing: SpringSpacing.Vertical.sm) {
                // Header
                HStack {
                    Text(booking.venueName)
                        .font(SpringFont.prose(size: SpringFontSize.subheading, weight: .semibold))
                        .foregroundStyle(SpringColor.Text.primary)

                    Spacer()

                    SpringBadge(booking.status.rawValue, style: badgeStyle)
                }

                Divider()
                    .overlay(SpringColor.Object.border)

                // Details grid
                HStack(spacing: SpringSpacing.Horizontal.xl) {
                    infoItem(
                        icon: "calendar",
                        label: "Date",
                        value: Self.dateFormatter.string(from: booking.date)
                    )

                    infoItem(
                        icon: "clock",
                        label: "Time",
                        value: Self.timeFormatter.string(from: booking.date)
                    )

                    infoItem(
                        icon: "person.2",
                        label: "Guests",
                        value: "\(booking.partySize)"
                    )
                }

                if let notes = booking.notes {
                    Text(notes)
                        .font(SpringFont.prose(size: SpringFontSize.caption))
                        .foregroundStyle(SpringColor.Text.muted)
                        .lineLimit(2)
                }

                Text("Ref: \(booking.id)")
                    .font(SpringFont.prose(size: SpringFontSize.caption))
                    .foregroundStyle(SpringColor.Text.muted)
            }
            .padding(SpringSpacing.Vertical.md)
            .background(SpringColor.Background.surface)
            .clipShape(.rect(cornerRadius: SpringSpacing.CornerRadius.lg))
            .overlay(
                RoundedRectangle(cornerRadius: SpringSpacing.CornerRadius.lg)
                    .stroke(SpringColor.Object.border, lineWidth: 1)
            )
            .shadow(color: SpringColor.Object.primary.opacity(0.05), radius: 8, x: 0, y: 3)
        }
        .buttonStyle(.plain)
        .disabled(onTap == nil)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityAddTraits(onTap != nil ? .isButton : [])
    }

    private func infoItem(icon: String, label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.caption)
                    .foregroundStyle(SpringColor.Object.secondary)
                Text(label)
                    .font(SpringFont.prose(size: SpringFontSize.caption))
                    .foregroundStyle(SpringColor.Text.muted)
            }
            Text(value)
                .font(SpringFont.prose(size: SpringFontSize.footnote, weight: .medium))
                .foregroundStyle(SpringColor.Text.primary)
        }
    }

    private var badgeStyle: SpringBadge.Style {
        switch booking.status {
        case .confirmed: .success
        case .pending:   .warning
        case .cancelled: .destructive
        case .completed: .neutral
        }
    }

    private var accessibilityLabel: String {
        "\(booking.venueName), \(booking.status.rawValue). \(Self.dateFormatter.string(from: booking.date)) at \(Self.timeFormatter.string(from: booking.date)), \(booking.partySize) guests."
    }
}

// MARK: - Preview

#Preview("BookingCard") {
    ScrollView {
        VStack(spacing: SpringSpacing.Vertical.md) {
            BookingCard(booking: .init(
                id: "BK-1042",
                venueName: "The Rose Garden",
                date: Calendar.current.date(byAdding: .day, value: 14, to: Date()) ?? Date(),
                partySize: 4,
                status: .confirmed,
                notes: "Window table requested. Champagne on arrival."
            ))

            BookingCard(booking: .init(
                id: "BK-1039",
                venueName: "Private Dining Room",
                date: Calendar.current.date(byAdding: .day, value: 3, to: Date()) ?? Date(),
                partySize: 12,
                status: .pending
            ))

            BookingCard(booking: .init(
                id: "BK-1031",
                venueName: "Cellar Terrace",
                date: Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date(),
                partySize: 2,
                status: .completed
            ))
        }
        .padding(SpringSpacing.Horizontal.md)
    }
    .background(SpringColor.Background.primary)
}
