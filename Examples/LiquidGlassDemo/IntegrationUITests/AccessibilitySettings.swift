import XCTest

@MainActor
enum AccessibilitySettings {
    static func setReducedEffects(_ enabled: Bool) {
        let settings = XCUIApplication(bundleIdentifier: "com.apple.Preferences")
        settings.launchArguments = ["-AppleLanguages", "(en)", "-AppleLocale", "en_US"]
        settings.launch()
        // Settings preserves its last page between launches.
        for _ in 0 ..< 6 {
            if settings.navigationBars["Settings"].exists { break }
            let back = settings.navigationBars.buttons.firstMatch
            if back.exists { back.tap() }
        }
        let accessibility = settings.cells.staticTexts["Accessibility"]
        for _ in 0 ..< 6 {
            if accessibility.isHittable { break }
            settings.swipeUp()
        }
        XCTAssertTrue(accessibility.waitForExistence(timeout: 5), settings.debugDescription)
        accessibility.tap()
        settings.staticTexts["Display & Text Size"].tap()
        let transparency = settings.switches["Reduce Transparency"]
        for _ in 0 ..< 4 {
            if transparency.isHittable { break }
            settings.swipeUp()
        }
        set(transparency, to: enabled)
        settings.navigationBars.buttons.firstMatch.tap()
        settings.staticTexts["Motion"].tap()
        set(settings.switches["Reduce Motion"], to: enabled)
        settings.terminate()
    }

    private static func set(_ control: XCUIElement, to enabled: Bool) {
        XCTAssertTrue(control.waitForExistence(timeout: 5))
        if (control.value as? String == "1") != enabled {
            control.coordinate(withNormalizedOffset: CGVector(dx: 0.9, dy: 0.5)).tap()
        }
        let updated = XCTNSPredicateExpectation(
            predicate: NSPredicate(format: "value == %@", enabled ? "1" : "0"), object: control
        )
        XCTAssertEqual(XCTWaiter.wait(for: [updated], timeout: 5), .completed)
        XCTAssertEqual(control.value as? String, enabled ? "1" : "0")
    }
}
