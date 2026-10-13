import LiquidUI
import SwiftUI

struct DemoFixture {
    let completed = 3
    let total = 5
    var sampleTitle: String?
    var isFocusActive = false

    var fraction: Double { Double(completed) / Double(total) }
    var percentage: Int { Int((fraction * 100).rounded()) }
    var progressDescription: String { "\(completed) of \(total) sample items complete" }
    var shareText: String {
        "Liquid Glass Tab Bars sample: \(progressDescription) (\(percentage)%)."
    }
}

enum DemoTab: String, CaseIterable, Identifiable, Sendable {
    case home
    case activity
    case library
    case profile

    var id: String { rawValue }

    var title: String {
        switch self {
        case .home: "Home"
        case .activity: "Activity"
        case .library: "Library"
        case .profile: "Profile"
        }
    }

    var systemImage: String {
        switch self {
        case .home: "house.fill"
        case .activity: "waveform.path.ecg"
        case .library: "square.grid.2x2.fill"
        case .profile: "person.crop.circle.fill"
        }
    }

    var headline: String {
        switch self {
        case .home: "A clear view of today"
        case .activity: "Your momentum"
        case .library: "Saved for later"
        case .profile: "Make it yours"
        }
    }

    var message: String {
        switch self {
        case .home: "Keep the controls light and let the content lead."
        case .activity: "Small, meaningful signals work better than visual noise."
        case .library: "A flexible surface for collections, media, or projects."
        case .profile: "Colors, spacing, icons, and motion are all configurable."
        }
    }

    var liquidItem: LiquidTabItem<DemoTab> {
        LiquidTabItem(id: self, title: title, systemImage: systemImage)
    }
}

enum DemoBarStyle: String, CaseIterable, Identifiable {
    case system
    case floating
    case morphing

    var id: String { rawValue }

    var title: String {
        switch self {
        case .system: "System"
        case .floating: "Floating"
        case .morphing: "Morphing"
        }
    }

    var symbol: String {
        switch self {
        case .system: "apple.logo"
        case .floating: "capsule.fill"
        case .morphing: "circle.grid.3x3.fill"
        }
    }
}

enum DemoPalette: String, CaseIterable, Identifiable {
    case classic
    case graphite

    var id: String { rawValue }

    var title: String {
        rawValue.capitalized
    }

    var theme: LiquidTabBarTheme {
        switch self {
        case .classic: .classic
        case .graphite: .neutral
        }
    }
}
