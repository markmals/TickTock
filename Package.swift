// swift-tools-version:5.2

import PackageDescription

var package = Package(
    name: "TickTock",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6)],
    products: [
        .library(name: "TickTock", targets: ["TickTock"])
    ],
    dependencies: [
        .package(url: "https://github.com/markmals/Resty", from: "0.2.8"),
        .package(url: "https://github.com/groue/CombineExpectations", from: "0.5.0")
    ],
    targets: [
        .target(name: "TickTock", dependencies: ["Resty"]),
        .testTarget(name: "TickTockTests", dependencies: ["TickTock", "CombineExpectations"]),
    ]
)
