# LiquidGlassDemo

A backend-free iPhone and iPad app for comparing the included tab bars.

Open `LiquidGlassDemo.xcodeproj`, choose the `LiquidGlassDemo` scheme, and run on an iOS Simulator.

The demo's top controls switch:

- System, Floating, and Morphing navigation;
- Classic and Graphite backgrounds.

The app reads `LiquidUI` from the repository root package. No package download or project setup is required.

Create saves or cancels a local sample; Focus toggles the preview; Share uses the system share sheet. All progress displays derive from the same 3/5 fixture. Recent rows are labeled sample content and have no decorative active buttons.

Choose the shared `IntegrationHost` scheme and run it to explore custom IDs, 2/3/5 items, Floating/Morphing, 320/375/420 pt widths, long labels, RTL, and XSmall through accessibility1–5. Reduced effects are selected in the Simulator's Settings app and their real values are displayed in the fixture. A Pro Max Simulator gives the 420 pt fixture enough physical space.

The shared `LiquidGlassDemo` scheme tests both applications. Run `Scripts/test_ui.sh` from the repository root to configure actual accessibility settings and retain `.xcresult` attachments. See [Validation](../../Docs/Validation.md).
