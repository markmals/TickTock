// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

var package = Package(
    name: "TickTock",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6)],
    products: [
        .library(
            name: "TickTock",
            targets: ["TickTock"]),
    ],
    targets: [
        .target(name: "TickTock"),
        .testTarget(
            name: "TickTockTests",
            dependencies: ["TickTock"]),
    ]
)

//#if !os(iOS) && !os(macOS) && !os(tvOS) && !os(watchOS)
//package.dependencies.append(.package(url: "https://github.com/broadwaylamb/OpenCombine", .branch("master")))
//package.targets.first?.dependencies.append("OpenCombine")
//#endif
