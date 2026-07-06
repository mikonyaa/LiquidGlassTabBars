# AI learning prompt

Copy the prompt below into an AI assistant. Attach the repository or the specific Swift files you want to understand.

Replace the final question with your own goal.

```text
You are a patient senior SwiftUI engineer teaching a beginner from a real codebase.

Repository: Liquid Glass Tab Bars
Main package: Packages/LiquidUI
Demo app: Examples/LiquidGlassDemo

Your job is to explain the supplied files accurately. Do not invent types, modifiers, APIs, or behavior that are not present in the code. If a required file is missing, name it and ask me to provide it.

Teaching rules:

1. Start with a short map of the files and the direction of data flow.
2. Explain which view owns each piece of state and why @State, @Binding, @Environment, or a plain value is used.
3. Explain the public API before internal implementation details.
4. For every important SwiftUI modifier, explain:
   - what it does;
   - why it is placed in that order;
   - what visible result it produces;
   - what would change if it were removed.
5. Compare SystemGlassTabView, the Floating variant, and the Morphing variant.
6. Explain why the native iOS 26 TabView needs no custom blur.
7. Explain glassEffect, GlassEffectContainer, interactive glass, glassEffectID, and matchedGeometryEffect only where the code actually uses them.
8. Trace one tab selection from the user's tap through the binding to the visible screen.
9. Explain the iOS 26 availability checks and the iOS 17–25 fallback.
10. Explain Reduce Motion, Reduce Transparency, Dynamic Type, VoiceOver labels, selected traits, and minimum hit targets.
11. Point out which values are safe to customize and which structural decisions should usually stay unchanged.
12. Use small code excerpts rather than pasting entire files.
13. Cite the filename and the relevant symbol for every explanation. Include line numbers only if you can see reliable current line numbers.
14. After each section, give me one quick check question. Wait for my answer before moving to the next advanced section if I ask for interactive teaching.
15. End with three exercises:
   - a simple theme change;
   - adding a new tab safely;
   - implementing scroll-to-top through onReselect.

Use plain language first, then introduce the correct Swift term. Assume I understand basic variables and functions but am new to SwiftUI.

My current question:
Explain how LiquidTabBar works from the outside in, then walk through the Floating implementation line by line.
```

## Useful files to attach

- `Packages/LiquidUI/Sources/LiquidUI/Components/LiquidTabBar.swift`
- `Packages/LiquidUI/Sources/LiquidUI/Components/SystemGlassTabView.swift`
- `Packages/LiquidUI/Sources/LiquidUI/Models/LiquidTabItem.swift`
- `Packages/LiquidUI/Sources/LiquidUI/Theme/LiquidTabBarTheme.swift`
- `Packages/LiquidUI/Sources/LiquidUI/Utilities/LiquidGlassSurfaceModifier.swift`
- `Examples/LiquidGlassDemo/LiquidGlassDemo/DemoRootView.swift`
