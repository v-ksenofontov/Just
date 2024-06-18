// swift-tools-version:5.8

import PackageDescription

let package = Package(
    name: "Just",
    products: [
        .library(name: "Just", targets: ["Just"]),
        .library(name: "Just-Static", type: .static, targets: ["Just"]),
        .library(name: "Just-Dynamic", type: .dynamic, targets: ["Just"])
    ],
    targets: [
        .target(name: "Just"),
        .testTarget(name: "JustTests", dependencies: ["Just"])
    ]
)
