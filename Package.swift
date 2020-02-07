// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Push",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .executable(name: "Push", targets: ["Push"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-package-manager.git", from: "0.1.0")
    ],
    targets: [
        .target(name: "Push", dependencies: ["PushCore"]),
        .target(name: "PushCore", dependencies: ["SPMUtility"]),
        .testTarget(name: "PushTests", dependencies: ["PushCore"]),
    ]
)
