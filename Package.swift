// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "aoc",
  dependencies: [
    .package(url: "https://github.com/apple/swift-format.git", branch: "release/5.9")
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(name: "Utils"),
    .target(name: "Day01"),
    .target(name: "Day02"),
    .target(name: "Day03"),
    .target(name: "Day04"),
    .target(name: "Day05"),
    .testTarget(
      name: "UtilsTests",
      dependencies: ["Utils"],
      resources: [
        .copy("Resources")
      ]
    ),
    .testTarget(
      name: "Day01Tests",
      dependencies: ["Day01", "Utils"],
      resources: [
        .copy("Resources")
      ]
    ),
    .testTarget(
      name: "Day02Tests",
      dependencies: ["Day02", "Utils"],
      resources: [
        .copy("Resources")
      ]
    ),
    .testTarget(
      name: "Day03Tests",
      dependencies: ["Day03", "Utils"],
      resources: [
        .copy("Resources")
      ]
    ),
    .testTarget(
      name: "Day04Tests",
      dependencies: ["Day04", "Utils"],
      resources: [
        .copy("Resources")
      ]
    ),
    .testTarget(
      name: "Day05Tests",
      dependencies: ["Day05", "Utils"],
      resources: [
        .copy("Resources")
      ]
    ),
  ]
)
