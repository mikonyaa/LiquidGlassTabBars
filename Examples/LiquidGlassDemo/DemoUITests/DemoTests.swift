import XCTest

@MainActor
final class DemoTests: XCTestCase {
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    func testProgressAndActions() {
        let app = XCUIApplication()
        app.launchArguments = ["--floating", "-AppleLanguages", "(en)", "-AppleLocale", "en_US"]
        app.launch()
        let progress = app.descendants(matching: .any)["Sample progress"].firstMatch
        XCTAssertTrue(progress.waitForExistence(timeout: 5))
        XCTAssertEqual(progress.value as? String, "60%")
        app.buttons["Create"].tap()
        XCTAssertTrue(app.textFields["Sample title"].waitForExistence(timeout: 3))
        app.textFields["Sample title"].tap()
        app.textFields["Sample title"].typeText("A local example")
        app.buttons["Save sample"].tap()
        XCTAssertTrue(app.staticTexts["A local example"].waitForExistence(timeout: 3))
        app.buttons["Create"].tap()
        app.buttons["Cancel"].tap()
        XCTAssertFalse(app.textFields["Sample title"].exists)
        app.buttons["Focus"].tap()
        XCTAssertTrue(app.staticTexts["Focus preview is on"].exists)
        app.buttons["End focus"].tap()
        XCTAssertTrue(app.staticTexts["Focus preview is off"].exists)
        app.buttons["Share"].tap()
        let share = app.otherElements["ActivityListView"]
        XCTAssertTrue(share.waitForExistence(timeout: 5), app.debugDescription)
        let caption = share.descendants(matching: .any).matching(NSPredicate(
            format: "label CONTAINS %@", "3 of 5 sample items complete (60%)"
        )).firstMatch
        XCTAssertTrue(caption.waitForExistence(timeout: 5), share.debugDescription)
        XCTAssertTrue(caption.label.contains("60%"))
        if app.buttons["Close"].exists {
            app.buttons["Close"].tap()
        } else {
            app.otherElements["PopoverDismissRegion"]
                .coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.2)).tap()
        }
        XCTAssertFalse(share.exists)
        XCTAssertTrue(app.buttons["Create"].isHittable)
    }

    func testRapidPresentationChanges() {
        AccessibilitySettings.setReducedEffects(false)
        let app = XCUIApplication()
        app.launchArguments = ["-AppleLanguages", "(en)", "-AppleLocale", "en_US"]
        app.launch()
        for style in ["Floating", "Morphing", "System", "Floating", "Morphing"] {
            let menu = app.buttons["Tab bar style"]
            let screenshot = XCTAttachment(screenshot: app.screenshot())
            screenshot.lifetime = .keepAlways
            add(screenshot)
            XCTAssertTrue(menu.waitForExistence(timeout: 5), app.debugDescription)
            XCTAssertTrue(menu.isHittable, app.debugDescription)
            XCTAssertGreaterThanOrEqual(menu.frame.height, 44)
            menu.tap()
            app.buttons[style].tap()
            XCTAssertEqual(menu.value as? String, style)
            XCTAssertEqual(app.tabBars.count, style == "System" ? 1 : 0)
        }
        for color in ["Graphite", "Classic"] {
            let menu = app.buttons["Color palette"]
            XCTAssertTrue(menu.isHittable, app.debugDescription)
            XCTAssertGreaterThanOrEqual(menu.frame.height, 44)
            menu.tap()
            app.buttons[color].tap()
            XCTAssertEqual(menu.value as? String, color)
        }
        app.buttons["Create"].tap()
        XCTAssertTrue(app.textFields["Sample title"].waitForExistence(timeout: 3))
        app.buttons["Cancel"].tap()
        app.terminate()
        app.launch()
        XCTAssertTrue(app.buttons["Tab bar style"].waitForExistence(timeout: 5))
    }
}
