# Design principles

## Navigation is a layer above content

Liquid Glass is most effective for controls, navigation, menus, and overlays. It should remain visually connected to the content behind it without making the content harder to read.

The demo cards use quiet fills. The navigation controls carry the glass treatment.

## Start with the system

On iOS 26, `TabView` automatically adopts the current system tab bar design. This gives the app platform-correct contrast, animation, pointer behavior, and future OS improvements with very little code.

Custom navigation is justified only when it changes the interaction or layout in a meaningful way.

## Group related glass

The Morphing variant places neighboring glass controls in one `GlassEffectContainer`. SwiftUI can then render them together and morph their shapes coherently.

Do not put every button in an unrelated container. Separate containers cannot participate in the same glass interaction.

## Modifier order matters

Layout and visual content are defined before `glassEffect`. This lets the glass use the final shape and size.

For interactive elements, `.interactive()` is applied only to the control itself. The Floating bar shell is not interactive; its buttons are.

## Color communicates state

Tint marks the current selection. Inactive items stay neutral. A different color on every item creates noise and weakens the meaning of selection.

## Accessibility is not a second design

- Reduce Transparency replaces adaptive glass with an opaque, bordered surface.
- Reduce Motion removes the spring selection animation.
- Labels are exposed to VoiceOver and the active tab receives the selected trait.
- Scaled metrics preserve usable control sizes under larger text settings.
- A minimum 44-point hit target is treated as a constraint, not a suggestion.

## Fallbacks remain intentional

iOS 17–25 uses `ultraThinMaterial` with a restrained border. The fallback is not expected to reproduce iOS 26 optics. It should provide the same hierarchy, selection, and readability.

## Further reading

- [Meet Liquid Glass](https://developer.apple.com/videos/play/wwdc2025/219/)
- [Build a SwiftUI app with the new design](https://developer.apple.com/videos/play/wwdc2025/323/)
- [GlassEffectContainer](https://developer.apple.com/documentation/swiftui/glasseffectcontainer)
