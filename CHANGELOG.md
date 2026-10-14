# Changelog

All notable changes will be documented here.

## Unreleased — 1.0.4 release candidate

### Fixed

- Reduce Transparency composites every fallback color over opaque adaptive system backing.
- Morphing adapts to equal-width capsules when long labels or Dynamic Type exceed available width.
- Small text sizes retain a minimum 44 pt button height and sufficient surface padding.
- Floating keeps selection and reselection reachable in RTL by exposing the button label without separate visual child elements.
- Reduced motion disables the selection transaction and native morphing IDs.
- Demo Create, Focus and Share controls perform local actions; progress consistently displays 3/5 (60%).
- Demo style and palette menus use single native menu buttons with full labels/current values, at least 44 pt targets and an adaptive header at large text sizes.
- The demo panel's decorative border does not intercept menu taps.
- CI runs for existing SemVer tags and checks both SDK lanes, external consumers and hosted/UI tests.
- Capture validates tools and devices, creates an isolated Simulator by default, cleans up its own resources on interrupts and records provenance.

### Added

- Public-API integration host, real accessibility settings automation and pixel/geometry/binding regression fixtures.
- Checksum-pinned XcodeGen installation, reproducible commands and a separate physical-device/pilot checklist.

Public initializer signatures, product/module names, generic IDs, binding and `onReselect` remain compatible. No minimum OS or runtime dependency changes. See [draft release notes](Docs/ReleaseNotes-1.0.4-draft.md).

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
