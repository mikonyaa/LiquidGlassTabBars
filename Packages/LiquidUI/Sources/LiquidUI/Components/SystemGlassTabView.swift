import SwiftUI

public struct SystemGlassTabView<SelectionValue: Hashable, Content: View>: View {
    @Binding private var selection: SelectionValue
    private let tint: Color
    private let content: Content

    public init(
        selection: Binding<SelectionValue>,
        tint: Color = .accentColor,
        @ViewBuilder content: () -> Content
    ) {
        self._selection = selection
        self.tint = tint
        self.content = content()
    }

    public var body: some View {
        TabView(selection: $selection) {
            content
        }
        .tint(tint)
    }
}
