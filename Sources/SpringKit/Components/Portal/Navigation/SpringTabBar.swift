import SwiftUI

/// A branded tab bar using Liquid Glass material and SpringKit tokens.
///
/// Uses the modern `Tab` initializer with generic `Hashable` selection.
///
/// ```swift
/// enum AppTab: Hashable {
///     case estate, menu, reserve, account
/// }
///
/// @State private var selectedTab: AppTab = .estate
///
/// SpringTabView(selection: $selectedTab) {
///     Tab("Estate", systemImage: "house", value: .estate) {
///         EstateView()
///     }
///     Tab("Menu", systemImage: "fork.knife", value: .menu) {
///         MenuView()
///     }
///     Tab("Reserve", systemImage: "calendar", value: .reserve) {
///         BookingView()
///     }
///     Tab("Account", systemImage: "person", value: .account) {
///         AccountView()
///     }
/// }
/// ```
public struct SpringTabView<SelectionValue: Hashable, C: TabContent>: View
where C.TabValue == SelectionValue {

    @Binding private var selection: SelectionValue
    private let content: C

    public init(
        selection: Binding<SelectionValue>,
        @TabContentBuilder<SelectionValue> content: () -> C
    ) {
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

// MARK: - Preview

private enum PreviewTab: Hashable {
    case estate, menu, reserve, account
}

#Preview("SpringTabView") {
    @Previewable @State var tab: PreviewTab = .estate

    SpringTabView(selection: $tab) {
        Tab("Estate", systemImage: "house", value: .estate) {
            VStack {
                Text("Estate")
                    .font(SpringFont.prose(size: SpringFontSize.heading2, weight: .semibold))
                    .foregroundStyle(SpringColor.Text.primary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(SpringColor.Background.primary)
        }

        Tab("Menu", systemImage: "fork.knife", value: .menu) {
            VStack {
                Text("Menu")
                    .font(SpringFont.prose(size: SpringFontSize.heading2, weight: .semibold))
                    .foregroundStyle(SpringColor.Text.primary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(SpringColor.Background.primary)
        }

        Tab("Reserve", systemImage: "calendar", value: .reserve) {
            VStack {
                Text("Reserve")
                    .font(SpringFont.prose(size: SpringFontSize.heading2, weight: .semibold))
                    .foregroundStyle(SpringColor.Text.primary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(SpringColor.Background.primary)
        }

        Tab("Account", systemImage: "person", value: .account) {
            VStack {
                Text("Account")
                    .font(SpringFont.prose(size: SpringFontSize.heading2, weight: .semibold))
                    .foregroundStyle(SpringColor.Text.primary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(SpringColor.Background.primary)
        }
    }
}
