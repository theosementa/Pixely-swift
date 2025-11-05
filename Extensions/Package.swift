// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Extensions",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "Extensions",
            targets: ["Extensions"]
        )
    ],
    targets: [
        .target(
            name: "Extensions"
        )
    ]
)
