// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "SpringKit",
    platforms: [
        .iOS(.v26)
    ],
    products: [
        .library(
            name: "SpringKit",
            type: .dynamic,
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
        ),
        .plugin(
            name: "BuildXCFramework",
            capability: .command(
                intent: .custom(
                    verb: "build-xcframework",
                    description: "Build SpringKit.xcframework for iOS device and Simulator"
                ),
                permissions: [
                    .writeToPackageDirectory(reason: "Writes XCFramework and build artifacts to build/")
                ]
            )
        )
    ]
)
