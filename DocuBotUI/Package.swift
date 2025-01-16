// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DocuBotUI",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "DocuBotUI",
            targets: ["DocuBotUI"]),
    ],
    dependencies: [
        .package(path: "../DocuBotViewModel"),
        .package(path: "../DocuBotToolbox"),
        .package(url: "https://github.com/SwiftGen/SwiftGenPlugin", from: "6.6.2"),
        .package(url: "https://github.com/airbnb/lottie-ios.git", from: "4.4.3"),
        .package(url: "https://github.com/SwiftfulThinking/SwiftfulLoadingIndicators.git", from: "0.0.4"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "DocuBotUI",
            dependencies: [
                "DocuBotViewModel",
                "DocuBotToolbox",
                "SwiftfulLoadingIndicators",

                .product(name: "Lottie", package: "lottie-ios"),
            ],
            plugins: [
               .plugin(name: "SwiftGenPlugin", package: "SwiftGenPlugin")
            ]
        ),
        .testTarget(
            name: "DocuBotUITests",
            dependencies: ["DocuBotUI"]),
    ]
)
