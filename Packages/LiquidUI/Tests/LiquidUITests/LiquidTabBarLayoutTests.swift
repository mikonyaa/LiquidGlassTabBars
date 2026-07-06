import SwiftUI
import XCTest
@testable import LiquidUI

@MainActor
final class LiquidTabBarLayoutTests: XCTestCase {
    func testVariantsUseTheSameSurfaceHeight() throws {
        let floatingHeight = try renderedHeight(for: .floating)
        let morphingHeight = try renderedHeight(for: .morphing)

        XCTAssertEqual(floatingHeight, morphingHeight, accuracy: 0.5)
    }

    private func renderedHeight(for variant: LiquidTabBarVariant) throws -> CGFloat {
        let items = [
            LiquidTabItem(id: "home", title: "Home", systemImage: "house.fill"),
            LiquidTabItem(id: "activity", title: "Activity", systemImage: "waveform.path.ecg"),
            LiquidTabItem(id: "library", title: "Library", systemImage: "square.grid.2x2.fill"),
            LiquidTabItem(id: "profile", title: "Profile", systemImage: "person.crop.circle.fill")
        ]
        let view = LiquidTabBar(
            selection: .constant("home"),
            items: items,
            variant: variant,
            theme: .classic
        )
        .frame(width: 360)
        let renderer = ImageRenderer(content: view)
        renderer.scale = 1
        renderer.proposedSize = ProposedViewSize(width: 360, height: nil)

        return CGFloat(try XCTUnwrap(renderer.cgImage).height)
    }
}
