// swift-tools-version: 6.0.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DocuBotUI",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "DocuBotUI",
            targets: ["DocuBotUI"])
    ],
    dependencies: [
        .package(path: "../DocuBotViewModel"),
        .package(path: "../DocuBotToolbox"),
        .package(url: "https://github.com/SwiftGen/SwiftGenPlugin", from: "6.6.2"),
        .package(url: "https://github.com/gonzalezreal/swift-markdown-ui", from: "2.4.1"),
        .package(
            url: "https://github.com/SwiftfulThinking/SwiftfulLoadingIndicators.git",
            from: "0.0.4"
        )
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

                .product(name: "MarkdownUI", package: "swift-markdown-ui")
            ],
            plugins: [
               .plugin(name: "SwiftGenPlugin", package: "SwiftGenPlugin")
            ]
        ),
        .testTarget(
            name: "DocuBotUITests",
            dependencies: ["DocuBotUI"])
    ]
)
