# RC validation — 14 October 2026

Baseline: `828ded25395e66fa7640d496ecc18cc83e6b1777`, published tag `1.0.3`. First full local runtime suite: `b8b1e5896eb2d768c54e6f74eb2a737d0a254ad0`. The library and capture sources remain unchanged; native demo menus receive the separately checked follow-up described below. The helper-only test refactor in `b79539f58ecb71c784e2cad089a8d112df71103d` extracts screenshot measurement and round-trip assertions and groups frame parameters. Its fresh four-test runtime recheck passed with zero failures/skips, separately from the full suite. Each media manifest records its own capture source.

## Observed regressions and fixes

| Boundary | Before | Candidate evidence |
| --- | --- | --- |
| Actual Reduce Transparency | Eight bright/dark backdrop pixel differences: Violet/Ocean and custom alpha/clear × both variants. Neutral/Classic controls passed. | Six themes × both variants compare equal over different backdrops with the real setting enabled. |
| Narrow Morphing | Five long labels, 320 pt, accessibility3/RTL placed a target offscreen on a 402 pt Simulator. | Adaptive equal-width capsules retain full labels and separate targets. |
| Small text | XSmall measured a 41.333 pt button; negative fixture exited 65. | The target and surface heights preserve at least 44 pt. |
| Floating RTL reselection | Selected short-label Tab 3 became persistently non-hittable, independently reproduced and unchanged after five seconds of fresh polling. | Hiding only visual label children preserves the native Button/full title/selected trait. The real 1 → 2 → 3 → 1 round trip and reselections pass. |
| Demo | 72% contradicted 3/5, and local action buttons had no result. | Shared fixture 60%, Create Save/Cancel, Focus state and native Share. |
| Capture | Personal simulator ID and no guaranteed cleanup. | Missing ID exits 1 before recording. SIGTERM during real recording exits 143; its recorder/device are removed and existing devices preserved. |

The UI suite exercises 67 configurations: 36 long-label count/variant/width/size cases, 10 largest accessibility-size cases, 12 short-label cases, two XSmall cases, the original narrow fixture, four independent RT/RM combinations, normal UI animation and the focused RTL round trip. Extra cases cover external/invalid selection and omitted callbacks. Each target must be ≥44 × 44 pt, onscreen, hittable and non-overlapping initially and after selection. A validated screenshot-derived display scale permits only a half-point stroke plus one physical pixel at allotted-width edges; the other checks are strict.

Motion is measured from a UIKit representable's rendered `context.transaction`. The normal UI spring remains; reduced motion has no animation. The custom Binding setter's transaction argument is recorded separately and is not used as the UI animation oracle.

## Recorded automatic gates

Local toolchain: macOS 26.7.1, Xcode 27.0 (27A266a), Swift 6.4 (swiftlang-6.4.0.34.1), SwiftLint 0.65.0, XcodeGen 2.45.4. Final Simulator: isolated iPhone 16 Pro Max, iOS 26.5.

| Gate | Result |
| --- | --- |
| Baseline and final `swift test` | Exit 0; seven tests, zero failures |
| Final `swiftlint lint --strict` | Exit 0; zero violations |
| Final generic iOS Simulator build | Exit 0 |
| Final unsigned iOS device archive | Exit 0; iOS 17 deployment target |
| External remote exact 1.0.3 and local candidate consumers | Resolve/build exit 0 |
| Focused final RTL round trip | Exit 0; no hittability polling needed |
| Fresh shared scheme | Exit 0; 14 tests, zero failures/skips; all 67 configurations |
| Post-refactor focused runtime recheck | Exit 0; four tests, zero failures/skips: Floating RTL round trip, normal UI motion, independent RT/RM and XSmall |
| Settings lookup recheck after the first compatibility bootstrap | Exit 0; two tests, zero failures/skips: bootstrap and all four independent RT/RM combinations |
| Native demo controls follow-up | Exit 0; two tests, zero failures/skips: native Share content/dismissal, 44 pt menu targets, actual style/Graphite → Classic values and rapid style changes |
| XcodeGen 2.45.4 checksum/install and repeated project generation | Exit 0; identical checked-in project/schemes |
| Script syntax, YAML, relative links and diff hygiene | Exit 0 |
| Runtime capture / negative device / interrupted recorder | Expected exits 0 / 1 / 143 |

XcodeGen asset SHA-256: `090ec29491aad50aec10631bf6e62253fed733c50f3aab0f5ffc86bc170bdbef`. Consumers import public SwiftUI/LiquidUI, use Int IDs, binding/reselection, the old theme initializer and system tabs. The released consumer resolves the exact baseline SHA. See [Validation](Validation.md) for full commands and retained `.xcresult` attachments.

