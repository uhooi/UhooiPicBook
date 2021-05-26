// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "UhooiPicBookTools",
    platforms: [
        .macOS(.v11)
    ],
    dependencies: [
        .package(url: "https://github.com/yonaskolb/XcodeGen", .exact("2.23.0")),
        .package(url: "https://github.com/realm/SwiftLint", .exact("0.43.1")),
        .package(url: "https://github.com/IBDecodable/IBLinter", .exact("0.4.27")),
        .package(url: "https://github.com/fromkk/SpellChecker", .exact("0.1.0")),
        // .package(url: "https://github.com/uber/mockolo", .exact("1.4.0")),
        .package(url: "https://github.com/mono0926/LicensePlist", .exact("3.0.7")),
        .package(url: "https://github.com/mac-cain13/R.swift", .exact("5.4.0")),
        .package(url: "https://github.com/thii/xcbeautify", .exact("0.9.1"))
    ],
    targets: [.target(name: "UhooiPicBookTools", path: "")]
)
