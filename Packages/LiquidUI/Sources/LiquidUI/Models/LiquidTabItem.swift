import Foundation

public struct LiquidTabItem<ID: Hashable & Sendable>: Identifiable, Hashable, Sendable {
    public let id: ID
    public let title: String
    public let systemImage: String

    public init(id: ID, title: String, systemImage: String) {
        self.id = id
        self.title = title
        self.systemImage = systemImage
    }
}

public enum LiquidTabBarVariant: String, CaseIterable, Identifiable, Sendable {
    case floating
    case morphing

    public var id: String { rawValue }
}
