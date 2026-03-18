import XCTest

final class ScreenshotTests: XCTestCase {

    private let outputDir = "/tmp/springkit-screenshots"
    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testCaptureAllTabs() throws {
        // Allow the app to fully render
        sleep(2)

        let tabs: [(label: String, filename: String)] = [
            ("Brochure", "tab-brochure"),
            ("Controls", "tab-controls"),
            ("Cards",    "tab-cards"),
            ("Feedback", "tab-feedback"),
            ("Tokens",   "tab-tokens"),
        ]

        for (label, filename) in tabs {
            let tabButton = app.tabBars.buttons[label]
            XCTAssertTrue(tabButton.waitForExistence(timeout: 5))
            tabButton.tap()
            sleep(1)

            let screenshot = app.screenshot()
            let data = screenshot.pngRepresentation
            let url = URL(fileURLWithPath: "\(outputDir)/\(filename).png")
            try data.write(to: url)
        }
    }
}
