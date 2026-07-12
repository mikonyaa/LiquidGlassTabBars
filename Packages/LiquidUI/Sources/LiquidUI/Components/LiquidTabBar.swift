import SwiftUI

public struct LiquidTabBar<ID: Hashable & Sendable>: View {
    @Binding private var selection: ID
    private let items: [LiquidTabItem<ID>]
    private let variant: LiquidTabBarVariant
    private let theme: LiquidTabBarTheme
    private let onReselect: ((ID) -> Void)?

    @Namespace private var selectionNamespace
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @ScaledMetric(relativeTo: .body) private var barHeight: CGFloat = 60
    @ScaledMetric(relativeTo: .body) private var minimumItemHeight: CGFloat = 48

    public init(
        selection: Binding<ID>,
        items: [LiquidTabItem<ID>],
        variant: LiquidTabBarVariant = .floating,
        theme: LiquidTabBarTheme = .init(),
        onReselect: ((ID) -> Void)? = nil
    ) {
        self._selection = selection
        self.items = items
        self.variant = variant
        self.theme = theme
        self.onReselect = onReselect
    }

    public var body: some View {
        Group {
            if items.isEmpty {
                EmptyView()
            } else {
                switch variant {
                case .floating:
                    floatingBar
                case .morphing:
                    morphingBar
                }
            }
        }
        .accessibilityElement(children: .contain)
    }

    private var floatingBar: some View {
        HStack(spacing: 2) {
            ForEach(items) { item in
                floatingButton(for: item)
            }
        }
        .frame(height: minimumItemHeight)
        .padding(6)
        .frame(height: barHeight)
        .liquidGlassSurface(in: Capsule(), theme: theme)
        .shadow(color: theme.shadowColor, radius: theme.shadowRadius, y: 8)
    }

    private func floatingButton(for item: LiquidTabItem<ID>) -> some View {
        let isSelected = selection == item.id

        return Button {
            select(item)
        } label: {
            ZStack {
                if isSelected {
                    Capsule()
                        .fill(theme.tint.opacity(theme.selectedFillOpacity))
                        .overlay {
                            Capsule().stroke(
                                theme.tint.opacity(theme.selectedBorderOpacity),
                                lineWidth: 1
                            )
                        }
                        .matchedGeometryEffect(
                            id: "liquid-tab-selection",
                            in: selectionNamespace
                        )
                }

                VStack(spacing: 2) {
                    Image(systemName: item.systemImage)
                        .font(.system(size: 19, weight: .semibold))

                    if isSelected {
                        Text(item.title)
                            .font(.caption2.weight(.semibold))
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }
                }
                .foregroundStyle(isSelected ? theme.tint : theme.inactiveForeground)
                .padding(.horizontal, 6)
                .padding(.vertical, 6)
            }
            .frame(maxWidth: .infinity)
            .frame(height: minimumItemHeight)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(item.title)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    @ViewBuilder
    private var morphingBar: some View {
        #if compiler(>=6.2)
        if #available(iOS 26.0, macOS 26.0, *) {
            GlassEffectContainer(spacing: theme.itemSpacing) {
                morphingItems
            }
        } else {
            morphingItems
        }
        #else
        morphingItems
        #endif
    }

    private var morphingItems: some View {
        HStack(spacing: theme.itemSpacing) {
            ForEach(items) { item in
                morphingButton(for: item)
            }
        }
        .shadow(color: theme.shadowColor, radius: theme.shadowRadius, y: 8)
    }

    @ViewBuilder
    private func morphingButton(for item: LiquidTabItem<ID>) -> some View {
        let isSelected = selection == item.id
        let button = Button {
            select(item)
        } label: {
            HStack(spacing: 7) {
                Image(systemName: item.systemImage)
                    .font(.system(size: 18, weight: .semibold))

                if isSelected {
                    Text(item.title)
                        .font(.subheadline.weight(.semibold))
                        .lineLimit(1)
                        .transition(.opacity.combined(with: .scale(scale: 0.92)))
                }
            }
            .foregroundStyle(isSelected ? theme.tint : theme.inactiveForeground)
            .padding(.horizontal, isSelected ? 16 : 14)
            .frame(minWidth: minimumItemHeight, minHeight: barHeight)
            .contentShape(Capsule())
        }
        .buttonStyle(.plain)
        .liquidGlassSurface(
            in: Capsule(),
            tint: isSelected ? theme.tint.opacity(0.22) : nil,
            isInteractive: true,
            theme: theme
        )
        .accessibilityLabel(item.title)
        .accessibilityAddTraits(isSelected ? .isSelected : [])

        #if compiler(>=6.2)
        if #available(iOS 26.0, macOS 26.0, *) {
            button.glassEffectID(item.id, in: selectionNamespace)
        } else {
            button
        }
        #else
        button
        #endif
    }

    private func select(_ item: LiquidTabItem<ID>) {
        if LiquidTabSelection.isReselection(current: selection, candidate: item.id) {
            onReselect?(item.id)
            return
        }

        let animation = LiquidAccessibilityBehavior.animatesSelection(reduceMotion: reduceMotion)
            ? Animation.spring(response: 0.32, dampingFraction: 0.82)
            : nil
        withAnimation(animation) {
            selection = item.id
        }
    }
}
