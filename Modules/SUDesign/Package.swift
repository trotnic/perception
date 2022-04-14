// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "SUDesign",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "SUDesign",
            targets: ["SUDesign"]
        )
    ],
    targets: [
        .target(
            name: "SUDesign",
            dependencies: []),
        .testTarget(
            name: "SUDesignTests",
            dependencies: ["SUDesign"]
        )
    ]
)
