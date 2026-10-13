import SwiftUI

struct LiquidGlassSurfaceModifier<SurfaceShape: Shape>: ViewModifier {
    let shape: SurfaceShape
    let tint: Color?
    let isInteractive: Bool
    let theme: LiquidTabBarTheme

    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency

    @ViewBuilder
    func body(content: Content) -> some View {
        if LiquidAccessibilityBehavior.usesOpaqueSurface(
            reduceTransparency: reduceTransparency
        ) {
            content
                .background(theme.fallbackFill, in: shape)
                .background(LiquidTabBarTheme.adaptiveFallbackFill, in: shape)
                .overlay { shape.stroke(theme.fallbackBorder, lineWidth: 1) }
        } else {
            #if compiler(>=6.2)
            if #available(iOS 26.0, macOS 26.0, *) {
                if isInteractive {
                    content.glassEffect(
                        .regular.tint(tint).interactive(),
                        in: shape
                    )
                } else {
                    content.glassEffect(.regular.tint(tint), in: shape)
                }
            } else {
                fallbackSurface(content)
            }
            #else
            fallbackSurface(content)
            #endif
        }
    }

    private func fallbackSurface(_ content: Content) -> some View {
        content
            .background(.ultraThinMaterial, in: shape)
            .overlay { shape.stroke(theme.fallbackBorder, lineWidth: 0.75) }
    }
}

extension View {
    func liquidGlassSurface<S: Shape>(
        in shape: S,
        tint: Color? = nil,
        isInteractive: Bool = false,
        theme: LiquidTabBarTheme
    ) -> some View {
        modifier(
            LiquidGlassSurfaceModifier(
                shape: shape,
                tint: tint,
                isInteractive: isInteractive,
                theme: theme
            )
        )
    }
}
