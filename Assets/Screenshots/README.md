# Runtime screenshots

`system-classic.png`, `floating-graphite.png` and `morphing-classic.png` were captured from the running demo on an iPhone 16 Pro Max Simulator, iOS 26.5, using Xcode 27.0. Their 1320 × 2868 PNGs correspond to source `ef4a025559a857c2eb8e8ec701658ee6f5a47f2a`.

See [capture manifest](../capture-manifest.json) for SHA-256 hashes, capture time and device/runtime metadata, and [commands](../capture-commands.txt) for the recording steps. The capture began with a clean checkout.

`ipad-floating-graphite.png` is a separate iPad Pro 11-inch (M4) Simulator capture on iOS 26.5. Its [own manifest](../ipad-capture-manifest.json) records the source and hash. A portrait screenshot confirms this rendered layout; it does not verify multitasking or multiple windows.

For a fresh iPad capture using the same public script, choose an installed runtime/device type and a separate output directory:

```bash
LIQUID_DEMO_RUNTIME=com.apple.CoreSimulator.SimRuntime.iOS-26-5 \
LIQUID_DEMO_DEVICE_TYPE=com.apple.CoreSimulator.SimDeviceType.iPad-Pro-11-inch-M4-8GB \
LIQUID_DEMO_OUTPUT=/tmp/liquid-ipad Scripts/record_showcase.sh
```

`reduce-transparency-violet.png` is a runtime screenshot during the public-API integration test: five long labels, 320 pt, accessibility4 and RTL, with actual Reduce Transparency/Motion values visible. Its [own manifest](../reduced-transparency-capture-manifest.json) records that fixture and hash. Hosted pixel comparisons check both variants and six themes over bright/dark backdrops. See [validation](../../Docs/Validation.md) for reproduction and remaining physical-device checks.

These are Simulator captures, not synthetic previews or physical-device validation. Keep variant names stable; capture new files and update provenance together when the source changes.
