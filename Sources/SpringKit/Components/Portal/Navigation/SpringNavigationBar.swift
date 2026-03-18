import SwiftUI

/// A custom navigation bar with optional accent-font title, configurable
/// leading and trailing toolbar items, and a Liquid Glass background.
///
/// Apply via the `.springNavigationBar(...)` modifier rather than constructing
/// the bar directly.
///
/// ```swift
/// NavigationStack {
///     MenuView()
///         .springNavigationTitle("The Estate", useAccentFont: true)
///         .toolbar {
///             ToolbarItem(placement: .topBarTrailing) {
///                 Button("Book") { startBooking() }
///             }
///         }
/// }
/// ```
///
/// Alternatively, for fully custom bars in non-NavigationStack contexts:
///
/// ```swift
/// SpringNavigationBar(
///     title: "Our Story",
///     useAccentFont: false,
///     showBackButton: true,
///     backAction: { dismiss() }
/// )
/// ```
public struct SpringNavigationBar<Trailing: View>: View {

    // MARK: - Properties

    private let title: String
    private let useAccentFont: Bool
    private let showBackButton: Bool
    private let backAction: (() -> Void)?
    private let trailingContent: Trailing?

    // MARK: - Init

    public init(
        title: String,
        useAccentFont: Bool = false,
        showBackButton: Bool = false,
        backAction: (() -> Void)? = nil,
        @ViewBuilder trailingContent: () -> Trailing
    ) {
        self.title = title
        self.useAccentFont = useAccentFont
        self.showBackButton = showBackButton
        self.backAction = backAction
        self.trailingContent = trailingContent()
    }

    // MARK: - Body

    public var body: some View {
        HStack(spacing: SpringSpacing.Horizontal.sm) {
            if showBackButton {
                Button {
                    backAction?()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.body.weight(.semibold))
                        .foregroundStyle(SpringColor.Object.primary)
                        .frame(width: SpringSpacing.minimumTapTarget, height: SpringSpacing.minimumTapTarget)
                }
                .accessibilityLabel("Back")
            }

            Text(title)
                .font(
                    useAccentFont
                        ? SpringFont.accent(size: SpringFontSize.heading2)
                        : SpringFont.prose(size: SpringFontSize.heading3, weight: .semibold)
                )
                .foregroundStyle(SpringColor.Text.primary)
                .frame(maxWidth: .infinity, alignment: showBackButton ? .center : .leading)

            if let trailing = trailingContent {
                trailing
            } else if showBackButton {
                // Balance the back button width so the title is truly centered
                Color.clear
                    .frame(width: SpringSpacing.minimumTapTarget, height: SpringSpacing.minimumTapTarget)
            }
        }
        .padding(.horizontal, SpringSpacing.Horizontal.md)
        .frame(height: 56)
        .glassEffect(.regular, in: .rect)
        .accessibilityElement(children: .contain)
        .accessibilityAddTraits(.isHeader)
    }
}

// MARK: - Convenience Init (no trailing content)

public extension SpringNavigationBar where Trailing == EmptyView {

    init(
        title: String,
        useAccentFont: Bool = false,
        showBackButton: Bool = false,
        backAction: (() -> Void)? = nil
    ) {
        self.title = title
        self.useAccentFont = useAccentFont
        self.showBackButton = showBackButton
        self.backAction = backAction
        self.trailingContent = nil
    }
}

// MARK: - View Modifier

public extension View {

    /// Sets the navigation title using SpringKit typography, with an optional
    /// accent (Great Vibes) font treatment. Applies to `NavigationStack` inline display.
    func springNavigationTitle(_ title: String, useAccentFont: Bool = false) -> some View {
        self
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(useAccentFont ? .large : .inline)
    }
}

// MARK: - Preview

#Preview("SpringNavigationBar") {
    VStack(spacing: 0) {
        SpringNavigationBar(
            title: "The Estate",
            useAccentFont: true,
            showBackButton: false
        ) {
            Button("Book") { }
                .font(SpringFont.prose(size: SpringFontSize.body, weight: .semibold))
                .foregroundStyle(SpringColor.Object.primary)
        }

        SpringNavigationBar(
            title: "Our Menu",
            useAccentFont: false,
            showBackButton: true,
            backAction: { }
        )

        Spacer()
    }
    .background(SpringColor.Background.primary)
}
