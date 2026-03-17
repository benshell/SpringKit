import SwiftUI

/// A menu item or order line card with image, name, description, price,
/// and an add-to-order action.
///
/// ```swift
/// OrderCard(item: .init(
///     id: "M-001",
///     name: "Seared Duck Breast",
///     description: "Cherry jus, celeriac purée, seasonal greens",
///     price: 38.00,
///     category: "Main Course"
/// )) {
///     addToOrder(item)
/// }
/// ```
public struct OrderCard: View {

    // MARK: - Data Model

    public struct MenuItem: Identifiable {
        public var id: String
        public var name: String
        public var description: String
        public var price: Decimal
        public var category: String?
        public var image: Image?
        public var isAvailable: Bool
        public var currency: String

        public init(
            id: String,
            name: String,
            description: String,
            price: Decimal,
            category: String? = nil,
            image: Image? = nil,
            isAvailable: Bool = true,
            currency: String = "USD"
        ) {
            self.id = id
            self.name = name
            self.description = description
            self.price = price
            self.category = category
            self.image = image
            self.isAvailable = isAvailable
            self.currency = currency
        }
    }

    // MARK: - Properties

    private let item: MenuItem
    private let quantity: Int
    private let onAdd: (() -> Void)?
    private let onRemove: (() -> Void)?

    public init(
        item: MenuItem,
        quantity: Int = 0,
        onAdd: (() -> Void)? = nil,
        onRemove: (() -> Void)? = nil
    ) {
        self.item = item
        self.quantity = quantity
        self.onAdd = onAdd
        self.onRemove = onRemove
    }

    // MARK: - Body

    public var body: some View {
        HStack(alignment: .top, spacing: SpringSpacing.Horizontal.md) {
            if let image = item.image {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 90, height: 90)
                    .clipShape(.rect(cornerRadius: SpringSpacing.CornerRadius.sm))
                    .accessibilityHidden(true)
            }

            VStack(alignment: .leading, spacing: SpringSpacing.Vertical.xs) {
                if let category = item.category {
                    Text(category.uppercased())
                        .font(SpringFont.prose(size: SpringFontSize.caption, weight: .semibold))
                        .foregroundStyle(SpringColor.Text.muted)
                        .kerning(0.5)
                }

                Text(item.name)
                    .font(SpringFont.prose(size: SpringFontSize.callout, weight: .semibold))
                    .foregroundStyle(SpringColor.Text.primary)

                Text(item.description)
                    .font(SpringFont.prose(size: SpringFontSize.footnote))
                    .foregroundStyle(SpringColor.Text.secondary)
                    .lineLimit(2)

                HStack {
                    Text(priceFormatted)
                        .font(SpringFont.prose(size: SpringFontSize.body, weight: .semibold))
                        .foregroundStyle(SpringColor.Text.primary)

                    Spacer()

                    if item.isAvailable {
                        quantityControl
                    } else {
                        Text("Unavailable")
                            .font(SpringFont.prose(size: SpringFontSize.caption, weight: .medium))
                            .foregroundStyle(SpringColor.Text.muted)
                    }
                }
            }
        }
        .padding(SpringSpacing.Vertical.md)
        .background(SpringColor.Background.surface)
        .clipShape(.rect(cornerRadius: SpringSpacing.CornerRadius.md))
        .overlay(
            RoundedRectangle(cornerRadius: SpringSpacing.CornerRadius.md)
                .stroke(SpringColor.Object.border, lineWidth: 1)
        )
        .opacity(item.isAvailable ? 1 : 0.6)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(item.name), \(priceFormatted)\(item.isAvailable ? "" : ", unavailable")")
    }

    private var priceFormatted: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = item.currency
        return formatter.string(from: item.price as NSDecimalNumber) ?? "\(item.price)"
    }

    @ViewBuilder
    private var quantityControl: some View {
        if quantity > 0 {
            HStack(spacing: 0) {
                Button {
                    onRemove?()
                } label: {
                    Image(systemName: "minus")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(SpringColor.Object.primary)
                        .frame(width: 32, height: 32)
                }
                .accessibilityLabel("Remove one \(item.name)")

                Text("\(quantity)")
                    .font(SpringFont.prose(size: SpringFontSize.footnote, weight: .semibold))
                    .foregroundStyle(SpringColor.Text.primary)
                    .frame(minWidth: 24)
                    .monospacedDigit()

                Button {
                    onAdd?()
                } label: {
                    Image(systemName: "plus")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(SpringColor.Text.inverted)
                        .frame(width: 32, height: 32)
                        .background(SpringColor.Object.primary, in: .circle)
                }
                .accessibilityLabel("Add one more \(item.name)")
            }
        } else {
            Button {
                onAdd?()
            } label: {
                Image(systemName: "plus")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(SpringColor.Text.inverted)
                    .frame(width: 32, height: 32)
                    .background(SpringColor.Object.primary, in: .circle)
            }
            .accessibilityLabel("Add \(item.name) to order")
        }
    }
}

// MARK: - Preview

#Preview("OrderCard") {
    @Previewable @State var quantity = 0

    ScrollView {
        VStack(spacing: SpringSpacing.Vertical.sm) {
            OrderCard(
                item: .init(
                    id: "M-001",
                    name: "Seared Duck Breast",
                    description: "Cherry jus, celeriac purée, roasted seasonal greens, potato galette",
                    price: 38.00,
                    category: "Main Course"
                ),
                quantity: quantity,
                onAdd: { quantity += 1 },
                onRemove: { if quantity > 0 { quantity -= 1 } }
            )

            OrderCard(
                item: .init(
                    id: "M-002",
                    name: "Chardonnay Reserve",
                    description: "Estate grown, barrel fermented — notes of stone fruit and toasted oak",
                    price: 22.00,
                    category: "Wine",
                    isAvailable: false
                )
            )
        }
        .padding(SpringSpacing.Horizontal.md)
    }
    .background(SpringColor.Background.primary)
}
