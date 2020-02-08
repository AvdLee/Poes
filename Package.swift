// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Poes",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .executable(name: "Poes", targets: ["Poes"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-package-manager.git", from: "0.1.0")
    ],
    targets: [
        .target(name: "Poes", dependencies: ["PoesCore"]),
        .target(name: "PoesCore", dependencies: ["SPMUtility"]),
        .testTarget(name: "PoesTests", dependencies: ["PoesCore"]),
    ]
)
