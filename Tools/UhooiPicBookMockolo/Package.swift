// swift-tools-version:5.4
import PackageDescription

let package = Package(
    name: "UhooiPicBookMockolo",
    platforms: [
        .macOS(.v11)
    ],
    dependencies: [
        .package(url: "https://github.com/uber/mockolo", .exact("1.6.1"))
    ],
    targets: [.target(name: "UhooiPicBookMockolo", path: "")]
)
