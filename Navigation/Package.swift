// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Navigation",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "Navigation",
            targets: ["Navigation"]
        ),
    ],
    dependencies: [
        .package(path: "../Models"),
        .package(url: "https://github.com/theosementa/NavigationKit", branch: "2.0.6")
    ],
    targets: [
        .target(
            name: "Navigation",
            dependencies: [
                "Models",
                .product(name: "NavigationKit", package: "NavigationKit")
            ]
        ),

    ]
)
