// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "UhooiPicBookTools",
    platforms: [
        .macOS(.v12),
    ],
    dependencies: [
        .package(url: "https://github.com/realm/SwiftLint", exact: "0.47.1"),
        .package(url: "https://github.com/IBDecodable/IBLinter", exact: "0.5.0"),
        .package(url: "https://github.com/fromkk/SpellChecker", exact: "0.1.0"),
        .package(url: "https://github.com/uber/mockolo", exact: "1.7.1"),
        .package(url: "https://github.com/mono0926/LicensePlist", exact: "3.19.1"),
        .package(url: "https://github.com/tuist/xcbeautify", exact: "0.11.0"),
    ],
    targets: [.target(name: "UhooiPicBookTools", path: "")]
)
