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

Custom Floating and Morphing variants support two to five primary destinations. If the product needs more, use `SystemGlassTabView`; if everything becomes a tab, the hierarchy is probably unclear.

IDs must be unique and stable. Selection must belong to the current items; the app owns any selection update when items change. No automatic repair or persistence is performed. An empty items array renders nothing; invalid selection highlights nothing.

For 2–5 items, provide at least 320 pt after outer padding. Morphing measures the expanding row first and uses equal-width individual capsules when it cannot fit. Compact spacing is capped at 8 pt to keep hit targets separate. Selected titles may truncate visually; VoiceOver receives the full title. Dynamic Type scales text and height in both layouts. Below 320 pt, use the system variant or validate your specific placement separately.

## Change the palette

`LiquidTabBarTheme` exposes only values that materially affect the controls:

| Value | Purpose |
| --- | --- |
| `tint` | Selected item and meaningful emphasis |
| `inactiveForeground` | Unselected symbols and labels |
| `fallbackFill` | Color composited over opaque adaptive system backing in Reduce Transparency |
| `fallbackBorder` | Separation on material and opaque surfaces |
| `selectedFillOpacity` | Selected pill strength in Floating |
| `selectedBorderOpacity` | Selected pill edge strength |
| `shadowColor` | Separation from content |
| `shadowRadius` | Shadow softness |
| `itemSpacing` | Distance and morph threshold in Morphing |

Prefer semantic colors where possible. Test custom colors over both bright and dark content.

The backing uses `secondarySystemBackground` on iOS and `controlBackgroundColor` on macOS. A translucent `fallbackFill` blends with that backing, not the content underneath. Violet and Ocean are fully opaque in reduced-transparency mode despite their preset alpha. The initializer and all existing theme parameters remain source compatible. Normal glass/material mode is unaffected.

## Change corner shapes

The included bars use capsules because they match compact touch controls. If your app needs a rounded rectangle, edit the shape in `LiquidTabBar.swift` and keep the same shape across the glass effect, content shape, border, and matched selection.

Changing only one of those shapes produces mismatched hit testing or clipping.

## Change motion

Selection uses one spring:

```swift
.spring(response: 0.32, dampingFraction: 0.82)
```

Adjust it in small increments. A tab switch should communicate state, not delay navigation. Reduce Motion removes the spring transaction and disables descendant animations. Native morphing IDs are omitted in this mode. The normal spring remains when Reduce Motion is off. The integration host records the actual binding transaction rather than testing only a policy helper.

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
