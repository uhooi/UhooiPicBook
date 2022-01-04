// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "UhooiPicBookPackage",
    defaultLocalization: "ja",
    platforms: [
        .iOS(.v14),
        .macOS(.v10_15),
    ],
    products: [
        .library(name: "GedatsuSetup", targets: ["GedatsuSetup"]),
    ],
    dependencies: [
        .package(url: "https://github.com/bannzai/Gedatsu", from: "1.2.0"),
    ],
    targets: [
        .target(
            name: "GedatsuSetup",
            dependencies: [
                .product(name: "Gedatsu", package: "Gedatsu"),
            ]
        ),
    ]
)
