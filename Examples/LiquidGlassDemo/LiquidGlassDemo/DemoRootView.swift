import LiquidUI
import SwiftUI
import UIKit

struct DemoRootView: View {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @State private var selectedTab: DemoTab
    @State private var barStyle: DemoBarStyle
    @State private var palette: DemoPalette
    @State private var fixture = DemoFixture()
    @State private var transitionSnapshot: UIImage?
    @State private var transitionSnapshotOpacity = 0.0
    @State private var transitionID = UUID()
    @State private var controlPanelHeight: CGFloat = 50

    private let showcaseMode: Bool
    private let accessibilityControls: Bool

    init() {
        let arguments = ProcessInfo.processInfo.arguments

        let initialTab: DemoTab
        if arguments.contains("--activity") {
            initialTab = .activity
        } else if arguments.contains("--library") {
            initialTab = .library
        } else if arguments.contains("--profile") {
            initialTab = .profile
        } else {
            initialTab = .home
        }

        let initialStyle: DemoBarStyle
        if arguments.contains("--floating") {
            initialStyle = .floating
        } else if arguments.contains("--morphing") {
            initialStyle = .morphing
        } else {
            initialStyle = .system
        }

        _selectedTab = State(initialValue: initialTab)
        _barStyle = State(initialValue: initialStyle)
        _palette = State(initialValue: arguments.contains("--graphite") ? .graphite : .classic)
        showcaseMode = arguments.contains("--showcase")
        accessibilityControls = arguments.contains("--accessibility-controls")
    }

    private var items: [LiquidTabItem<DemoTab>] {
        DemoTab.allCases.map(\.liquidItem)
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color(red: 0.04, green: 0.045, blue: 0.052)
                .ignoresSafeArea()

            if barStyle == .system {
                systemTabs
            } else {
                customTabs
            }

            controlPanel
                .dynamicTypeSize(accessibilityControls ? .accessibility5 : dynamicTypeSize)
                .frame(width: accessibilityControls ? 320 : nil)
                .onGeometryChange(for: CGFloat.self) { $0.size.height } action: { controlPanelHeight = $0 }
                .padding(.horizontal, 16)
                .padding(.top, 8)
        }
        .preferredColorScheme(.dark)
        .task {
            await runShowcaseIfNeeded()
        }
        .overlay {
            if let transitionSnapshot {
                Image(uiImage: transitionSnapshot)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .opacity(transitionSnapshotOpacity)
                    .mask {
                        VStack(spacing: 0) {
                            Rectangle().frame(height: 140)
                            Spacer(minLength: 0)
                            Rectangle().frame(height: 140)
                        }
                        .ignoresSafeArea()
                    }
                    .allowsHitTesting(false)
                    .accessibilityHidden(true)
            }
        }
    }

    private var systemTabs: some View {
        SystemGlassTabView(
            selection: $selectedTab,
            tint: palette.theme.tint
        ) {
            ForEach(DemoTab.allCases) { tab in
                DemoScreen(tab: tab, palette: palette, fixture: $fixture, controlPanelHeight: controlPanelHeight)
                    .tabItem {
                        Label(tab.title, systemImage: tab.systemImage)
                    }
                    .tag(tab)
            }
        }
    }

    private var customTabs: some View {
        DemoScreen(tab: selectedTab, palette: palette, fixture: $fixture, controlPanelHeight: controlPanelHeight)
            .safeAreaInset(edge: .bottom, spacing: 0) {
                LiquidTabBar(
                    selection: $selectedTab,
                    items: items,
                    variant: barStyle == .floating ? .floating : .morphing,
                    theme: palette.theme
                )
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 6)
                .offset(y: 16)
            }
    }

    @ViewBuilder
    private var controlPanel: some View {
        let panel = ViewThatFits(in: .horizontal) {
            HStack(spacing: 10) {
                styleMenu.fixedSize(horizontal: true, vertical: false)
                Spacer(minLength: 12)
                paletteMenu.fixedSize(horizontal: true, vertical: false)
            }
            VStack(alignment: .leading, spacing: 6) {
                styleMenu
                paletteMenu
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 3)

        panel
            .background(
                Color(red: 0.12, green: 0.125, blue: 0.14),
                in: RoundedRectangle(cornerRadius: 22)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 22)
                    .stroke(.white.opacity(0.12), lineWidth: 0.75)
                    .allowsHitTesting(false)
            }
            .shadow(color: .black.opacity(0.16), radius: 12, y: 5)
    }

    private var styleMenu: some View {
        DemoMenuButton(
            name: "Tab bar style", title: barStyle.title, symbol: barStyle.symbol,
            choices: DemoBarStyle.allCases.map { style in
                DemoMenuButton.Choice(title: style.title, symbol: style.symbol, selected: barStyle == style) {
                    changePresentation(
                        tab: selectedTab,
                        style: style,
                        palette: palette
                    )
                }
            }
        )
    }

    private var paletteMenu: some View {
        DemoMenuButton(
            name: "Color palette", title: palette.title, symbol: "paintpalette.fill",
            choices: DemoPalette.allCases.map { candidate in
                DemoMenuButton.Choice(title: candidate.title, symbol: "circle.fill", selected: palette == candidate) {
                    changePresentation(
                        tab: selectedTab,
                        style: barStyle,
                        palette: candidate
                    )
                }
            }
        )
    }

    @MainActor
    private func runShowcaseIfNeeded() async {
        guard showcaseMode else { return }

        await pause(milliseconds: 2_600)

        while !Task.isCancelled {
            await pause(milliseconds: 1_600)

            withAnimation(.spring(response: 0.32, dampingFraction: 0.84)) {
                selectedTab = .activity
            }
            await pause(milliseconds: 1_150)

            changePresentation(tab: selectedTab, style: .floating, palette: .graphite)
            await pause(milliseconds: 1_650)

            withAnimation(.spring(response: 0.32, dampingFraction: 0.82)) {
                selectedTab = .library
            }
            await pause(milliseconds: 1_150)

            changePresentation(tab: selectedTab, style: .morphing, palette: .classic)
            await pause(milliseconds: 1_650)

            withAnimation(.spring(response: 0.32, dampingFraction: 0.82)) {
                selectedTab = .profile
            }
            await pause(milliseconds: 1_150)

            withAnimation(.spring(response: 0.32, dampingFraction: 0.82)) {
                selectedTab = .home
            }
            await pause(milliseconds: 1_150)

            changePresentation(tab: selectedTab, style: .system, palette: .classic)
            await pause(milliseconds: 1_200)
        }
    }

    @MainActor
    private func changePresentation(
        tab: DemoTab,
        style: DemoBarStyle,
        palette: DemoPalette
    ) {
        guard tab != selectedTab || style != barStyle || palette != self.palette else { return }

        guard !UIAccessibility.isReduceMotionEnabled else {
            selectedTab = tab
            barStyle = style
            self.palette = palette
            return
        }

        let currentTransitionID = UUID()
        transitionID = currentTransitionID
        transitionSnapshot = LiquidWindowSnapshot.capture()
        transitionSnapshotOpacity = 1

        var transaction = Transaction()
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            selectedTab = tab
            barStyle = style
        }

        withAnimation(.easeInOut(duration: 0.60)) {
            self.palette = palette
        }

        Task { @MainActor in
            await pause(milliseconds: 60)

            guard transitionID == currentTransitionID else { return }

            withAnimation(.easeInOut(duration: 0.60)) {
                transitionSnapshotOpacity = 0
            }

            await pause(milliseconds: 650)

            guard transitionID == currentTransitionID else { return }
            transitionSnapshot = nil
        }
    }

    private func pause(milliseconds: UInt64) async {
        try? await Task.sleep(nanoseconds: milliseconds * 1_000_000)
    }
}

