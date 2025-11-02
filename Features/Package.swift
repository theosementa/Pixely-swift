// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Features",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "Albums", targets: ["Albums"]),
        .library(name: "Gallery", targets: ["Gallery"])
    ],
    targets: [
        .target(
            name: "Albums"
        ),
        .testTarget(name: "AlbumsTests", dependencies: ["Albums"]),
        
        .target(
            name: "Gallery"
        ),
        .testTarget(name: "GalleryTests", dependencies: ["Gallery"]),
    ]
)
