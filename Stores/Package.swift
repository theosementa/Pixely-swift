// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Stores",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "Stores", targets: ["Stores"])
    ],
    dependencies: [
        .package(path: "../Repositories"),
        .package(path: "../Models"),
        
        .package(url: "https://github.com/pointfreeco/swift-dependencies", exact: "1.10.0")
    ],
    targets: [
        .target(
            name: "Stores",
            dependencies: [
                "Repositories",
                "Models",
                .product(name: "Dependencies", package: "swift-dependencies")
            ]
        ),
        .testTarget(
            name: "StoresTests",
            dependencies: ["Stores"]
        )
    ]
)
