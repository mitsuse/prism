// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "Prism",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "Prism",
            targets: ["Prism"]
        ),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Prism",
            dependencies: []
        ),
        .testTarget(
            name: "PrismTests",
            dependencies: ["Prism"]
        ),
    ]
)
