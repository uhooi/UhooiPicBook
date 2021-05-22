// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "Tools",
    platforms: [
        .macOS(.v11)
    ],
    dependencies: [
        .package(url: "https://github.com/realm/SwiftLint", .exact("0.43.1")),
        .package(url: "https://github.com/thii/xcbeautify", .exact("0.9.1"))
    ],
    targets: [.target(name: "Tools", path: "")]
)
