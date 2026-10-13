import XCTest

@MainActor
final class InteractionTests: XCTestCase {
    private let identifiers = [101, 203, 305, 407, 509]

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    func testNarrowAccessibilityNegativeFixture() {
        AccessibilitySettings.setReducedEffects(true)
        check(count: 5, variant: "morphing", width: 320, access: true, rtl: true)
    }

    func testAllAccessibilitySizes() {
        AccessibilitySettings.setReducedEffects(true)
        for variant in ["floating", "morphing"] {
            for size in 1 ... 5 {
                check(count: 5, variant: variant, width: 320, access: true, rtl: true, typeSize: size)
            }
        }
    }

    func testConfigureReducedEffects() {
        AccessibilitySettings.setReducedEffects(true)
    }

    func testLayoutAndInteractionMatrix() {
        for access in [false, true] {
            AccessibilitySettings.setReducedEffects(access)
            for count in [2, 3, 5] {
                for variant in ["floating", "morphing"] {
                    for width in [320, 375, 420] {
                        check(count: count, variant: variant, width: width, access: access, rtl: access)
                    }
                }
            }
        }
    }

    func testReselectionWithoutCallback() {
        let app = XCUIApplication()
        app.launchArguments = ["--count", "2", "--variant", "floating", "--no-callback"]
        app.launch()
        app.buttons["Tab 1"].tap()
        XCTAssertEqual(app.staticTexts["writes"].label, "writes: 0")
        XCTAssertEqual(app.staticTexts["reselections"].label, "reselections: 0")
    }

    func testExternalAndInvalidSelectionRemainCallerControlled() {
        let app = XCUIApplication()
        app.launchArguments = ["--count", "3", "--variant", "morphing", "--selection", "999"]
        app.launch()
        XCTAssertEqual(app.staticTexts["selection"].label, "selection: 999")
        XCTAssertEqual(app.staticTexts["writes"].label, "writes: 0")
        XCTAssertFalse(app.buttons["Tab 1"].isSelected)
        app.buttons["Select last externally"].tap()
        XCTAssertTrue(app.buttons["Tab 3"].isSelected)
        XCTAssertEqual(app.staticTexts["writes"].label, "writes: 0")
        app.buttons["Tab 3"].tap()
        XCTAssertEqual(app.staticTexts["reselections"].label, "reselections: 1")
        XCTAssertEqual(app.staticTexts["writes"].label, "writes: 0")
    }

    private func check(count: Int, variant: String, width: Int, access: Bool, rtl: Bool, typeSize: Int = 3) {
        let scenario = "\(count)/\(variant)/\(width)/access=\(access)/type=\(typeSize)/rtl=\(rtl)"
        XCTContext.runActivity(named: scenario) { activity in
            let app = XCUIApplication()
            app.launchArguments = ["--count", "\(count)", "--variant", variant, "--width", "\(width)", "--long"]
            if access { app.launchArguments += ["--dynamic-type", "\(typeSize)"] }
            if rtl { app.launchArguments.append("--rtl") }
            app.launch()
            XCTAssertEqual(app.staticTexts["systemRT"].label, "systemRT: \(access ? 1 : 0)")
            XCTAssertEqual(app.staticTexts["systemRM"].label, "systemRM: \(access ? 1 : 0)")
            var previous: [CGRect] = []
            for index in 0 ..< count {
                let title = "Destination \(index + 1) with a very long localized title"
                let button = app.buttons[title]
                XCTAssertTrue(button.waitForExistence(timeout: 5))
                let frame = button.frame
                XCTAssertGreaterThanOrEqual(frame.width, 44, title)
                XCTAssertGreaterThanOrEqual(frame.height, 44, title)
                XCTAssertTrue(app.frame.contains(frame), "Offscreen \(title): \(frame)")
                XCTAssertTrue(button.isHittable, title)
                for other in previous { XCTAssertFalse(frame.intersects(other), "Overlapping targets") }
                previous.append(frame)
            }
            let screenshot = XCTAttachment(screenshot: app.screenshot())
            screenshot.lifetime = .keepAlways
            activity.add(screenshot)
            app.buttons["Destination 1 with a very long localized title"].tap()
            XCTAssertEqual(app.staticTexts["writes"].label, "writes: 0")
            XCTAssertEqual(app.staticTexts["reselections"].label, "reselections: 1")
            for index in 1 ..< count {
                app.buttons["Destination \(index + 1) with a very long localized title"].tap()
                XCTAssertEqual(app.staticTexts["selection"].label, "selection: \(identifiers[index])")
                XCTAssertEqual(app.staticTexts["writes"].label, "writes: \(index)")
                XCTAssertEqual(app.staticTexts["animated"].label, "animated: \(access ? 0 : 1)")
                app.buttons["Destination \(index + 1) with a very long localized title"].tap()
                XCTAssertEqual(app.staticTexts["reselections"].label, "reselections: \(index + 1)")
                XCTAssertEqual(app.staticTexts["writes"].label, "writes: \(index)")
            }
            app.terminate()
        }
    }
}
