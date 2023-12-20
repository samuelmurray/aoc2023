// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "aoc",
  dependencies: [
    .package(url: "https://github.com/apple/swift-algorithms", from: "1.2.0"),
    .package(url: "https://github.com/apple/swift-format", branch: "release/5.9"),
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
    .target(name: "Day06"),
    .target(name: "Day07"),
    .target(name: "Day08"),
    .target(name: "Day09"),
    .target(name: "Day10"),
    .target(
      name: "Day11", dependencies: [.product(name: "Algorithms", package: "swift-algorithms")]),
    .target(
      name: "Day12", dependencies: [.product(name: "Algorithms", package: "swift-algorithms")]),
    .target(
      name: "Day13", dependencies: [.product(name: "Algorithms", package: "swift-algorithms")]),
      .target(
      name: "Day14", dependencies: [.product(name: "Algorithms", package: "swift-algorithms")]),
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
    .testTarget(
      name: "Day06Tests",
      dependencies: ["Day06", "Utils"],
      resources: [
        .copy("Resources")
      ]
    ),
    .testTarget(
      name: "Day07Tests",
      dependencies: ["Day07", "Utils"],
      resources: [
        .copy("Resources")
      ]
    ),
    .testTarget(
      name: "Day08Tests",
      dependencies: ["Day08", "Utils"],
      resources: [
        .copy("Resources")
      ]
    ),
    .testTarget(
      name: "Day09Tests",
      dependencies: ["Day09", "Utils"],
      resources: [
        .copy("Resources")
      ]
    ),
    .testTarget(
      name: "Day10Tests",
      dependencies: ["Day10", "Utils"],
      resources: [
        .copy("Resources")
      ]
    ),
    .testTarget(
      name: "Day11Tests",
      dependencies: ["Day11", "Utils"],
      resources: [
        .copy("Resources")
      ]
    ),
    .testTarget(
      name: "Day12Tests",
      dependencies: ["Day12", "Utils"],
      resources: [
        .copy("Resources")
      ]
    ),
    .testTarget(
      name: "Day13Tests",
      dependencies: ["Day13", "Utils"],
      resources: [
        .copy("Resources")
      ]
    ),
    .testTarget(
      name: "Day14Tests",
      dependencies: ["Day14", "Utils"],
      resources: [
        .copy("Resources")
      ]
    ),
  ]
)
