// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

var package = Package(
    name: "TickTock",
    platforms: [.macOS(.v10_12), .iOS(.v11), .tvOS(.v11), .watchOS(.v4)],
    products: [
        .library(
            name: "TickTock",
            targets: ["TickTock"]),
    ],
    dependencies: [
        .package(url: "https://github.com/objcio/tiny-networking", .branch("master"))
    ],
    targets: [
        .target(
            name: "TickTock",
            dependencies: ["TinyNetworking"]),
        .testTarget(
            name: "TickTockTests",
            dependencies: ["TickTock"]),
    ]
)

// #if !os(iOS) && !os(macOS) && !os(tvOS) && !os(watchOS)
package.dependencies.append(.package(url: "https://github.com/broadwaylamb/OpenCombine", .branch("master")))
package.targets.first?.dependencies.append("OpenCombine")
// #endif
