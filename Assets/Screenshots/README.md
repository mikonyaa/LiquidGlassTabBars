# Runtime screenshots

`system-classic.png`, `floating-graphite.png` and `morphing-classic.png` were captured from the running demo on an iPhone 16 Pro Max Simulator, iOS 26.5, using Xcode 27.0. Their 1320 × 2868 PNGs correspond to source `d06d7e69a825bcd87683a135463df4b149509c62`. The library, demo and capture script at the later test-only commit `8bb008e` are identical to that capture source.

See [capture manifest](../capture-manifest.json) for SHA-256 hashes, capture time and device/runtime metadata, and [commands](../capture-commands.txt) for the recording steps. The manifest records an initially dirty checkout: the sole extra file was a command log from the previous capture attempt; production source matched the recorded commit.

`ipad-floating-graphite.png` is a separate iPad Pro 11-inch (M4) Simulator capture on iOS 26.5. Its [own manifest](../ipad-capture-manifest.json) records the source and hash. A portrait screenshot confirms this rendered layout; it does not verify multitasking or multiple windows.

For a fresh iPad capture using the same public script, choose an installed runtime/device type and a separate output directory:

```bash
LIQUID_DEMO_RUNTIME=com.apple.CoreSimulator.SimRuntime.iOS-26-5 \
LIQUID_DEMO_DEVICE_TYPE=com.apple.CoreSimulator.SimDeviceType.iPad-Pro-11-inch-M4-8GB \
LIQUID_DEMO_OUTPUT=/tmp/liquid-ipad Scripts/record_showcase.sh
```

Reduced-transparency fallback is checked by hosted runtime pixel comparisons in the integration suite. These use actual accessibility settings, both custom variants and six themes. See [validation](../../Docs/Validation.md) for how to reproduce them and the remaining physical-device checks.

These are Simulator captures, not synthetic previews or physical-device validation. Keep variant names stable; capture new files and update provenance together when the source changes.
