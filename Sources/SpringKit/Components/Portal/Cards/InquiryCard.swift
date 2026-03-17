import SwiftUI

/// A submitted inquiry summary card with reference number, status badge, and timestamp.
///
/// ```swift
/// InquiryCard(inquiry: .init(
///     id: "INQ-0291",
///     subject: "Wedding Reception — August 2026",
///     message: "We're interested in hosting our ceremony and reception…",
///     submittedAt: Date(),
///     status: .inReview
/// ))
/// ```
public struct InquiryCard: View {

    // MARK: - Data Model

    public struct Inquiry: Identifiable {
        public var id: String
        public var subject: String
        public var message: String
        public var submittedAt: Date
        public var status: Status
        public var respondedAt: Date?

        public init(
            id: String,
            subject: String,
            message: String,
            submittedAt: Date,
            status: Status,
            respondedAt: Date? = nil
        ) {
            self.id = id
            self.subject = subject
            self.message = message
            self.submittedAt = submittedAt
            self.status = status
            self.respondedAt = respondedAt
        }
    }

    public enum Status: String {
        case submitted  = "Submitted"
        case inReview   = "In Review"
        case responded  = "Responded"
        case closed     = "Closed"
    }

    // MARK: - Properties

    private let inquiry: Inquiry
    private let onTap: (() -> Void)?

    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .short
        return f
    }()

    public init(inquiry: Inquiry, onTap: (() -> Void)? = nil) {
        self.inquiry = inquiry
        self.onTap = onTap
    }

    // MARK: - Body

    public var body: some View {
        Button {
            onTap?()
        } label: {
            VStack(alignment: .leading, spacing: SpringSpacing.Vertical.sm) {
                // Header
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(inquiry.subject)
                            .font(SpringFont.prose(size: SpringFontSize.callout, weight: .semibold))
                            .foregroundStyle(SpringColor.Text.primary)
                            .lineLimit(2)

                        Text("Ref: \(inquiry.id)")
                            .font(SpringFont.prose(size: SpringFontSize.caption))
                            .foregroundStyle(SpringColor.Text.muted)
                    }

                    Spacer()

                    SpringBadge(inquiry.status.rawValue, style: badgeStyle)
                }

                // Message preview
                Text(inquiry.message)
                    .font(SpringFont.prose(size: SpringFontSize.footnote))
                    .foregroundStyle(SpringColor.Text.secondary)
                    .lineLimit(3)

                // Timestamps
                HStack {
                    Label(
                        "Submitted " + Self.dateFormatter.string(from: inquiry.submittedAt),
                        systemImage: "paperplane"
                    )
                    .font(SpringFont.prose(size: SpringFontSize.caption))
                    .foregroundStyle(SpringColor.Text.muted)
                    .labelStyle(.titleAndIcon)

                    if let responded = inquiry.respondedAt {
                        Spacer()
                        Label(
                            "Replied " + Self.dateFormatter.string(from: responded),
                            systemImage: "arrowshape.turn.up.left"
                        )
                        .font(SpringFont.prose(size: SpringFontSize.caption))
                        .foregroundStyle(SpringColor.Text.link)
                        .labelStyle(.titleAndIcon)
                    }
                }
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
        .accessibilityLabel("\(inquiry.subject), \(inquiry.status.rawValue). Submitted \(Self.dateFormatter.string(from: inquiry.submittedAt))")
        .accessibilityAddTraits(onTap != nil ? .isButton : [])
    }

    private var badgeStyle: SpringBadge.Style {
        switch inquiry.status {
        case .submitted: .neutral
        case .inReview:  .warning
        case .responded: .success
        case .closed:    .neutral
        }
    }
}

// MARK: - Preview

#Preview("InquiryCard") {
    ScrollView {
        VStack(spacing: SpringSpacing.Vertical.md) {
            InquiryCard(inquiry: .init(
                id: "INQ-0291",
                subject: "Wedding Reception — August 2026",
                message: "We're interested in hosting our wedding ceremony and reception at the estate. Our guest list is approximately 80 people.",
                submittedAt: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(),
                status: .inReview
            ))

            InquiryCard(inquiry: .init(
                id: "INQ-0284",
                subject: "Corporate Dinner for 20",
                message: "Planning a private dining experience for our leadership team.",
                submittedAt: Calendar.current.date(byAdding: .day, value: -10, to: Date()) ?? Date(),
                status: .responded,
                respondedAt: Calendar.current.date(byAdding: .day, value: -8, to: Date())
            ))
        }
        .padding(SpringSpacing.Horizontal.md)
    }
    .background(SpringColor.Background.primary)
}
