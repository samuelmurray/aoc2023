// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "aoc",
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(name: "Utils"),
        .target(name: "Day01"),
        .target(name: "Day02"),
        .testTarget(
            name: "Day01Tests",
            dependencies: ["Day01", "Utils"]
        ),
        .testTarget(
            name: "Day02Tests",
            dependencies: ["Day02", "Utils"]
        ),
    ]
)
