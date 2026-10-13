# Validation

The package supports Swift tools 6.0, iOS 17 and macOS 14. Native glass requires an iOS/macOS 26 SDK and compiler 6.2 or newer; earlier SDKs compile the material fallback. Runtime minimums are unchanged.

## Automatic boundaries

`Examples/LiquidGlassDemo/IntegrationHost` imports public `LiquidUI` without `@testable` and uses stable Int IDs 101, 203, 305, 407, 509. Controls select count, variant, usable width, Dynamic Type, long labels and direction. Actual reduced-effects values are displayed. To change those values, use Settings → Accessibility → Display & Text Size → Reduce Transparency, and Accessibility → Motion → Reduce Motion. These SwiftUI environment values are read-only.

The shared `LiquidGlassDemo` scheme includes:

- Hosted `SurfaceTests`: compare pixels over bright and dark backdrops for four presets, a low-alpha custom theme and `.clear`, with actual Reduce Transparency enabled.
- `InteractionTests`: 2/3/5 IDs × Floating/Morphing × 320/375/420 pt × Large/accessibility3, long labels, LTR/RTL; narrow five-item tests also cover accessibility1–5. Each target must be at least 44 × 44 pt, visible, hittable and separate. Selection and reselection counters exercise real taps and the real binding transaction.
- Caller-owned external/invalid selection and omitted callback checks.
- `DemoTests`: 60% progress, Create save/cancel, Focus on/off, native share presentation/dismissal, rapid style switches and relaunch.

The test host runs inside a vertical scroll container so contributors can explore sizes beyond the documented matrix; the automatic geometry gate still requires every tested button to fit onscreen. Visual truncation is allowed while the full title remains the accessibility label.

## Reproduce

```bash
git rev-parse HEAD
git status --short
swift --version
xcodebuild -version
swiftlint version
xcodegen --version
swift test
swiftlint lint --strict
xcodebuild -project Examples/LiquidGlassDemo/LiquidGlassDemo.xcodeproj \
  -scheme LiquidGlassDemo -showdestinations
xcodebuild -project Examples/LiquidGlassDemo/LiquidGlassDemo.xcodeproj \
  -scheme LiquidGlassDemo -destination 'generic/platform=iOS Simulator' \
  CODE_SIGNING_ALLOWED=NO build
Scripts/validate_consumers.sh
Scripts/test_ui.sh
```

`validate_consumers.sh` creates two packages outside the source repository. One resolves exact remote `1.0.3`; the other depends on the local RC path. Both import SwiftUI and LiquidUI, build custom Int-ID tabs, an old-signature theme initializer, a binding/reselection closure and system tabs. Set `LIQUID_CONSUMER_OUTPUT` to retain manifests and resolve/build outputs in a chosen external directory.

`test_ui.sh` selects an installed iOS runtime, creates a Pro Max Simulator, configures actual accessibility settings through Settings UI, runs the shared scheme and removes only its own device. Set `LIQUID_TEST_RUNTIME`, `LIQUID_TEST_DEVICE_TYPE` and `LIQUID_TEST_OUTPUT` to choose an installed runtime/type and retain results. Verbose sysdiagnose collection is disabled; assertions, screenshots and `.xcresult` attachments remain available.

For a preconfigured existing destination, run:

```bash
xcodebuild -project Examples/LiquidGlassDemo/LiquidGlassDemo.xcodeproj \
  -scheme LiquidGlassDemo -destination 'platform=iOS Simulator,id=YOUR_SIMULATOR_ID' \
  -parallel-testing-enabled NO -collect-test-diagnostics never \
  -resultBundlePath /tmp/LiquidUI-integration.xcresult \
  CODE_SIGNING_ALLOWED=NO test
```

Run `testConfigureReducedEffects` first when using that direct command; hosted surfaces require Reduce Transparency. The script handles this prerequisite automatically. Use a Pro Max for 420 pt fixtures.

Regenerate with checksum-pinned XcodeGen 2.45.4, then repeat:

```bash
Scripts/install_xcodegen.sh /tmp/liquid-xcodegen
(cd Examples/LiquidGlassDemo && /tmp/liquid-xcodegen/xcodegen/bin/xcodegen generate)
git diff --exit-code -- Examples/LiquidGlassDemo/LiquidGlassDemo.xcodeproj
(cd Examples/LiquidGlassDemo && /tmp/liquid-xcodegen/xcodegen/bin/xcodegen generate)
git diff --exit-code -- Examples/LiquidGlassDemo/LiquidGlassDemo.xcodeproj
```

CI preserves Xcode 16.4/macOS 15 and Xcode 26.5/macOS 26 lanes. Both run package, consumer, build, regeneration and runtime UI gates. Its tag patterns match existing `1.0.x` tags and legacy `v`-prefixed equivalents. Existing release tags are never changed.

## Runtime media

```bash
Scripts/record_showcase.sh
# Or select an available, empty simulator explicitly:
LIQUID_DEMO_DEVICE_ID=YOUR_SIMULATOR_ID Scripts/record_showcase.sh
```

The default creates a new Simulator. Explicit IDs are validated before building/recording; a preinstalled demo causes an error to preserve it. The script checks Xcode, simctl, ffmpeg, Python and Git. It records screenshots first, then a runtime movie and optimized GIF. EXIT/INT/TERM cleanup stops its own recorder, removes its own app installation and deletes only a Simulator it created. An explicitly supplied Simulator is retained.

`Assets/capture-manifest.json` records source SHA, initial dirty state, Xcode, device, runtime, capture type and file hashes. `Assets/capture-commands.txt` records commands with portable source/scratch paths. Temporary video and build files are removed. Set `LIQUID_DEMO_RUNTIME`, `LIQUID_DEMO_DEVICE_TYPE`, `LIQUID_DEMO_DURATION` or `LIQUID_DEMO_OUTPUT` to customize a capture. Screenshots are Simulator evidence, never physical-device validation.

## Human and external gates

These remain unchecked until a person performs them on the specified hardware/environment. Automated passes cannot tick them:

- [ ] iOS 17 runtime smoke test on an installed minimum-OS Simulator/device.
- [ ] Physical iPhone: native Liquid Glass, contrast and placement at the home indicator.
- [ ] VoiceOver focus order, full labels and reselection feedback on physical device.
- [ ] Reduce Motion/Transparency, largest text and light/dark themes on physical device.
- [ ] iPad multitasking and multiple-window presentation review.
- [ ] Independent developer integration pilot using their own navigation/state restoration.
- [ ] Human review of screenshots/GIF, draft release notes and version/tag consistency.

The demo currently declares a single scene. Rapid switches and relaunch are reproducible runtime checks; they are not a proof of leak-free multiple-window behavior. The window snapshot mechanism is unchanged because the supplied hypotheses did not establish a defect in that supported configuration.

## API references

- [Apple: GlassEffectContainer](https://developer.apple.com/documentation/swiftui/glasseffectcontainer)
- [Apple: glassEffect](https://developer.apple.com/documentation/swiftui/view/glasseffect(_:in:))
- [Apple: Reduce Transparency](https://developer.apple.com/documentation/swiftui/environmentvalues/accessibilityreducetransparency)
- [Swift PackageDescription](https://docs.swift.org/package-manager/PackageDescription/PackageDescription.html)
- [XcodeGen project specification](https://github.com/yonaskolb/XcodeGen/blob/master/Docs/ProjectSpec.md)
