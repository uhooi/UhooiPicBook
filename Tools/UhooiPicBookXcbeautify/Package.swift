// swift-tools-version:5.4
import PackageDescription

let package = Package(
    name: "UhooiPicBookXcbeautify",
    platforms: [
        .macOS(.v11)
    ],
    dependencies: [
        .package(url: "https://github.com/thii/xcbeautify", .exact("0.9.1"))
    ],
    targets: [.target(name: "UhooiPicBookXcbeautify", path: "")]
)
