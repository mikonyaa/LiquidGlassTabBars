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

    func testCustomVariantsRenderTwoThreeAndFiveItems() throws {
        for count in [2, 3, 5] {
            for variant in LiquidTabBarVariant.allCases {
                XCTAssertGreaterThanOrEqual(
                    try renderedHeight(for: variant, itemCount: count),
                    44
                )
            }
        }
    }

    func testAccessibilityEnvironmentsRemainRenderable() throws {
        let view = makeBar(variant: .morphing, itemCount: 5)
            .environment(\.dynamicTypeSize, .accessibility3)
            .frame(width: 420)
        let renderer = ImageRenderer(content: view)
        renderer.scale = 1
        renderer.proposedSize = ProposedViewSize(width: 420, height: nil)

        let image = try XCTUnwrap(renderer.cgImage)
        XCTAssertGreaterThanOrEqual(CGFloat(image.height), 44)
    }

    func testReducedEffectsSelectAccessiblePolicies() {
        XCTAssertFalse(LiquidAccessibilityBehavior.animatesSelection(reduceMotion: true))
        XCTAssertTrue(LiquidAccessibilityBehavior.animatesSelection(reduceMotion: false))
        XCTAssertTrue(LiquidAccessibilityBehavior.usesOpaqueSurface(reduceTransparency: true))
        XCTAssertFalse(LiquidAccessibilityBehavior.usesOpaqueSurface(reduceTransparency: false))
    }

    private func renderedHeight(
        for variant: LiquidTabBarVariant,
        itemCount: Int = 4
    ) throws -> CGFloat {
        let view = makeBar(variant: variant, itemCount: itemCount)
            .frame(width: 420)
        let renderer = ImageRenderer(content: view)
        renderer.scale = 1
        renderer.proposedSize = ProposedViewSize(width: 420, height: nil)

        return CGFloat(try XCTUnwrap(renderer.cgImage).height)
    }

    private func makeBar(
        variant: LiquidTabBarVariant,
        itemCount: Int
    ) -> some View {
        let items = (0 ..< itemCount).map { index in
            LiquidTabItem(
                id: index,
                title: "Tab \(index + 1)",
                systemImage: "\(index + 1).circle.fill"
            )
        }
        return LiquidTabBar(
            selection: .constant(0),
            items: items,
            variant: variant,
            theme: .classic
        )
    }
}
