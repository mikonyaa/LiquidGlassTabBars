# Changelog

All notable changes will be documented here.

## 1.0.3

### Changed

- Made the root `Package.swift` the only package manifest and pointed the demo at it.
- Added selection and reselection coverage plus two-, three-, and five-item rendering tests.
- Added accessibility coverage for Reduce Motion, Reduce Transparency, and accessibility Dynamic Type policies.
- Documented the two-to-five-item scope for custom bars and the system-tab recommendation for larger sets.
- Aligned package and demo version metadata with `1.0.3`.

## 1.0.2

### Changed

- Unified Floating and Morphing tab bar surfaces at the same adaptive height.
- Aligned custom bars with the native tab bar baseline in the demo.
- Separated navigation changes from style and theme transitions for a steadier showcase.
- Re-recorded the catalog preview with a longer, smoother loop.

## 1.0.1

### Changed

- Re-recorded the showcase at 20 fps with deterministic launch states.
- Added smooth structural transitions without blank intermediate frames.
- Regenerated all README screenshots from stable, non-animated states.

## 1.0.0

### Added

- Initial `LiquidUI` Swift Package.
- System, Floating, and Morphing tab bar examples.
- Violet, Ocean, and Neutral theme presets.
- Classic theme and restrained Classic/Graphite demo backgrounds.
- iOS 17–25 material fallback.
- Accessibility-aware motion and transparency behavior.
- Runnable `LiquidGlassDemo` Xcode project.
- English and Russian getting-started documentation.
- Reproducible simulator screenshots and GIF recording script.
