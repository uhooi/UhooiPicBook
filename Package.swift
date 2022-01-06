// swift-tools-version:5.5

import PackageDescription

let firebaseAnalyticsDependencies: [Target.Dependency] = [
    "FirebaseAnalytics",
    "FirebaseCore",
    "FirebaseCoreDiagnostics",
    "FirebaseInstallations",
    "GoogleAppMeasurement",
    "GoogleDataTransport",
    "GoogleUtilities",
    "nanopb",
    "PromisesObjC",
]

let firebaseCrashlyticsDependencies: [Target.Dependency]  = [
    "FirebaseCrashlytics",
] + firebaseAnalyticsDependencies

let firebaseMessagingDependencies: [Target.Dependency]  = [
    "FirebaseMessaging",
] + firebaseAnalyticsDependencies

let package = Package(
    name: "UhooiPicBookPackage",
    defaultLocalization: "ja",
    platforms: [
        .iOS(.v14),
        .macOS(.v10_15),
    ],
    products: [
        .library(name: "FirebaseSetup", targets: ["FirebaseSetup"]),
        .library(name: "FirebaseMessagingBridge", targets: ["FirebaseMessagingBridge"]),
        .library(name: "GedatsuSetup", targets: ["GedatsuSetup"]),
        .library(name: "Logger", targets: ["Logger"]), // FIXME: Remove later
        .library(name: "Shared", targets: ["Shared"]), // FIXME: Remove later
        .library(name: "ImageCache", targets: ["ImageCache"]), // FIXME: Remove later
    ],
    dependencies: [
        .package(url: "https://github.com/bannzai/Gedatsu", from: "1.2.0"),
    ],
    targets: [
        .target(
            name: "FirebaseSetup",
            dependencies: firebaseCrashlyticsDependencies
        ),
        .target(
            name: "FirebaseMessagingBridge",
            dependencies: firebaseMessagingDependencies
        ),
        .target(
            name: "GedatsuSetup",
            dependencies: [
                .product(name: "Gedatsu", package: "Gedatsu"),
            ]
        ),
        .target(
            name: "Shared",
            dependencies: [
            ]
        ),
        .target(
            name: "Logger",
            dependencies: [
            ]
        ),
        .target(
            name: "ImageCache",
            dependencies: [
            ]
        ),
        .binaryTarget(
            name: "FirebaseAnalytics",
            path: "./Frameworks/Firebase/FirebaseAnalytics/FirebaseAnalytics.xcframework"
        ),
        .binaryTarget(
            name: "FirebaseCore",
            path: "./Frameworks/Firebase/FirebaseAnalytics/FirebaseCore.xcframework"
        ),
        .binaryTarget(
            name: "FirebaseCoreDiagnostics",
            path: "./Frameworks/Firebase/FirebaseAnalytics/FirebaseCoreDiagnostics.xcframework"
        ),
        .binaryTarget(
            name: "FirebaseInstallations",
            path: "./Frameworks/Firebase/FirebaseAnalytics/FirebaseInstallations.xcframework"
        ),
        .binaryTarget(
            name: "GoogleAppMeasurement",
            path: "./Frameworks/Firebase/FirebaseAnalytics/GoogleAppMeasurement.xcframework"
        ),
        .binaryTarget(
            name: "GoogleDataTransport",
            path: "./Frameworks/Firebase/FirebaseAnalytics/GoogleDataTransport.xcframework"
        ),
        .binaryTarget(
            name: "GoogleUtilities",
            path: "./Frameworks/Firebase/FirebaseAnalytics/GoogleUtilities.xcframework"
        ),
        .binaryTarget(
            name: "nanopb",
            path: "./Frameworks/Firebase/FirebaseAnalytics/nanopb.xcframework"
        ),
        .binaryTarget(
            name: "PromisesObjC",
            path: "./Frameworks/Firebase/FirebaseAnalytics/PromisesObjC.xcframework"
        ),
        .binaryTarget(
            name: "FirebaseCrashlytics",
            path: "./Frameworks/Firebase/FirebaseCrashlytics/FirebaseCrashlytics.xcframework"
        ),
        .binaryTarget(
            name: "FirebaseMessaging",
            path: "./Frameworks/Firebase/FirebaseMessaging/FirebaseMessaging.xcframework"
        ),
    ]
)
