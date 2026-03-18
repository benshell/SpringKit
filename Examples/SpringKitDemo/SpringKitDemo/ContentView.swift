import SwiftUI
import SpringKit

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        SpringTabView(selection: $selectedTab) {
            Tab("Brochure", systemImage: "photo.artframe", value: 0) {
                BrochureTab()
            }
            Tab("Controls", systemImage: "hand.tap", value: 1) {
                ControlsTab()
            }
            Tab("Cards", systemImage: "rectangle.stack", value: 2) {
                CardsTab()
            }
            Tab("Feedback", systemImage: "bell", value: 3) {
                FeedbackTab()
            }
            Tab("Tokens", systemImage: "paintpalette", value: 4) {
                TokensTab()
            }
        }
    }
}
