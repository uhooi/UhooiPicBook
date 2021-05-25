// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "UhooiPicBookMockolo",
    platforms: [
        .macOS(.v11)
    ],
    dependencies: [
        .package(url: "https://github.com/uhooi/mockolo", .exact("1.3.4")) // TODO: Replace uhooi with uber
    ],
    targets: [.target(name: "UhooiPicBookMockolo", path: "")]
)
