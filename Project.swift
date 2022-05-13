import ProjectDescription

let infoPlist: [String: InfoPlist.Value] = [
    "UILaunchStoryboardName" : "Perception",
    "UISupportedInterfaceOrientations" : [
      "UIInterfaceOrientationPortrait"
    ]
]

let project = Project(
  name: "Perception",
  organizationName: "Star Unicorn",
  packages: [
    .remote(
      url: "https://github.com/vadymmarkov/Fakery.git",
      requirement: .upToNextMajor(from: .init(5, 1, 0))
    ),
    .remote(
      url: "https://github.com/frzi/SwiftUIRouter.git",
      requirement: .upToNextMajor(from: .init(1, 3, 1))
    ),
    .remote(
      url: "https://github.com/kean/Nuke.git",
      requirement: .upToNextMajor(from: .init(10, 9, 0))
    ),
    .package(path: "Modules/SUDesign"),
    .package(path: "Modules/SUFoundation"),
  ],
  targets: [
    Target(
      name: "Perception-iOS",
      platform: .iOS,
      product: .app,
      bundleId: "com.staruco.perception",
      deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
      infoPlist: .extendingDefault(
        with: infoPlist
      ),
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
        .package(product: "Nuke")
      ]
    ),
    Target(
      name: "Perception-macOS",
      platform: .macOS,
      product: .app,
      bundleId: "com.staruco.perception",
      deploymentTarget: .macOS(targetVersion: "12.0"),
      infoPlist: .extendingDefault(
        with: infoPlist
      ),
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
        .target(name: "Perception-iOS")
      ]
    )
  ]
)
