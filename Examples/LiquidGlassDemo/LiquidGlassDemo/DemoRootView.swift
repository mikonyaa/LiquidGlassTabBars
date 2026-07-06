import LiquidUI
import SwiftUI
import UIKit

struct DemoRootView: View {
    @State private var selectedTab: DemoTab
    @State private var barStyle: DemoBarStyle
    @State private var palette: DemoPalette
    @State private var transitionSnapshot: UIImage?
    @State private var transitionSnapshotOpacity = 0.0
    @State private var transitionID = UUID()

    private let showcaseMode: Bool

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
                DemoScreen(tab: tab, palette: palette)
                    .tabItem {
                        Label(tab.title, systemImage: tab.systemImage)
                    }
                    .tag(tab)
            }
        }
    }

    private var customTabs: some View {
        DemoScreen(tab: selectedTab, palette: palette)
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
            }
    }

    @ViewBuilder
    private var controlPanel: some View {
        let panel = HStack(spacing: 10) {
            styleMenu

            Spacer(minLength: 12)

            paletteMenu
        }
        .padding(.horizontal, 14)
        .frame(height: 50)

        panel
            .background(
                Color(red: 0.12, green: 0.125, blue: 0.14),
                in: RoundedRectangle(cornerRadius: 22)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 22)
                    .stroke(.white.opacity(0.12), lineWidth: 0.75)
            }
            .shadow(color: .black.opacity(0.16), radius: 12, y: 5)
    }

    private var styleMenu: some View {
        Menu {
            ForEach(DemoBarStyle.allCases) { style in
                Button {
                    changePresentation(
                        tab: selectedTab,
                        style: style,
                        palette: palette
                    )
                } label: {
                    Label(
                        style.title,
                        systemImage: barStyle == style ? "checkmark" : style.symbol
                    )
                }
            }
        } label: {
            Label(barStyle.title, systemImage: barStyle.symbol)
                .font(.subheadline.weight(.semibold))
        }
        .accessibilityLabel("Tab bar style")
    }

    private var paletteMenu: some View {
        Menu {
            ForEach(DemoPalette.allCases) { candidate in
                Button {
                    withAnimation(.easeInOut(duration: 0.24)) {
                        palette = candidate
                    }
                } label: {
                    Label(
                        candidate.title,
                        systemImage: palette == candidate ? "checkmark" : "circle.fill"
                    )
                }
            }
        } label: {
            Label(palette.title, systemImage: "paintpalette.fill")
                .font(.subheadline.weight(.semibold))
        }
        .accessibilityLabel("Color palette")
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

            changePresentation(tab: .home, style: .floating, palette: .graphite)
            await pause(milliseconds: 1_650)

            withAnimation(.spring(response: 0.32, dampingFraction: 0.82)) {
                selectedTab = .library
            }
            await pause(milliseconds: 1_150)

            changePresentation(tab: .activity, style: .morphing, palette: .classic)
            await pause(milliseconds: 1_650)

            withAnimation(.spring(response: 0.32, dampingFraction: 0.82)) {
                selectedTab = .profile
            }
            await pause(milliseconds: 1_150)

            changePresentation(tab: .home, style: .system, palette: .classic)
            await pause(milliseconds: 600)
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
            self.palette = palette
        }

        Task { @MainActor in
            await pause(milliseconds: 60)

            guard transitionID == currentTransitionID else { return }

            withAnimation(.easeInOut(duration: 0.48)) {
                transitionSnapshotOpacity = 0
            }

            await pause(milliseconds: 520)

            guard transitionID == currentTransitionID else { return }
            transitionSnapshot = nil
        }
    }

    private func pause(milliseconds: UInt64) async {
        try? await Task.sleep(nanoseconds: milliseconds * 1_000_000)
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
