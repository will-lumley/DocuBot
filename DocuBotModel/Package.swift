// swift-tools-version: 6.0.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DocuBotModel",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "DocuBotModel",
            targets: ["DocuBotModel"]
        )
    ],
    dependencies: [
        .package(path: "../DocuBotToolbox"),

        .package(url: "https://github.com/ZachNagengast/similarity-search-kit.git", from: "0.0.15"),
        .package(url: "https://github.com/SwiftGen/SwiftGenPlugin", from: "6.6.2")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "DocuBotModel",
            dependencies: [
                "DocuBotToolbox",
                .product(name: "SimilaritySearchKit", package: "similarity-search-kit"),
                .product(name: "SimilaritySearchKitDistilbert", package: "similarity-search-kit"),
                .product(name: "SimilaritySearchKitMiniLMMultiQA", package: "similarity-search-kit"),
                .product(name: "SimilaritySearchKitMiniLMAll", package: "similarity-search-kit")
            ],
            plugins: [
               .plugin(name: "SwiftGenPlugin", package: "SwiftGenPlugin")
            ]
        ),
        .testTarget(
            name: "DocuBotModelTests",
            dependencies: [
                "DocuBotModel",

                .product(name: "SimilaritySearchKit", package: "similarity-search-kit"),
                .product(name: "SimilaritySearchKitDistilbert", package: "similarity-search-kit"),
                .product(name: "SimilaritySearchKitMiniLMMultiQA", package: "similarity-search-kit"),
                .product(name: "SimilaritySearchKitMiniLMAll", package: "similarity-search-kit")
            ],
            resources: [
                .copy("Resources/test.pdf"),
                .copy("Resources/test.rtf")
            ]
        )
    ]
)
