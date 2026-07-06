# Customization

## Change icons and labels

Create `LiquidTabItem` values with your own stable IDs and SF Symbols:

```swift
let tabs = [
    LiquidTabItem(id: AppTab.inbox, title: "Inbox", systemImage: "tray.fill"),
    LiquidTabItem(id: AppTab.search, title: "Search", systemImage: "magnifyingglass"),
    LiquidTabItem(id: AppTab.profile, title: "Profile", systemImage: "person.fill")
]
```

Keep the number of primary destinations small. If everything becomes a tab, the hierarchy is probably unclear.

## Change the palette

`LiquidTabBarTheme` exposes only values that materially affect the controls:

| Value | Purpose |
| --- | --- |
| `tint` | Selected item and meaningful emphasis |
| `inactiveForeground` | Unselected symbols and labels |
| `fallbackFill` | Opaque surface for Reduce Transparency |
| `fallbackBorder` | Separation on material and opaque surfaces |
| `selectedFillOpacity` | Selected pill strength in Floating |
| `selectedBorderOpacity` | Selected pill edge strength |
| `shadowColor` | Separation from content |
| `shadowRadius` | Shadow softness |
| `itemSpacing` | Distance and morph threshold in Morphing |

Prefer semantic colors where possible. Test custom colors over both bright and dark content.

## Change corner shapes

The included bars use capsules because they match compact touch controls. If your app needs a rounded rectangle, edit the shape in `LiquidTabBar.swift` and keep the same shape across the glass effect, content shape, border, and matched selection.

Changing only one of those shapes produces mismatched hit testing or clipping.

## Change motion

Selection uses one spring:

```swift
.spring(response: 0.32, dampingFraction: 0.82)
```

Adjust it in small increments. A tab switch should communicate state, not delay navigation. The animation is automatically removed when Reduce Motion is enabled.

## Add reselect behavior

Use `onReselect` for actions such as scroll-to-top:

```swift
LiquidTabBar(
    selection: $selectedTab,
    items: items,
    onReselect: { tab in
        if tab == .home {
            scrollToTopTrigger += 1
        }
    }
)
```

Do not hide unrelated actions behind a second tap on the active tab.

## Replace demo content

The component does not own screen content. Replace `DemoScreen` with your app's root content and place `LiquidTabBar` in a bottom `safeAreaInset`.

This keeps scrolling content clear of the control without hard-coded bottom padding.
