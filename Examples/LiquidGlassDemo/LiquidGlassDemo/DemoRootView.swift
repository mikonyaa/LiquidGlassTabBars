import LiquidUI
import SwiftUI

struct DemoRootView: View {
    @State private var selectedTab: DemoTab = .home
    @State private var barStyle: DemoBarStyle = .system
    @State private var palette: DemoPalette = .classic

    private let showcaseMode = ProcessInfo.processInfo.arguments.contains("--showcase")

    private var items: [LiquidTabItem<DemoTab>] {
        DemoTab.allCases.map(\.liquidItem)
    }

    var body: some View {
        ZStack(alignment: .top) {
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
                    withAnimation(.spring(response: 0.34, dampingFraction: 0.84)) {
                        barStyle = style
                    }
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

        await pause(nanoseconds: 1_000_000_000)

        while !Task.isCancelled {
            setShowcaseState(tab: .home, style: .system, palette: .classic)
            await pause(nanoseconds: 1_400_000_000)

            withAnimation(.spring(response: 0.32, dampingFraction: 0.84)) {
                selectedTab = .activity
            }
            await pause(nanoseconds: 1_100_000_000)

            setShowcaseState(tab: .home, style: .floating, palette: .graphite)
            await pause(nanoseconds: 1_300_000_000)

            withAnimation(.spring(response: 0.32, dampingFraction: 0.82)) {
                selectedTab = .library
            }
            await pause(nanoseconds: 1_200_000_000)

            setShowcaseState(tab: .activity, style: .morphing, palette: .classic)
            await pause(nanoseconds: 1_300_000_000)

            withAnimation(.spring(response: 0.32, dampingFraction: 0.82)) {
                selectedTab = .profile
            }
            await pause(nanoseconds: 1_500_000_000)
        }
    }

    @MainActor
    private func setShowcaseState(
        tab: DemoTab,
        style: DemoBarStyle,
        palette: DemoPalette
    ) {
        withAnimation(.easeInOut(duration: 0.32)) {
            selectedTab = tab
            barStyle = style
            self.palette = palette
        }
    }

    private func pause(nanoseconds: UInt64) async {
        try? await Task.sleep(nanoseconds: nanoseconds)
    }
}

#Preview {
    DemoRootView()
}
