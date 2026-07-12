enum LiquidTabSelection {
    static func isReselection<ID: Equatable>(current: ID, candidate: ID) -> Bool {
        current == candidate
    }
}

enum LiquidAccessibilityBehavior {
    static func animatesSelection(reduceMotion: Bool) -> Bool {
        !reduceMotion
    }

    static func usesOpaqueSurface(reduceTransparency: Bool) -> Bool {
        reduceTransparency
    }
}
