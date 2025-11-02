// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Repositories",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "Repositories", targets: ["Repositories"])
    ],
    dependencies: [
        .package(path: "../Models"),
        .package(path: "../Persistence")
    ],
    targets: [
        .target(
            name: "Repositories",
            dependencies: [
                "Models",
                "Persistence"
            ]
        ),
        .testTarget(name: "RepositoriesTests", dependencies: ["Repositories"])
    ]
)
