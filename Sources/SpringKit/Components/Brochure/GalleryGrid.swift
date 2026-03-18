import SwiftUI

/// An adaptive photo gallery grid.
///
/// Supports uniform (equal-height rows) and masonry-style (variable height) layouts.
/// Tapping an image fires the optional `onSelect` callback with the image index.
///
/// ```swift
/// GalleryGrid(images: galleryImages, columns: 2) { index in
///     // open lightbox at index
/// }
/// ```
public struct GalleryGrid: View {

    // MARK: - Layout

    @frozen public enum Layout: Sendable {
        /// All images displayed at the same fixed height.
        case uniform(imageHeight: CGFloat)
        /// Two-column masonry where images alternate between a taller and shorter height.
        case masonry
    }

    // MARK: - Properties

    private let images: [Image]
    private let columns: Int
    private let layout: Layout
    private let spacing: CGFloat
    private let onSelect: ((Int) -> Void)?

    // MARK: - Init

    /// - Parameters:
    ///   - images: Array of images to display.
    ///   - columns: Number of grid columns. Defaults to 2.
    ///   - layout: Grid layout mode. Defaults to `.uniform(imageHeight: 200)`.
    ///   - spacing: Gap between grid cells. Defaults to `SpringSpacing.Vertical.xs`.
    ///   - onSelect: Called with the tapped image's index.
    public init(
        images: [Image],
        columns: Int = 2,
        layout: Layout = .uniform(imageHeight: 200),
        spacing: CGFloat = SpringSpacing.Vertical.xs,
        onSelect: ((Int) -> Void)? = nil
    ) {
        self.images = images
        self.columns = max(1, columns)
        self.layout = layout
        self.spacing = spacing
        self.onSelect = onSelect
    }

    // MARK: - Body

    public var body: some View {
        let gridColumns = Array(repeating: GridItem(.flexible(), spacing: spacing), count: columns)

        LazyVGrid(columns: gridColumns, spacing: spacing) {
            ForEach(images.indices, id: \.self) { index in
                if let onSelect {
                    Button {
                        onSelect(index)
                    } label: {
                        imageCell(at: index)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Photo \(index + 1) of \(images.count)")
                } else {
                    imageCell(at: index)
                        .accessibilityLabel("Photo \(index + 1) of \(images.count)")
                }
            }
        }
    }

    @ViewBuilder
    private func imageCell(at index: Int) -> some View {
        let imageHeight: CGFloat = {
            switch layout {
            case .uniform(let h): return h
            case .masonry: return index % 3 == 0 ? 280 : 180
            }
        }()

        images[index]
            .resizable()
            .scaledToFill()
            .frame(height: imageHeight)
            .clipShape(.rect(cornerRadius: SpringSpacing.CornerRadius.sm))
    }
}

// MARK: - Preview

#Preview("GalleryGrid — Uniform") {
    ScrollView {
        GalleryGrid(
            images: (0..<6).map { _ in Image(systemName: "photo.fill") },
            columns: 2,
            layout: .uniform(imageHeight: 180)
        ) { index in
            print("Tapped image \(index)")
        }
        .padding(SpringSpacing.Horizontal.md)
    }
    .background(SpringColor.Background.primary)
}

#Preview("GalleryGrid — Masonry") {
    ScrollView {
        GalleryGrid(
            images: (0..<8).map { _ in Image(systemName: "photo.fill") },
            columns: 2,
            layout: .masonry
        )
        .padding(SpringSpacing.Horizontal.md)
    }
    .background(SpringColor.Background.primary)
}
