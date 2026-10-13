import LiquidUI
import SwiftUI

@main
struct IntegrationHostApp: App {
    var body: some Scene {
        WindowGroup {
            IntegrationFixture()
        }
    }
}

struct IntegrationFixture: View {
    @State private var count: Int
    @State private var variant: LiquidTabBarVariant
    @State private var width: Double
    @State private var dynamicType: DynamicTypeSize
    @State private var longLabels: Bool
    @State private var rightToLeft: Bool
    @State private var selection = 101
    @State private var writes = 0
    @State private var reselections = 0
    @State private var animated = false
    @State private var animationsDisabled = false
    @Environment(\.accessibilityReduceMotion) private var systemMotion
    @Environment(\.accessibilityReduceTransparency) private var systemTransparency

    private let arguments = ProcessInfo.processInfo.arguments
    private let identifiers = [101, 203, 305, 407, 509]
    private static let typeSizes: [DynamicTypeSize] = [
        .large, .accessibility1, .accessibility2, .accessibility3, .accessibility4, .accessibility5
    ]

    init() {
        let arguments = ProcessInfo.processInfo.arguments
        func value(_ key: String, default fallback: String) -> String {
            guard let index = arguments.firstIndex(of: key), index + 1 < arguments.count else {
                return fallback
            }
            return arguments[index + 1]
        }
        _count = State(initialValue: Int(value("--count", default: "5")) ?? 5)
        _width = State(initialValue: Double(value("--width", default: "320")) ?? 320)
        _variant = State(initialValue: value("--variant", default: "morphing") == "floating" ? .floating : .morphing)
        let typeIndex = Int(value("--dynamic-type", default: arguments.contains("--access") ? "3" : "0")) ?? 0
        _dynamicType = State(initialValue: Self.typeSizes[min(max(typeIndex, 0), 5)])
        _longLabels = State(initialValue: arguments.contains("--long"))
        _rightToLeft = State(initialValue: arguments.contains("--rtl"))
        _selection = State(initialValue: Int(value("--selection", default: "101")) ?? 101)
    }

    private var items: [LiquidTabItem<Int>] {
        identifiers.prefix(count).enumerated().map { index, identifier in
            LiquidTabItem(
                id: identifier,
                title: longLabels ? "Destination \(index + 1) with a very long localized title" : "Tab \(index + 1)",
                systemImage: "\(index + 1).circle.fill"
            )
        }
    }

    var body: some View {
        VStack(spacing: 12) {
            Text("Public API integration fixture").font(.headline)
            controls
            HStack {
                status("selection", selection)
                status("writes", writes)
                status("reselections", reselections)
            }
            HStack {
                status("animated", animated ? 1 : 0)
                status("disabled", animationsDisabled ? 1 : 0)
                status("systemRT", systemTransparency ? 1 : 0)
                status("systemRM", systemMotion ? 1 : 0)
            }
            Button("Select last externally") { selection = identifiers[count - 1] }
                .font(.caption)
            ScrollView {
                LiquidTabBar(
                    selection: Binding(get: { selection }, set: { value, transaction in
                        writes += 1
                        animated = transaction.animation != nil
                        animationsDisabled = transaction.disablesAnimations
                        selection = value
                    }),
                    items: items,
                    variant: variant,
                    theme: .violet,
                    onReselect: arguments.contains("--no-callback") ? nil : { _ in reselections += 1 }
                )
                .frame(width: width)
                .environment(\.dynamicTypeSize, dynamicType)
                .environment(\.layoutDirection, rightToLeft ? .rightToLeft : .leftToRight)
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.top, 12)
        .background(Color.orange.opacity(0.25))
    }

    private var controls: some View {
        VStack {
            HStack {
                Picker("Count", selection: $count) {
                    ForEach([2, 3, 5], id: \.self) { Text("\($0)").tag($0) }
                }
                Picker("Variant", selection: $variant) {
                    Text("Floating").tag(LiquidTabBarVariant.floating)
                    Text("Morphing").tag(LiquidTabBarVariant.morphing)
                }
                Picker("Width", selection: $width) {
                    ForEach([320.0, 375.0, 420.0], id: \.self) { Text("\(Int($0))").tag($0) }
                }
            }
            HStack {
                Picker("Text size", selection: $dynamicType) {
                    ForEach(Array(Self.typeSizes.enumerated()), id: \.offset) { index, size in
                        Text(index == 0 ? "Large" : "Access\(index)").tag(size)
                    }
                }
                Toggle("Long", isOn: $longLabels)
                Toggle("RTL", isOn: $rightToLeft)
            }
            Text("Choose reduced effects in Settings → Accessibility. System values appear below.")
                .font(.caption2)
        }
        .font(.caption)
        .padding(.horizontal, 12)
        .onChange(of: count) { _, _ in selection = 101 }
    }

    private func status(_ name: String, _ value: Int) -> some View {
        Text("\(name): \(value)")
            .font(.system(size: 11))
            .accessibilityIdentifier(name)
    }
}
