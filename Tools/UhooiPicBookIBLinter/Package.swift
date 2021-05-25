// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "UhooiPicBookIBLinter",
    platforms: [
        .macOS(.v11)
    ],
    dependencies: [
        // TODO: The target name will no longer conflict with XcodeGen in the next release,
        // and then we'll put the package together.
        .package(url: "https://github.com/IBDecodable/IBLinter", .exact("0.4.27")),
    ],
    targets: [.target(name: "UhooiPicBookIBLinter", path: "")]
)
