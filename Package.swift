// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Pathable",
    products: [
        .library(
            name: "Pathable",
            targets: ["Pathable"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Pathable",
            dependencies: []),
        .testTarget(
            name: "PathableTests",
            dependencies: ["Pathable"]),
    ]
)
