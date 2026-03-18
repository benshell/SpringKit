import SwiftUI
import SpringKit
import UIKit

/// Sample data and placeholder image utilities for the SpringKit demo app.
@MainActor
enum DemoContent {

    // MARK: - Placeholder Image Generation

    static func gradientImage(colors: [Color], width: CGFloat = 400, height: CGFloat = 500) -> Image {
        let view = LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
            .frame(width: width, height: height)
        let renderer = ImageRenderer(content: view)
        renderer.scale = 2
        return Image(uiImage: renderer.uiImage ?? UIImage())
    }

    // MARK: - Hero

    static var heroImage: Image {
        gradientImage(colors: [
            SpringColor.Object.primary,
            SpringColor.Object.secondary,
            SpringColor.Text.link,
        ])
    }

    // MARK: - Gallery Images

    static var galleryImages: [Image] {
        let palettes: [[Color]] = [
            [SpringColor.Object.secondary, SpringColor.Object.primary],
            [SpringColor.Object.accent, SpringColor.Object.champagne],
            [SpringColor.Object.champagne, SpringColor.Text.link],
            [SpringColor.Object.primary, SpringColor.Object.secondary],
            [SpringColor.Background.primary, SpringColor.Object.accent],
            [SpringColor.Text.link, SpringColor.Background.primary],
        ]
        return palettes.map { gradientImage(colors: $0, width: 300, height: 300) }
    }

    // MARK: - Feature Items

    struct Feature: Identifiable {
        let id = UUID()
        let icon: Image
        let title: String
        let description: String
    }

    static let features: [Feature] = [
        Feature(
            icon: Image(systemName: "wineglass.fill"),
            title: "Wine Cellar",
            description: "Over 400 curated labels from boutique vineyards across three continents."
        ),
        Feature(
            icon: Image(systemName: "fork.knife"),
            title: "Tasting Menu",
            description: "Seven-course seasonal menus crafted with estate-grown and local produce."
        ),
        Feature(
            icon: Image(systemName: "person.2.fill"),
            title: "Private Dining",
            description: "Intimate rooms for groups of 8–24, with bespoke menus on request."
        ),
        Feature(
            icon: Image(systemName: "leaf.fill"),
            title: "Estate Gardens",
            description: "Wander through 12 acres of landscaped gardens and working vineyards."
        ),
    ]

    // MARK: - Testimonials

    struct Testimonial: Identifiable {
        let id = UUID()
        let quote: String
        let name: String
        let subtitle: String?
        let rating: Int
    }

    static let testimonials: [Testimonial] = [
        Testimonial(
            quote: "An evening of absolute perfection. The tasting menu was a journey through seasons, and the service was impeccable.",
            name: "Sophie & James R.",
            subtitle: "Anniversary dinner, October",
            rating: 5
        ),
        Testimonial(
            quote: "We held our rehearsal dinner here and every detail was handled with such care. Our guests are still talking about it.",
            name: "Elara M.",
            subtitle: "Private event, June",
            rating: 5
        ),
    ]

    // MARK: - Bookings

    static var sampleBookings: [BookingCard.Booking] {
        let calendar = Calendar.current
        let now = Date()
        return [
            BookingCard.Booking(
                id: "BK-2026-1847",
                venueName: "The Cedar Room",
                date: calendar.date(byAdding: .day, value: 3, to: now)!,
                partySize: 4,
                status: .confirmed
            ),
            BookingCard.Booking(
                id: "BK-2026-1823",
                venueName: "Main Dining Room",
                date: calendar.date(byAdding: .day, value: -2, to: now)!,
                partySize: 2,
                status: .completed,
                notes: "Anniversary — champagne on arrival requested"
            ),
            BookingCard.Booking(
                id: "BK-2026-1801",
                venueName: "Terrace Garden",
                date: calendar.date(byAdding: .day, value: 10, to: now)!,
                partySize: 8,
                status: .pending
            ),
            BookingCard.Booking(
                id: "BK-2026-1788",
                venueName: "The Vaulted Cellar",
                date: calendar.date(byAdding: .day, value: -10, to: now)!,
                partySize: 6,
                status: .cancelled
            ),
        ]
    }

    // MARK: - Menu Items

    static var menuItems: [OrderCard.MenuItem] {
        [
            OrderCard.MenuItem(
                id: "MI-001",
                name: "Duck Confit",
                description: "48-hour confit leg, cherry gastrique, celeriac purée, crispy capers",
                price: 38.00,
                category: "Mains",
                image: gradientImage(
                    colors: [SpringColor.Object.primary, SpringColor.Object.accent],
                    width: 120, height: 120
                )
            ),
            OrderCard.MenuItem(
                id: "MI-002",
                name: "Saffron Risotto",
                description: "Carnaroli rice, estate saffron, aged parmesan, truffle oil",
                price: 28.00,
                category: "Mains",
                image: gradientImage(
                    colors: [SpringColor.Object.champagne, SpringColor.Background.accent],
                    width: 120, height: 120
                )
            ),
            OrderCard.MenuItem(
                id: "MI-003",
                name: "Lavender Panna Cotta",
                description: "Estate lavender infusion, honey tuile, compressed strawberries",
                price: 14.00,
                category: "Desserts",
                image: gradientImage(
                    colors: [SpringColor.Text.muted, SpringColor.Object.border],
                    width: 120, height: 120
                ),
                isAvailable: false
            ),
        ]
    }

    // MARK: - Inquiries

    static var sampleInquiries: [InquiryCard.Inquiry] {
        let now = Date()
        let calendar = Calendar.current
        return [
            InquiryCard.Inquiry(
                id: "INQ-2026-0412",
                subject: "Wedding Reception — Summer 2027",
                message: "We are looking to host our wedding reception for approximately 120 guests. Could you send through your packages and pricing?",
                submittedAt: calendar.date(byAdding: .day, value: -1, to: now)!,
                status: .inReview
            ),
            InquiryCard.Inquiry(
                id: "INQ-2026-0398",
                subject: "Corporate Retreat Catering",
                message: "We need catering for a 2-day off-site for 40 people. Dietary requirements will be varied.",
                submittedAt: calendar.date(byAdding: .day, value: -5, to: now)!,
                status: .responded,
                respondedAt: calendar.date(byAdding: .day, value: -3, to: now)!
            ),
            InquiryCard.Inquiry(
                id: "INQ-2026-0371",
                subject: "Wine Pairing Dinner Tickets",
                message: "Are there still tickets available for the March wine pairing evening?",
                submittedAt: calendar.date(byAdding: .day, value: -14, to: now)!,
                status: .closed,
                respondedAt: calendar.date(byAdding: .day, value: -13, to: now)!
            ),
        ]
    }
}
