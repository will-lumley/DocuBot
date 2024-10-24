// swift-tools-version: 6.0.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DocuBotViewModel",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "DocuBotViewModel",
            targets: ["DocuBotViewModel"]
        )
    ],
    dependencies: [
        .package(path: "../DocuBotModel"),
        .package(path: "../DocuBotService"),
        .package(path: "../DocuBotToolbox"),

        .package(
            url: "https://github.com/ZachNagengast/similarity-search-kit.git",
            from: "0.0.15"
        ),
        .package(url: "https://github.com/SwiftGen/SwiftGenPlugin", from: "6.6.2"),
        .package(
            url: "https://github.com/SFSafeSymbols/SFSafeSymbols",
            from: "4.0.0"
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "DocuBotViewModel",
            dependencies: [
                "DocuBotModel",
                "DocuBotService",
                "DocuBotToolbox",
                "SFSafeSymbols",
                .product(name: "SimilaritySearchKit", package: "similarity-search-kit")
            ],
            plugins: [
               .plugin(name: "SwiftGenPlugin", package: "SwiftGenPlugin")
            ]
        ),
        .testTarget(
            name: "DocuBotViewModelTests",
            dependencies: ["DocuBotViewModel"])
    ]
)
