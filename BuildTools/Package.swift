// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "BuildTools",
    platforms: [
        .macOS(.v11)
    ],
    dependencies: [
        .package(url: "https://github.com/realm/SwiftLint", .exact("0.43.1")),
        .package(url: "https://github.com/IBDecodable/IBLinter", .exact("0.4.25")),
        .package(url: "https://github.com/mono0926/LicensePlist", .exact("3.0.7")),
        .package(url: "https://github.com/mac-cain13/R.swift", .exact("5.4.0")),
        .package(url: "https://github.com/thii/xcbeautify", .exact("0.9.1"))
    ],
    targets: [
        .target(
            name: "BuildTools",
            path: "",
            exclude: [
                "R.swift/Examples"
            ]
        )
    ]
)