CI runs the same automatic boundaries on Xcode 16.4/macOS 15/iOS 18.5 and Xcode 26.5/macOS 26/iOS 26.5. Explicit Bash enables pipeline failure propagation for logged commands. Actual job results are separate from this local run; the workflow retains validation logs and result bundles as artifacts.

The first GitHub compatibility bootstrap exposed an OS difference in Settings: on iOS 18.5 the `REDUCE_TRANSPARENCY` identifier belongs to the row's StaticText, while its native Switch has the `Reduce Transparency` label. The actual failure hierarchy was retained. Test-helper correction `b3e862d66adf1a530c33cee72b1456efd112b391` accepts the switch identifier or English label for both effects. Real switch-value assertions and the app's environment checks remain. The fresh local bootstrap/mixed-effects recheck passed; that test-helper correction leaves production code unchanged.

The subsequent CI on `a6de69f` passed all 14 tests on Xcode 26.5/iOS 26.5. Xcode 16.4/iOS 18.5 passed the surface test and all 11 interaction tests (67 configurations), then exposed demo differences. Its native Share caption lacks the newer private LP caption ID, so the test now matches the actual sample text within `ActivityListView`. Its SwiftUI Menu semantic wrapper and native child both reported non-hittable despite 44 pt frames. Controlled diagnostic touches opened the menus in both fresh System and Floating launches, ruling out pointer routing and TabView ordering. Moving accessibility metadata or excluding the decorative stroke did not resolve that AX representation.

The demo now uses a private UIViewRepresentable with a standard UIButton/UIMenu. Label and current value belong to the single native control, and UIActions use the existing state/transition function. The iOS 18.5 early smoke at `af6aa5d` passed the strict native-button regression. A subsequent narrow/maximum-text fixture reproduced a separate overflow (button minX -12.333 pt instead of at least 60 pt). Follow-up `f816f5d` respects finite sizing proposals, uses the SwiftUI text category for UIKit fonts and adapts the header from a natural horizontal row to vertical controls. A separate clearance assertion then exposed the preference-based height not reaching the content (headline minY 185 pt versus required 204.333 pt). Follow-up `d7584e1` observes the actual panel geometry directly. Both Floating/Graphite and Morphing/Graphite at 320 pt/accessibility5 pass the local geometry/hittability/content-clearance test and real System/Classic changes; the retained screenshot shows the heading below the panel.

The temporary coordinate diagnostic is removed. Release tests require the named native Button itself to be hittable and at least 44 × 44 pt; there is no wrapper/coordinate fallback. The shared scheme now contains 15 tests, including three demo tests. CI exposes native smoke as a separate step, then runs Settings and the complete scheme on another owned fresh Simulator. Published checks retain the actual SDK results. These tests do not establish physical VoiceOver activation.

## Runtime media and compatibility

The clean-source demo capture at `d7584e1d82020d5de1190fdacebca28ccf734c23` produced three 1320 × 2868 iPhone PNGs and an 11.35-second, 227-frame, 400 × 869 GIF (2,522,956 bytes). All three styles/destination changes are visible. The separate iPad PNG at the same demo source is 1668 × 2420. The unchanged-library RT fixture screenshot from `b8b1e58` shows five long labels, 320 pt, accessibility4, RTL and actual `systemRT:1`/`systemRM:1`. All six hashes match their [manifests](../Assets/Screenshots/README.md). These are running Simulator captures; they are not synthetic previews or physical-device evidence.

Root Package.swift, product/module LiquidUI, generic IDs, Binding, onReselect, variants/system alternative, old public initializer signatures, Swift tools 6.0, iOS 17/macOS 14 and zero external runtime dependencies remain. Expected category: patch `1.0.4`; no code migration required. Translucent fallback colors now blend over opaque system backing in RT, so custom foreground contrast should be reviewed. See [draft release notes](ReleaseNotes-1.0.4-draft.md).

## Uncompleted external gates

iOS 17 runtime was unavailable locally. Physical iPhone Liquid Glass/home-indicator/VoiceOver/reduced-effects checks, iPad multitasking/multiple windows and an independent developer integration pilot are pending. An unsigned archive does not replace device execution. Rapid style changes and relaunch cover the supported single-scene demo; they do not establish leak-free multiple-window behavior. Its snapshot transition mechanism was retained without an established defect.

Existing tags are preserved. Publishing a branch/PR does not create a release or complete the human checklist.
