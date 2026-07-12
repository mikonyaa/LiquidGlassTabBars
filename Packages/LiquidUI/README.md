# LiquidUI

`LiquidUI` is the reusable product exposed by the repository's root Swift Package.

## Products

- `SystemGlassTabView` — native platform tab navigation.
- `LiquidTabBar` — Floating and Morphing custom variants.
- `LiquidTabBarTheme` — presets and public visual tokens.
- `LiquidTabItem` — stable, generic tab metadata.

## Local package

Add the repository root through Xcode's **Add Local Package** command, then import it:

```swift
import LiquidUI
```

```swift
ContentView()
    .safeAreaInset(edge: .bottom, spacing: 0) {
        LiquidTabBar(
            selection: $selectedTab,
            items: items,
            variant: .floating,
            theme: .classic
        )
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
```

## Validation

```bash
swift test
```

The package has no third-party dependencies.
