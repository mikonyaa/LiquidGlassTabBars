# Architecture

The first release has two layers: a reusable package and a disposable example app.

## LiquidUI package

`LiquidTabItem`

: A small value type containing stable identity, visible title, and SF Symbol name. It does not know anything about app routing or screens.

`SystemGlassTabView`

: A thin wrapper around `TabView`. Its purpose is educational and consistent tint injection. It deliberately does not draw custom glass.

`LiquidTabBar`

: A custom navigation control that owns layout and selection animation, but not screen content. The consuming app owns the `selection` binding.

`LiquidTabBarTheme`

: Semantic visual tokens. A theme can be replaced without subclassing or implementing a styling protocol.

`LiquidGlassSurfaceModifier`

: The availability and accessibility boundary. iOS 26 uses `glassEffect`; earlier systems use material; Reduce Transparency uses an opaque fallback.

## Demo app

`DemoRootView` owns three values:

- selected tab;
- selected bar style;
- selected palette.

No view model is needed. These are local UI values and SwiftUI `@State` is the narrowest correct owner.

`DemoScreen` is sample content. It has no network, persistence, authentication, or dependency container. This keeps previews deterministic and lets contributors focus on navigation behavior.

## What stays outside the package

The system implementation uses a normal SwiftUI `TabView`. The custom variants exist for products that need a distinct interaction while retaining accessible fallbacks.

This repository preserves that useful split, but the public components are independent and generic:

- no application-specific names, routes, themes, services, or backend code;
- stable generic identifiers instead of integer indexes;
- public theme configuration;
- standalone accessibility behavior;
- no app-specific dependencies.

## Data flow

```text
App-owned selection binding
          │
          ▼
 SystemGlassTabView  or  LiquidTabBar
          │                   │
          │                   ├── LiquidTabItem values
          │                   ├── LiquidTabBarTheme
          │                   └── optional onReselect
          ▼
 App chooses the visible screen
```

The package never creates a global router. A real app can connect the selection binding to local state, an `@Observable` router, deep links, or state restoration.
