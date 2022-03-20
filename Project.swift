import ProjectDescription

let infoPlist: [String: InfoPlist.Value] = [
    "UILaunchScreen": [:]
]

let project = Project(
    name: "Perception",
    organizationName: "Star Unicorn",
    packages: [
        .remote(url: "https://github.com/vadymmarkov/Fakery.git", requirement: .upToNextMajor(from: .init(5, 1, 0))),
        .remote(url: "https://github.com/frzi/SwiftUIRouter.git", requirement: .upToNextMajor(from: .init(1, 3, 1))),
//        .remote(url: "https://github.com/trotnic/SwiftUIRouter.git", requirement: .branch("main")),
        .package(path: "Modules/SUDesign"),
        .package(path: "Modules/SUFoundation"),
    ],
    targets: [
        Target(
            name: "Perception",
            platform: .iOS,
            product: .app,
            bundleId: "com.staruco.perception",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            infoPlist: .extendingDefault(with: infoPlist),
            sources: [
                "Sources/**",
            ],
            resources: [
                "Resources/**",
            ],
            scripts: [
                .post(script: "./Scripts/lint.sh", name: "SwiftLint")
            ],
            dependencies: [
                .package(product: "Fakery"),
                .package(product: "SwiftUIRouter"),
                .package(product: "SUDesign"),
                .package(product: "SUFoundation"),
            ],
            coreDataModels: [
                CoreDataModel(.relativeToCurrentFile("Sources/Model/Persistance/CoreData/Perception.xcdatamodeld"), currentVersion: "Perception")
            ]
        ),
        Target(
            name: "PerceptionTests",
            platform: .iOS,
            product: .unitTests,
            bundleId: "com.staruco.perception-tests",
            infoPlist: .default,
            sources: [
                "Tests/**"
            ],
            dependencies: [
                .target(name: "Perception")
            ]
        )
    ]
)
