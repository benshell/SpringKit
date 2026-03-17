// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "SpringKit",
    platforms: [
        .iOS(.v26)
    ],
    products: [
        .library(
            name: "SpringKit",
            targets: ["SpringKit"]
        )
    ],
    targets: [
        .target(
            name: "SpringKit",
            resources: [
                .process("Colors/Resources/SpringColorAssets.xcassets"),
                .process("Typography/Resources/Fonts")
            ]
        ),
        .testTarget(
            name: "SpringKitTests",
            dependencies: ["SpringKit"]
        )
    ]
)
