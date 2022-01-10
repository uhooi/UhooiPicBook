// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "UhooiPicBookTools",
    platforms: [
        .macOS(.v11)
    ],
    dependencies: [
        .package(url: "https://github.com/realm/SwiftLint", .exact("0.45.0")),
        .package(url: "https://github.com/IBDecodable/IBLinter", .exact("0.4.27")),
        .package(url: "https://github.com/fromkk/SpellChecker", .exact("0.1.0")),
        .package(url: "https://github.com/uber/mockolo", .exact("1.6.2")),
        .package(url: "https://github.com/mono0926/LicensePlist", .exact("3.14.4")),
        .package(url: "https://github.com/thii/xcbeautify", .exact("0.10.1")),
    ],
    targets: [.target(name: "UhooiPicBookTools", path: "")]
)
