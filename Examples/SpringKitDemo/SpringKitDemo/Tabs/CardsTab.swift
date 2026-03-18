import SwiftUI
import SpringKit

struct CardsTab: View {
    @Environment(\.horizontalSizeClass) private var sizeClass
    @State private var orderQuantities: [String: Int] = [:]

    private var cardColumns: [GridItem] {
        if sizeClass == .regular {
            [GridItem(.flexible()), GridItem(.flexible())]
        } else {
            [GridItem(.flexible())]
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: SpringSpacing.Vertical.lg) {

                    // MARK: Booking Cards

                    SectionHeader(
                        title: "Reservations",
                        subtitle: "BookingCard — all status variants",
                        alignment: .leading
                    )
                    .padding(.horizontal, SpringSpacing.Horizontal.md)

                    LazyVGrid(columns: cardColumns, spacing: SpringSpacing.Vertical.md) {
                        ForEach(DemoContent.sampleBookings) { booking in
                            BookingCard(booking: booking) {}
                        }
                    }
                    .padding(.horizontal, SpringSpacing.Horizontal.md)

                    Divider()
                        .padding(.horizontal, SpringSpacing.Horizontal.md)

                    // MARK: Order Cards

                    SectionHeader(
                        title: "Menu",
                        subtitle: "OrderCard — with quantity controls",
                        alignment: .leading
                    )
                    .padding(.horizontal, SpringSpacing.Horizontal.md)

                    LazyVGrid(columns: cardColumns, spacing: SpringSpacing.Vertical.md) {
                        ForEach(DemoContent.menuItems) { item in
                            OrderCard(
                                item: item,
                                quantity: orderQuantities[item.id, default: 0],
                                onAdd: {
                                    orderQuantities[item.id, default: 0] += 1
                                },
                                onRemove: {
                                    if (orderQuantities[item.id] ?? 0) > 0 {
                                        orderQuantities[item.id]! -= 1
                                    }
                                }
                            )
                        }
                    }
                    .padding(.horizontal, SpringSpacing.Horizontal.md)

                    Divider()
                        .padding(.horizontal, SpringSpacing.Horizontal.md)

                    // MARK: Inquiry Cards

                    SectionHeader(
                        title: "Enquiries",
                        subtitle: "InquiryCard — all status variants",
                        alignment: .leading
                    )
                    .padding(.horizontal, SpringSpacing.Horizontal.md)

                    LazyVGrid(columns: cardColumns, spacing: SpringSpacing.Vertical.md) {
                        ForEach(DemoContent.sampleInquiries) { inquiry in
                            InquiryCard(inquiry: inquiry) {}
                        }
                    }
                    .padding(.horizontal, SpringSpacing.Horizontal.md)
                }
                .padding(.vertical, SpringSpacing.Vertical.md)
            }
            .navigationTitle("Cards")
        }
    }
}

#Preview {
    CardsTab()
}
