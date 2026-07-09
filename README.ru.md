# Liquid Glass Tab Bars

Открытые SwiftUI-шаблоны и переиспользуемые элементы интерфейса для современных Apple-приложений.

Проект вдохновлён дизайн-языком Apple Liquid Glass, но не связан с Apple и не является официальным UI kit.

## Что уже есть

- Нативный системный `TabView`, который получает Liquid Glass на iOS 26 автоматически.
- Кастомный плавающий tab bar в одной стеклянной капсуле.
- Morphing-вариант с отдельными интерактивными стеклянными кнопками.
- Четыре темы компонентов и два спокойных demo-фона: Classic и Graphite.
- Fallback для iOS 17–25.
- Поддержка Dynamic Type, Reduce Motion и Reduce Transparency.
- Готовое приложение `LiquidGlassDemo.xcodeproj`.
- Swift Package `LiquidUI` без внешних зависимостей.
- Тесты, previews и обучающая документация.

## Запуск

Откройте проект:

```bash
open Examples/LiquidGlassDemo/LiquidGlassDemo.xcodeproj
```

Выберите схему `LiquidGlassDemo`, iOS Simulator и нажмите `⌘R`.

Для проверки пакета:

```bash
swift test
```

## Базовое использование

```swift
LiquidTabBar(
    selection: $selectedTab,
    items: items,
    variant: .floating,
    theme: .violet
)
```

Замените `.floating` на `.morphing`, чтобы получить раскрывающуюся активную вкладку.

Если приоритетом являются системное поведение и автоматическая адаптация, используйте `SystemGlassTabView`. На iOS 26 стекло такого tab bar рисует сама система через обычный SwiftUI `TabView`.

![Демонстрация tab bar](Assets/GIFs/liquid-tab-bars.gif)

Подробности находятся в английском [README.md](README.md) и папке [Docs](Docs).

## Лицензия

[MIT](LICENSE).
