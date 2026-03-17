import SwiftUI

/// A branded tab bar using Liquid Glass material and SpringKit tokens.
///
/// Define tabs using ``SpringTab`` and embed in a ``SpringTabView``.
///
/// ```swift
/// @State private var selectedTab = 0
///
/// SpringTabView(selection: $selectedTab) {
///     EstateView()
///         .springTab(icon: "house", label: "Estate", tag: 0)
///     MenuView()
///         .springTab(icon: "fork.knife", label: "Menu", tag: 1)
///     BookingView()
///         .springTab(icon: "calendar", label: "Reserve", tag: 2)
///     AccountView()
///         .springTab(icon: "person", label: "Account", tag: 3)
/// }
/// ```
public struct SpringTabView<Content: View>: View {

    @Binding private var selection: Int
    private let content: Content

    public init(selection: Binding<Int>, @ViewBuilder content: () -> Content) {
        self._selection = selection
        self.content = content()
    }

    public var body: some View {
        TabView(selection: $selection) {
            content
        }
        .tabBarMinimizeBehavior(.onScrollDown)
        .tint(SpringColor.Object.primary)
    }
}

// MARK: - Tab Modifier

public extension View {

    /// Registers this view as a tab in a `SpringTabView`.
    func springTab(icon: String, label: String, tag: Int) -> some View {
        self.tabItem {
            Label(label, systemImage: icon)
        }
        .tag(tag)
    }
}

// MARK: - Preview

#Preview("SpringTabView") {
    @Previewable @State var tab = 0

    SpringTabView(selection: $tab) {
        VStack {
            Text("Estate")
                .font(SpringFont.prose(size: SpringFontSize.heading2, weight: .semibold))
                .foregroundStyle(SpringColor.Text.primary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(SpringColor.Background.primary)
        .springTab(icon: "house", label: "Estate", tag: 0)

        VStack {
            Text("Menu")
                .font(SpringFont.prose(size: SpringFontSize.heading2, weight: .semibold))
                .foregroundStyle(SpringColor.Text.primary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(SpringColor.Background.primary)
        .springTab(icon: "fork.knife", label: "Menu", tag: 1)

        VStack {
            Text("Reserve")
                .font(SpringFont.prose(size: SpringFontSize.heading2, weight: .semibold))
                .foregroundStyle(SpringColor.Text.primary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(SpringColor.Background.primary)
        .springTab(icon: "calendar", label: "Reserve", tag: 2)

        VStack {
            Text("Account")
                .font(SpringFont.prose(size: SpringFontSize.heading2, weight: .semibold))
                .foregroundStyle(SpringColor.Text.primary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(SpringColor.Background.primary)
        .springTab(icon: "person", label: "Account", tag: 3)
    }
}
