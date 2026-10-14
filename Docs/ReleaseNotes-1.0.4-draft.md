# 1.0.4 — draft release notes

Status: unreleased candidate. Publication of a branch/PR does not create this release or complete the manual device checklist.

Reduce Transparency now guarantees opaque backing, including translucent custom fallback colors. Morphing adapts to equal-width capsules when expanding labels cannot fit, preserving full accessibility labels and 44 pt targets. Floating exposes one button label without separate visual child elements, keeping RTL selection and reselection reachable. Reduce Motion removes selection spring and native morphing IDs.

The demo's local Create/Focus/Share controls now produce visible results and support cancellation. Progress text and ring share the 3/5 (60%) fixture. Style/palette menus expose their current values and 44 pt targets. Recent rows are explicitly sample content.

The shared scheme adds a public-API integration host with real accessibility settings, pixel and tap/geometry tests. Release tooling adds two external package consumers, SemVer tag CI, checksum-pinned XcodeGen, isolated capture, provenance and owned-resource cleanup.

## Compatibility and migration

Expected SemVer category: **patch**, correcting documented behavior. `LiquidUI`, `LiquidTabItem`, `LiquidTabBar`, `SystemGlassTabView`, `LiquidTabBarTheme`, generic IDs, selection binding, `onReselect` and old initializer signatures remain. Swift tools 6.0, iOS 17/macOS 14 and zero external runtime dependencies are unchanged. No migration code is required.

Custom fallback colors with alpha now blend over the system backing in reduced-transparency mode; apps should review foreground contrast for this intentional accessibility correction. Compact morphing may truncate the selected visible title. Give 2–5 custom items at least 320 pt after outer padding, and use stable unique IDs with a valid caller-owned selection. Use the system tab view for narrower placement or overflow.

See [Validation](Validation.md) for reproducible gates and the uncompleted physical-device, minimum-OS and independent pilot checklist.

## По-русски

Исправлены непрозрачная поверхность при Reduce Transparency, переполнение Morphing и отключение анимации при Reduce Motion. Create, Focus и Share работают локально, прогресс согласован: 3/5 = 60%. Добавлены public-API host, реальные настройки доступности, внешние consumers и воспроизводимые scripts/CI.

Это patch-кандидат без изменения публичных initializer, имени `LiquidUI`, Binding/IDs/callback и minimum OS. Код миграции не нужен; для custom alpha-тем нужно проверить контраст на новом непрозрачном backing. Проверки физического iPhone, iOS 17 runtime и независимого integration pilot не считаются выполненными автоматически.