@MainActor
private struct DemoMenuButton: UIViewRepresentable {
    struct Choice {
        let title: String
        let symbol: String
        let selected: Bool
        let action: @MainActor () -> Void
    }

    let name: String
    let title: String
    let symbol: String
    let choices: [Choice]

    func makeUIView(context: Context) -> UIButton {
        let button = UIButton(type: .system)
        button.showsMenuAsPrimaryAction = true
        button.isAccessibilityElement = true
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        return button
    }

    func updateUIView(_ button: UIButton, context: Context) {
        var configuration = UIButton.Configuration.plain()
        configuration.title = title
        configuration.titleLineBreakMode = .byTruncatingTail
        configuration.image = UIImage(systemName: symbol)
        configuration.imagePadding = 6
        configuration.contentInsets = .zero
        configuration.baseForegroundColor = .systemBlue
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(textStyle: .subheadline)
        let traits = UITraitCollection(preferredContentSizeCategory: context.environment.dynamicTypeSize.uiCategory)
        let preferredFont = UIFont.preferredFont(forTextStyle: .subheadline, compatibleWith: traits)
        let descriptor = preferredFont.fontDescriptor.addingAttributes([
            .traits: [UIFontDescriptor.TraitKey.weight: UIFont.Weight.semibold.rawValue]
        ])
        let font = UIFont(descriptor: descriptor, size: 0)
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { attributes in
            var result = attributes
            result.font = font
            return result
        }
        button.configuration = configuration
        button.accessibilityLabel = name
        button.accessibilityValue = title
        button.menu = UIMenu(children: choices.map { choice in
            UIAction(
                title: choice.title, image: UIImage(systemName: choice.symbol),
                state: choice.selected ? .on : .off
            ) { _ in choice.action() }
        })
        button.invalidateIntrinsicContentSize()
    }

    func sizeThatFits(_ proposal: ProposedViewSize, uiView: UIButton, context: Context) -> CGSize? {
        let size = uiView.intrinsicContentSize
        return CGSize(
            width: min(max(44, size.width), max(44, proposal.width ?? size.width)),
            height: min(max(44, size.height), max(44, proposal.height ?? size.height))
        )
    }
}

private extension DynamicTypeSize {
    var uiCategory: UIContentSizeCategory {
        switch self {
        case .xSmall: .extraSmall
        case .small: .small
        case .medium: .medium
        case .large: .large
        case .xLarge: .extraLarge
        case .xxLarge: .extraExtraLarge
        case .xxxLarge: .extraExtraExtraLarge
        case .accessibility1: .accessibilityMedium
        case .accessibility2: .accessibilityLarge
        case .accessibility3: .accessibilityExtraLarge
        case .accessibility4: .accessibilityExtraExtraLarge
        case .accessibility5: .accessibilityExtraExtraExtraLarge
        @unknown default: .large
        }
    }
}

@MainActor
private enum LiquidWindowSnapshot {
    static func capture() -> UIImage? {
        let window = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first(where: \.isKeyWindow)

        guard let window else { return nil }

        return UIGraphicsImageRenderer(bounds: window.bounds).image { _ in
            window.drawHierarchy(in: window.bounds, afterScreenUpdates: false)
        }
    }
}

#Preview {
    DemoRootView()
}
