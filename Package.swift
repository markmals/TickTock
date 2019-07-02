// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TickTock",
    platforms: [.macOS(.v10_12), .iOS(.v11), .tvOS(.v11), .watchOS(.v4)],
    products: [
        .library(
            name: "TickTock",
            targets: ["TickTock"]),
    ],
    dependencies: [
        .package(url: "https://github.com/objcio/tiny-networking", .branch("master")),
        // .package(url: "https://github.com/guillermomuntaner/Burritos", from: "0.0.2")
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
