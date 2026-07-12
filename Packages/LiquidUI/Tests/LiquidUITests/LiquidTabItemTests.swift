import XCTest
@testable import LiquidUI

final class LiquidTabItemTests: XCTestCase {
    func testItemPreservesPublicValues() {
        let item = LiquidTabItem(
            id: "home",
            title: "Home",
            systemImage: "house.fill"
        )

        XCTAssertEqual(item.id, "home")
        XCTAssertEqual(item.title, "Home")
        XCTAssertEqual(item.systemImage, "house.fill")
    }

    func testVariantsHaveStableRawValues() {
        XCTAssertEqual(LiquidTabBarVariant.floating.rawValue, "floating")
        XCTAssertEqual(LiquidTabBarVariant.morphing.rawValue, "morphing")
    }

    func testSelectionAndReselectionAreDistinguished() {
        XCTAssertFalse(LiquidTabSelection.isReselection(current: "home", candidate: "activity"))
        XCTAssertTrue(LiquidTabSelection.isReselection(current: "home", candidate: "home"))
    }
}
