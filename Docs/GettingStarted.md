# Getting started

## 1. Open the demo

Open `Examples/LiquidGlassDemo/LiquidGlassDemo.xcodeproj` in Xcode 26 or newer.

The project uses the repository root package. Xcode resolves it automatically; no network download is required.

Select:

- Scheme: `LiquidGlassDemo`
- Destination: an iPhone or iPad Simulator
- Configuration: Debug

Run with `⌘R`.

If Xcode reports that the iOS platform is not installed, open **Xcode → Settings → Components** and install the Simulator runtime matching your Xcode version.

## 2. Explore the variants

The left control at the top of the demo changes the navigation implementation:

- **System** uses SwiftUI `TabView`.
- **Floating** uses one custom glass capsule.
- **Morphing** uses grouped interactive glass controls.

The right control changes the palette without changing component code.

## 3. Add the package locally

In another Xcode project:

1. Choose **File → Add Package Dependencies**.
2. Click **Add Local**.
3. Select the `LiquidGlassTabBars` repository root.
4. Add the `LiquidUI` product to the app target.
5. Write `import LiquidUI` in the consuming file.

## 4. Choose the correct component

Use `SystemGlassTabView` when the standard tab bar meets the design. This is the recommended default on iOS 26.

Use `LiquidTabBar` when the app specifically needs:

- a detached floating dock;
- a selected label that appears only for the active tab;
- a morphing group of compact controls;
- a product-specific placement or visual rhythm.

Keep custom bars between two and five items. For more destinations, use `SystemGlassTabView` and let the system own overflow and adaptation.

## 5. Verify accessibility

In Simulator, test:

- Settings → Accessibility → Display & Text Size → Reduce Transparency;
- Settings → Accessibility → Motion → Reduce Motion;
- Settings → Display & Brightness → Text Size;
- light and dark appearances if your app supports both.

The demo intentionally uses dark mode to make the glass behavior easy to compare. The package itself uses semantic foreground colors and can be used in either appearance.
