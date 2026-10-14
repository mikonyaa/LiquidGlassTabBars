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

    func testShortLabelsKeepExpandedLayoutReachable() {
        AccessibilitySettings.setReducedEffects(false)
        for count in [2, 3, 5] {
            for variant in ["floating", "morphing"] {
                for width in [320, 420] {
                    check(count: count, variant: variant, width: width, access: false, rtl: true, longLabels: false)
                }
            }
        }
    }

    func testSmallTextKeepsMinimumTargets() {
        AccessibilitySettings.setReducedEffects(false)
        for variant in ["floating", "morphing"] {
            check(count: 5, variant: variant, width: 320, access: false, rtl: false, typeSize: 6)
        }
    }

    func testNormalMotionTransaction() {
        AccessibilitySettings.setReducedEffects(false)
        check(count: 2, variant: "floating", width: 320, access: false, rtl: false)
    }

    func testReducedEffectsAreIndependent() {
        for motion in [false, true] {
            AccessibilitySettings.set(reduceTransparency: !motion, reduceMotion: motion)
            for variant in ["floating", "morphing"] {
                check(
                    count: 2, variant: variant, width: 320, access: false, rtl: false,
                    motion: motion, transparency: !motion
                )
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

    private func check(
        count: Int, variant: String, width: Int, access: Bool, rtl: Bool,
        typeSize: Int = 3, longLabels: Bool = true, motion: Bool? = nil, transparency: Bool? = nil
    ) {
        let scenario = "\(count)/\(variant)/\(width)/access=\(access)/type=\(typeSize)/rtl=\(rtl)"
        XCTContext.runActivity(named: scenario) { activity in
            let app = XCUIApplication()
            app.launchArguments = ["--count", "\(count)", "--variant", variant, "--width", "\(width)"]
            if longLabels { app.launchArguments.append("--long") }
            app.launchArguments += ["--dynamic-type", "\(access || typeSize == 6 ? typeSize : 0)"]
            if rtl { app.launchArguments.append("--rtl") }
            app.launch()
            XCTAssertEqual(app.staticTexts["systemRT"].label, "systemRT: \((transparency ?? access) ? 1 : 0)")
            XCTAssertEqual(app.staticTexts["systemRM"].label, "systemRM: \((motion ?? access) ? 1 : 0)")
            assertTargets(in: app, count: count, width: width, longLabels: longLabels, activity: activity)
            let screenshot = XCTAttachment(screenshot: app.screenshot())
            screenshot.lifetime = .keepAlways
            activity.add(screenshot)
            app.buttons[title(for: 0, long: longLabels)].tap()
            XCTAssertEqual(app.staticTexts["writes"].label, "writes: 0")
            XCTAssertEqual(app.staticTexts["reselections"].label, "reselections: 1")
            for index in 1 ..< count {
                app.buttons[title(for: index, long: longLabels)].tap()
                XCTAssertEqual(app.staticTexts["selection"].label, "selection: \(identifiers[index])")
                XCTAssertEqual(app.staticTexts["writes"].label, "writes: \(index)")
                XCTAssertEqual(app.staticTexts["uiAnimated"].label, "uiAnimated: \((motion ?? access) ? 0 : 1)")
                assertTargets(in: app, count: count, width: width, longLabels: longLabels, activity: activity)
                XCTAssertTrue(app.buttons[title(for: index, long: longLabels)].isSelected)
                app.buttons[title(for: index, long: longLabels)].tap()
                XCTAssertEqual(app.staticTexts["reselections"].label, "reselections: \(index + 1)")
                XCTAssertEqual(app.staticTexts["writes"].label, "writes: \(index)")
            }
            app.terminate()
        }
    }

    private func title(for index: Int, long: Bool) -> String {
        long ? "Destination \(index + 1) with a very long localized title" : "Tab \(index + 1)"
    }

    private func assertTargets(
        in app: XCUIApplication, count: Int, width: Int, longLabels: Bool, activity: XCTActivity
    ) {
        let appBounds = app.frame
        let left = appBounds.midX - CGFloat(width) / 2
        let right = left + CGFloat(width)
        // Accessibility frames include a half-point border and floating-point rounding.
        let edgeTolerance: CGFloat = 0.51
        var frames: [CGRect] = []
        for index in 0 ..< count {
            let label = title(for: index, long: longLabels)
            let button = app.buttons[label]
            XCTAssertTrue(button.waitForExistence(timeout: 5))
            let frame = button.frame
            XCTAssertGreaterThanOrEqual(frame.width, 44, label)
            XCTAssertGreaterThanOrEqual(frame.height, 44, label)
            XCTAssertGreaterThanOrEqual(frame.minX, left - edgeTolerance, "Outside allotted width: \(label)")
            XCTAssertLessThanOrEqual(frame.maxX, right + edgeTolerance, "Outside allotted width: \(label)")
            XCTAssertTrue(appBounds.contains(frame), "Offscreen \(label): \(frame)")
            XCTAssertTrue(button.isHittable, label)
            for other in frames { XCTAssertFalse(frame.intersects(other), "Overlapping targets") }
            frames.append(frame)
        }
        let measured = XCTAttachment(string: frames.map { String(describing: $0) }.joined(separator: "\n"))
        measured.name = "Target frames after selection"
        measured.lifetime = .keepAlways
        activity.add(measured)
    }
}
