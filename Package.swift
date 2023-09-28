// swift-tools-version:5.9

import PackageDescription

let firebaseAnalyticsDependencies: [Target.Dependency] = [
    "FBLPromises",
    "FirebaseAnalytics",
    "FirebaseAnalyticsSwift",
    "FirebaseCore",
    "FirebaseCoreInternal",
    "FirebaseInstallations",
    "GoogleAppMeasurement",
    "GoogleAppMeasurementIdentitySupport",
    "GoogleUtilities",
    "nanopb",
]

let firebaseCrashlyticsDependencies: [Target.Dependency] = [
    "FirebaseCrashlytics",
]

let firebasePerformanceDependencies: [Target.Dependency] = [
    "FirebaseABTesting",
    "FirebasePerformance",
    "FirebaseRemoteConfig",
]

let firebaseMessagingDependencies: [Target.Dependency] = [
    "FirebaseMessaging",
]

let firebaseFirestoreDependencies: [Target.Dependency] = [
    "BoringSSL-GRPC",
    "FirebaseCoreExtension",
    "FirebaseFirestore",
    "FirebaseFirestoreSwift",
    "FirebaseSharedSwift",
    "Libuv-gRPC",
    "abseil",
    "gRPC-C++",
    "gRPC-Core",
    "leveldb-library",
]

let debugOtherSwiftFlags = [
    "-Xfrontend", "-warn-long-expression-type-checking=500",
    "-Xfrontend", "-warn-long-function-bodies=500",
    "-strict-concurrency=complete",
    "-enable-actor-data-race-checks",
]

let debugSwiftSettings: [PackageDescription.SwiftSetting] = [
    .unsafeFlags(debugOtherSwiftFlags, .when(configuration: .debug)),
    .enableUpcomingFeature("ConciseMagicFile", .when(configuration: .debug)), // SE-0274
    .enableUpcomingFeature("ForwardTrailingClosures", .when(configuration: .debug)), // SE-0286
    .enableUpcomingFeature("ExistentialAny", .when(configuration: .debug)), // SE-0335
    .enableUpcomingFeature("BareSlashRegexLiterals", .when(configuration: .debug)), // SE-0354
    .enableUpcomingFeature("ImportObjcForwardDeclarations", .when(configuration: .debug)), // SE-0384
    .enableUpcomingFeature("DisableOutwardActorInference", .when(configuration: .debug)), // SE-0401
]

