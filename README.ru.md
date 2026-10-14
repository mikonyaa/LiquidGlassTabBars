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
- Swift Package `LiquidUI` без внешних зависимостей и единственным root `Package.swift`.
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

Custom Floating и Morphing варианты рассчитаны на 2–5 основных разделов. Для большего количества используйте `SystemGlassTabView`, чтобы overflow и adaptation оставались системными.

Если приоритетом являются системное поведение и автоматическая адаптация, используйте `SystemGlassTabView`. На iOS 26 стекло такого tab bar рисует сама система через обычный SwiftUI `TabView`.

![Демонстрация tab bar](Assets/GIFs/liquid-tab-bars.gif)

Подробности находятся в английском [README.md](README.md) и папке [Docs](Docs).

## Контракты и проверка

Каждой вкладке нужен уникальный стабильный ID. `selection` должен входить в `items`; при изменении списка приложение само выбирает допустимый ID. Компонент не заменяет selection автоматически. Пустой список не рисует контрол, а недопустимый selection не выделяет вкладку.

Для 2–5 вкладок оставьте не менее 320 pt ширины **после внешних отступов**. При тесном layout или большом Dynamic Type Morphing переходит к капсулам равной ширины. Видимое название может сокращаться, но accessibility label всегда содержит полный текст. Размер текста и высота продолжают масштабироваться. Для меньшей ширины используйте системный вариант.

При Reduce Transparency `fallbackFill` накладывается на непрозрачный адаптивный системный фон. Даже `.clear` и цвета с alpha не пропускают контент под контролом. Обычное стекло и material fallback сохраняются.

Create открывает локальный sample sheet с сохранением или отменой. Focus явно включает и выключает preview state. Share открывает системное меню с sample-текстом. Текст, процент и кольцо используют одну модель: 3 из 5, то есть 60%. Это демонстрационные данные без постоянного хранения.

```bash
Scripts/test_ui.sh
Scripts/validate_consumers.sh
```

Первый скрипт создаёт собственный симулятор, меняет его реальные настройки доступности через Settings и удаляет только свой simulator. В shared scheme включены public-API host, hosted pixel tests и UI tests. [Матрица проверок и оставшиеся gates](Docs/Validation.md) отделяют Simulator от физического iPhone и независимого integration pilot.

## Лицензия

[MIT](LICENSE).
