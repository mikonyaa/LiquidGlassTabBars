# Contributing

Liquid Glass Tab Bars accepts focused contributions that improve reuse, clarity, accessibility, or platform correctness.

## Before opening an issue

- Search existing issues.
- Include the Xcode, Swift, and OS versions.
- State whether the problem appears in System, Floating, or Morphing.
- For visual bugs, include light/dark mode and relevant accessibility settings.
- Provide a minimal reproduction when possible.

## Suggesting a component

A useful proposal describes:

1. The app problem the component solves.
2. Why a standard SwiftUI control is not enough.
3. Supported platforms and minimum OS.
4. Loading, empty, error, and accessibility states where relevant.
5. The smallest public API that would make it reusable.

## Pull requests

Keep each pull request narrow. A component contribution should normally include:

- implementation in `Packages/LiquidUI`;
- a deterministic demo or preview;
- tests for non-visual logic;
- documentation and a copy-paste example;
- iOS 26 behavior and an older-system fallback;
- no secrets, analytics, network requirement, or new dependency without prior discussion.

Run these checks before submitting:

```bash
swift test
xcodebuild \
  -project Examples/LiquidGlassDemo/LiquidGlassDemo.xcodeproj \
  -scheme LiquidGlassDemo \
  -destination 'generic/platform=iOS Simulator' \
  CODE_SIGNING_ALLOWED=NO \
  build
```

## Swift style

- Prefer SwiftUI state and composition over view models by default.
- Use semantic names and colors.
- Keep public initializers small and documented.
- Use SF Symbols unless an original asset is necessary.
- Comments should explain a decision or platform constraint, not restate code.
- Avoid `AnyView`, global mutable state, and custom blur stacks.

## Pull request checklist

- [ ] The package builds with Swift 6.
- [ ] Tests pass.
- [ ] The demo has no backend dependency.
- [ ] Reduce Motion and Reduce Transparency remain usable.
- [ ] Tap targets remain at least 44 points.
- [ ] New public API is documented.
- [ ] Screenshots or GIFs reflect the submitted code.
