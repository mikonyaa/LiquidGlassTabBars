import SwiftUI

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public struct LiquidTabBarTheme: Sendable {
    public var tint: Color
    public var inactiveForeground: Color
    /// In Reduce Transparency this color is composited over the opaque adaptive system background.
    public var fallbackFill: Color
    public var fallbackBorder: Color
    public var selectedFillOpacity: Double
    public var selectedBorderOpacity: Double
    public var shadowColor: Color
    public var shadowRadius: CGFloat
    public var itemSpacing: CGFloat

    public init(
        tint: Color = .accentColor,
        inactiveForeground: Color = .secondary,
        fallbackFill: Color = LiquidTabBarTheme.adaptiveFallbackFill,
        fallbackBorder: Color = .primary.opacity(0.12),
        selectedFillOpacity: Double = 0.18,
        selectedBorderOpacity: Double = 0.48,
        shadowColor: Color = .black.opacity(0.16),
        shadowRadius: CGFloat = 18,
        itemSpacing: CGFloat = 8
    ) {
        self.tint = tint
        self.inactiveForeground = inactiveForeground
        self.fallbackFill = fallbackFill
        self.fallbackBorder = fallbackBorder
        self.selectedFillOpacity = selectedFillOpacity
        self.selectedBorderOpacity = selectedBorderOpacity
        self.shadowColor = shadowColor
        self.shadowRadius = shadowRadius
        self.itemSpacing = itemSpacing
    }

    public static let violet = LiquidTabBarTheme(
        tint: Color(red: 0.76, green: 0.53, blue: 1),
        inactiveForeground: .white.opacity(0.58),
        fallbackFill: Color(red: 0.10, green: 0.07, blue: 0.16).opacity(0.96),
        fallbackBorder: Color(red: 0.82, green: 0.69, blue: 1).opacity(0.24),
        shadowColor: Color.purple.opacity(0.18)
    )

    public static let ocean = LiquidTabBarTheme(
        tint: Color(red: 0.28, green: 0.82, blue: 1),
        inactiveForeground: .white.opacity(0.60),
        fallbackFill: Color(red: 0.04, green: 0.10, blue: 0.15).opacity(0.96),
        fallbackBorder: Color.cyan.opacity(0.22),
        shadowColor: Color.cyan.opacity(0.14)
    )

    public static let neutral = LiquidTabBarTheme(
        tint: .primary,
        inactiveForeground: .secondary,
        fallbackFill: adaptiveFallbackFill,
        fallbackBorder: .primary.opacity(0.10),
        shadowColor: .black.opacity(0.12)
    )

    public static let classic = LiquidTabBarTheme(
        tint: Color(red: 0.20, green: 0.58, blue: 1),
        inactiveForeground: .white.opacity(0.62),
        fallbackFill: Color(red: 0.12, green: 0.13, blue: 0.15),
        fallbackBorder: .white.opacity(0.12),
        shadowColor: .black.opacity(0.14)
    )

    public static var adaptiveFallbackFill: Color {
        #if canImport(UIKit)
        Color(uiColor: .secondarySystemBackground)
        #elseif canImport(AppKit)
        Color(nsColor: .controlBackgroundColor)
        #else
        Color.gray
        #endif
    }
}
