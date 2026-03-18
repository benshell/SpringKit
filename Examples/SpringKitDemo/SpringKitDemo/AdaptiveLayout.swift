import SwiftUI

/// A view modifier that constrains content to a readable width on wide screens (iPad landscape).
/// On compact width (iPhone), content fills the available width as before.
private struct ReadableContentWidth: ViewModifier {
    @Environment(\.horizontalSizeClass) private var sizeClass

    var maxWidth: CGFloat

    func body(content: Content) -> some View {
        if sizeClass == .regular {
            content
                .frame(maxWidth: maxWidth)
                .frame(maxWidth: .infinity)
        } else {
            content
        }
    }
}

extension View {
    /// Constrains the view to a comfortable reading width on regular-width environments (iPad).
    /// On compact widths (iPhone), the view is unchanged.
    func readableContentWidth(_ maxWidth: CGFloat = 700) -> some View {
        modifier(ReadableContentWidth(maxWidth: maxWidth))
    }
}
