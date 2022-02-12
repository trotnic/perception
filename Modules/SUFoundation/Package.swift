// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SUFoundation",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "SUFoundation",
            targets: [
                "SUFoundation",
            ]
        ),
    ],
    dependencies: [
        .package(
            name: "Firebase",
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            from: Version(8, 10, 0)
        ),
    ],
    targets: [
        .target(
            name: "SUFoundation",
            dependencies: [
                .product(name: "FirebaseAuth", package: "Firebase"),
                .product(name: "FirebaseStorage", package: "Firebase"),
                .product(name: "FirebaseFirestore", package: "Firebase"),
            ]
        ),
        .testTarget(
            name: "SUFoundationTests",
            dependencies: [
                "SUFoundation"
            ]
        ),
    ]
)