let package = Package(
    name: "UhooiPicBookPackage",
    defaultLocalization: "ja",
    platforms: [
        .iOS(.v15),
        .macOS(.v10_15),
    ],
    products: [
        .library(name: "FirebaseSetup", targets: ["FirebaseSetup"]),
        .library(name: "FirebaseMessagingBridge", targets: ["FirebaseMessagingBridge"]),
        .library(name: "AppModule", targets: ["AppModule"]),
        .library(name: "MonsterWidgets", targets: ["MonsterWidgets"]),
        .library(name: "MonstersRepository", targets: ["MonstersRepository"]), // TODO: Remove later
        .library(name: "ImageLoader", targets: ["ImageLoader"]), // TODO: Remove later
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "FirebaseSetup",
            dependencies: ["GoogleDataTransport"] + firebaseCrashlyticsDependencies + firebasePerformanceDependencies + firebaseAnalyticsDependencies,
            linkerSettings: [
                .unsafeFlags(["-ObjC"]),
            ]
        ),
        .target(
            name: "FirebaseMessagingBridge",
            dependencies: ["GoogleDataTransport"] + firebaseMessagingDependencies + firebaseAnalyticsDependencies,
            linkerSettings: [
                .unsafeFlags(["-ObjC"]),
            ]
        ),
        .target(
            name: "AppModule",
            dependencies: [
                "MonstersRepository",
                "Logger",
                "ImageLoader",
            ]
        ),
        .testTarget(
            name: "AppModuleTests",
            dependencies: [
                "AppModule",
            ]
        ),
        .target(
            name: "MonsterWidgets",
            dependencies: [
                "FirebaseSetup",
                "MonstersRepository",
                "Logger",
                "ImageLoader",
            ]
        ),
        .target(
            name: "MonstersRepository",
            dependencies: firebaseFirestoreDependencies + firebaseAnalyticsDependencies,
            linkerSettings: [
                .unsafeFlags(["-ObjC"]),
            ]
        ),
        .target(
            name: "Logger",
            dependencies: [
            ]
        ),
        .target(
            name: "ImageLoader",
            dependencies: [
            ]
        ),
        .binaryTarget(
            name: "FBLPromises",
            path: "./Frameworks/Firebase/FirebaseAnalytics/FBLPromises.xcframework"
        ),
        .binaryTarget(
            name: "FirebaseAnalytics",
            path: "./Frameworks/Firebase/FirebaseAnalytics/FirebaseAnalytics.xcframework"
        ),
        .binaryTarget(
            name: "FirebaseAnalyticsSwift",
            path: "./Frameworks/Firebase/FirebaseAnalytics/FirebaseAnalyticsSwift.xcframework"
        ),
        .binaryTarget(
            name: "FirebaseCore",
            path: "./Frameworks/Firebase/FirebaseAnalytics/FirebaseCore.xcframework"
        ),
        .binaryTarget(
            name: "FirebaseCoreInternal",
            path: "./Frameworks/Firebase/FirebaseAnalytics/FirebaseCoreInternal.xcframework"
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
            name: "GoogleAppMeasurementIdentitySupport",
            path: "./Frameworks/Firebase/FirebaseAnalytics/GoogleAppMeasurementIdentitySupport.xcframework"
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
            name: "FirebaseCrashlytics",
            path: "./Frameworks/Firebase/FirebaseCrashlytics/FirebaseCrashlytics.xcframework"
        ),
        .binaryTarget(
            name: "GoogleDataTransport",
            path: "./Frameworks/Firebase/FirebaseCrashlytics/GoogleDataTransport.xcframework"
        ),
        .binaryTarget(
            name: "FirebaseABTesting",
            path: "./Frameworks/Firebase/FirebasePerformance/FirebaseABTesting.xcframework"
        ),
        .binaryTarget(
            name: "FirebasePerformance",
            path: "./Frameworks/Firebase/FirebasePerformance/FirebasePerformance.xcframework"
        ),
        .binaryTarget(
            name: "FirebaseRemoteConfig",
            path: "./Frameworks/Firebase/FirebasePerformance/FirebaseRemoteConfig.xcframework"
        ),
        .binaryTarget(
            name: "FirebaseMessaging",
            path: "./Frameworks/Firebase/FirebaseMessaging/FirebaseMessaging.xcframework"
        ),
        .binaryTarget(
            name: "BoringSSL-GRPC",
            path: "./Frameworks/Firebase/FirebaseFirestore/BoringSSL-GRPC.xcframework"
        ),
        .binaryTarget(
            name: "FirebaseCoreExtension",
            path: "./Frameworks/Firebase/FirebaseFirestore/FirebaseCoreExtension.xcframework"
        ),
        .binaryTarget(
            name: "FirebaseFirestore",
            path: "./Frameworks/Firebase/FirebaseFirestore/FirebaseFirestore.xcframework"
        ),
        .binaryTarget(
            name: "FirebaseFirestoreSwift",
            path: "./Frameworks/Firebase/FirebaseFirestore/FirebaseFirestoreSwift.xcframework"
        ),
        .binaryTarget(
            name: "FirebaseSharedSwift",
            path: "./Frameworks/Firebase/FirebaseFirestore/FirebaseSharedSwift.xcframework"
        ),
        .binaryTarget(
            name: "Libuv-gRPC",
            path: "./Frameworks/Firebase/FirebaseFirestore/Libuv-gRPC.xcframework"
        ),
        .binaryTarget(
            name: "abseil",
            path: "./Frameworks/Firebase/FirebaseFirestore/abseil.xcframework"
        ),
        .binaryTarget(
            name: "gRPC-C++",
            path: "./Frameworks/Firebase/FirebaseFirestore/gRPC-C++.xcframework"
        ),
        .binaryTarget(
            name: "gRPC-Core",
            path: "./Frameworks/Firebase/FirebaseFirestore/gRPC-Core.xcframework"
        ),
        .binaryTarget(
            name: "leveldb-library",
            path: "./Frameworks/Firebase/FirebaseFirestore/leveldb-library.xcframework"
        ),
    ]
)

for target in package.targets {
    if [.regular, .test].contains(target.type) {
        target.swiftSettings = debugSwiftSettings
    }
}
