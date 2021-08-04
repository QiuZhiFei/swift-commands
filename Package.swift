// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "swift-commands",
  products: [
    .library(name: "Commands", targets: ["Commands"]),
  ],
  dependencies: [],
  targets: [
    .target(name: "Commands", dependencies: []),
    .target(name: "Examples", dependencies: ["Commands"], path: "Examples/"),
    .testTarget(name: "CommandsTests", dependencies: ["Commands"])
  ]
)
