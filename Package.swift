// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "aoc",
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(name: "utils"),
        .target(name: "d01"),
        .target(name: "d02"),
        .testTarget(
            name: "d01Tests",
            dependencies: ["d01", "utils"]
        ),
        .testTarget(
            name: "d02Tests",
            dependencies: ["d02", "utils"]
        ),
    ]
)
