// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "LiquidGlassTabBars",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(name: "LiquidUI", targets: ["LiquidUI"])
    ],
    targets: [
        .target(
            name: "LiquidUI",
            path: "Packages/LiquidUI/Sources/LiquidUI"
        ),
        .testTarget(
            name: "LiquidUITests",
            dependencies: ["LiquidUI"],
            path: "Packages/LiquidUI/Tests/LiquidUITests"
        )
    ]
)
