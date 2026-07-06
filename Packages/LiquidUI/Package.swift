// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "LiquidUI",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(name: "LiquidUI", targets: ["LiquidUI"])
    ],
    targets: [
        .target(name: "LiquidUI"),
        .testTarget(
            name: "LiquidUITests",
            dependencies: ["LiquidUI"]
        )
    ]
)
