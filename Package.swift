// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.
// We're hiding dev, test, and danger dependencies with // dev to make sure they're not fetched by users of this package.

import PackageDescription

let package = Package(
    name: "Poes",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        // dev .library(name: "DangerDeps", type: .dynamic, targets: ["DangerDependencies"]),
        .executable(name: "Poes", targets: ["Poes"])
    ],
    dependencies: [
        // dev .package(url: "https://github.com/danger/swift", from: "3.0.0"),
        // dev .package(path: "Submodules/WeTransfer-iOS-CI/Danger-Swift"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.0.1")
    ],
    targets: [
        // dev .testTarget(name: "PoesTests", dependencies: ["PoesCore"]),
        // dev .target(name: "DangerDependencies", dependencies: ["Danger", "WeTransferPRLinter"], path: "Submodules/WeTransfer-iOS-CI/Danger-Swift", sources: ["DangerFakeSource.swift"]),
        .target(name: "Poes", dependencies: ["PoesCore"]),
        .target(name: "PoesCore", dependencies: ["ArgumentParser"])
    ]
)
