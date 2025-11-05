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
        .library(name: "Settings", targets: ["Settings"]),
        .library(name: "PhotoAsset", targets: ["PhotoAsset"])
    ],
    dependencies: [
        .package(path: "../Models"),
        .package(path: "../Stores"),
        .package(path: "../DesignSystem"),
        .package(path: "../Utilities"),
        .package(path: "../Navigation"),
        
        .package(url: "https://github.com/pointfreeco/swift-dependencies", exact: "1.10.0"),
        .package(url: "https://github.com/izyumkin/MCEmojiPicker", branch: "1.2.5")
    ],
    targets: [
        .target(
            name: "Albums",
            dependencies: [
                "Models",
                "Stores",
                "DesignSystem",
                "Navigation",
                "Utilities",
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "MCEmojiPicker", package: "MCEmojiPicker")
            ]
        ),
        .testTarget(name: "AlbumsTests", dependencies: ["Albums"]),
        
        .target(
            name: "Gallery",
            dependencies: [
                "Models",
                "Stores",
                "DesignSystem",
                "PhotoAsset",
                "Navigation"
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
        
        .target(
            name: "PhotoAsset",
            dependencies: [
                "Models",
                "Stores",
                "DesignSystem",
                "Utilities"
            ],
            swiftSettings: [
                .swiftLanguageMode(.v6),
                .enableUpcomingFeature("StrictConcurrency")
            ]
        ),
        .testTarget(name: "PhotoAssetTests", dependencies: ["PhotoAsset"])
    ]
)
