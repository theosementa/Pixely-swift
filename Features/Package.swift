// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Features",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "Albums", targets: ["Albums"]),
        .library(name: "Gallery", targets: ["Gallery"]),
        .library(name: "Memories", targets: ["Memories"]),
        .library(name: "Settings", targets: ["Settings"])
    ],
    dependencies: [
        .package(path: "../Models"),
        .package(path: "../Stores"),
        .package(path: "../DesignSystem")        
    ],
    targets: [
        .target(
            name: "Albums",
            dependencies: [
                "Models",
                "Stores",
                "DesignSystem"
            ]
        ),
        .testTarget(name: "AlbumsTests", dependencies: ["Albums"]),
        
        .target(
            name: "Gallery",
            dependencies: [
                "Models",
                "Stores",
                "DesignSystem"
            ]
        ),
        .testTarget(name: "GalleryTests", dependencies: ["Gallery"]),
        
        .target(
            name: "Memories",
            dependencies: [
                "Models",
                "Stores",
                "DesignSystem"
            ]
        ),
        .testTarget(name: "MemoriesTests", dependencies: ["Memories"]),
        
        .target(
            name: "Settings",
            dependencies: [
                "Models",
                "Stores",
                "DesignSystem"
            ]
        ),
        .testTarget(name: "SettingsTests", dependencies: ["Settings"]),
    ]
)
