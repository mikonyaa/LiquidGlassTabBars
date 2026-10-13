import LiquidUI
import SwiftUI
import UIKit
import XCTest

@MainActor
final class SurfaceTests: XCTestCase {
    func testReducedTransparencyDoesNotExposeBackdrop() throws {
        XCTAssertTrue(UIAccessibility.isReduceTransparencyEnabled, "Enable Reduce Transparency on this simulator first")
        let themes: [LiquidTabBarTheme] = [
            .violet, .ocean, .neutral, .classic,
            LiquidTabBarTheme(tint: .red.opacity(0.05), fallbackFill: .blue.opacity(0.1)),
            LiquidTabBarTheme(fallbackFill: .clear)
        ]
        for (index, theme) in themes.enumerated() {
            for variant in LiquidTabBarVariant.allCases {
                let bright = try pixel(theme: theme, variant: variant, backdrop: .yellow)
                let dark = try pixel(theme: theme, variant: variant, backdrop: .black)
                XCTAssertEqual(bright, dark, "Theme \(index), \(variant): reduced surface exposes backdrop")
            }
        }
    }

    private func pixel(theme: LiquidTabBarTheme, variant: LiquidTabBarVariant, backdrop: Color) throws -> [UInt8] {
        let bar = LiquidTabBar(
            selection: .constant(7),
            items: [
                LiquidTabItem(id: 7, title: "One", systemImage: "circle"),
                LiquidTabItem(id: 9, title: "Two", systemImage: "circle")
            ],
            variant: variant,
            theme: theme
        )
        .environment(\.dynamicTypeSize, .large)
        .frame(width: 320)
        .padding(20)
        .background(backdrop)
        .preferredColorScheme(.light)
        .ignoresSafeArea()
        let host = UIHostingController(rootView: bar)
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 360, height: 100))
        window.rootViewController = host
        window.makeKeyAndVisible()
        defer { window.isHidden = true }
        host.view.frame = window.bounds
        host.view.setNeedsLayout()
        host.view.layoutIfNeeded()
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        let image = UIGraphicsImageRenderer(size: window.bounds.size, format: format).image { _ in
            host.view.drawHierarchy(in: window.bounds, afterScreenUpdates: true)
        }
        let attachment = XCTAttachment(image: image)
        attachment.name = "\(variant)-surface"
        attachment.lifetime = .keepAlways
        add(attachment)
        let bitmap = try XCTUnwrap(image.cgImage)
        var bytes = [UInt8](repeating: 0, count: 360 * 100 * 4)
        let context = try XCTUnwrap(CGContext(
            data: &bytes, width: 360, height: 100, bitsPerComponent: 8, bytesPerRow: 360 * 4,
            space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ))
        context.draw(bitmap, in: window.bounds)
        // Inside the left capsule, above the selected text/icon and away from the border.
        let offset = (30 * 360 + 145) * 4
        return Array(bytes[offset ..< offset + 4])
    }
}
