// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DocuBotService",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "DocuBotService",
            targets: ["DocuBotService"]),
    ],
    dependencies: [
        .package(path: "../DocuBotModel"),
        .package(path: "../DocuBotToolbox"),
        .package(url: "https://github.com/SwiftGen/SwiftGenPlugin", from: "6.6.2")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "DocuBotService",
            plugins: [
               .plugin(name: "SwiftGenPlugin", package: "SwiftGenPlugin")
            ]
        ),
        .testTarget(
            name: "DocuBotServiceTests",
            dependencies: ["DocuBotService"]),
    ]
)
