// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "SUFoundation",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
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
        .package(
            name: "Typesense",
            url: "https://github.com/typesense/typesense-swift",
            from: Version(0, 1, 0)
        )
    ],
    targets: [
        .target(
            name: "SUFoundation",
            dependencies: [
                .product(name: "FirebaseAuth", package: "Firebase"),
                .product(name: "FirebaseStorage", package: "Firebase"),
                .product(name: "FirebaseFirestore", package: "Firebase"),
                .product(name: "Typesense", package: "Typesense")
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
