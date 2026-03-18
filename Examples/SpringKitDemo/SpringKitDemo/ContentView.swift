import SwiftUI
import SpringKit

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        SpringTabView(selection: $selectedTab) {
            BrochureTab()
                .springTab(icon: "photo.artframe", label: "Brochure", tag: 0)
            ControlsTab()
                .springTab(icon: "hand.tap", label: "Controls", tag: 1)
            CardsTab()
                .springTab(icon: "rectangle.stack", label: "Cards", tag: 2)
            FeedbackTab()
                .springTab(icon: "bell", label: "Feedback", tag: 3)
            TokensTab()
                .springTab(icon: "paintpalette", label: "Tokens", tag: 4)
        }
    }
}
