// swift-tools-version:5.9

import PackageDescription

let firebaseAnalyticsDependencies: [Target.Dependency] = [
    "FBLPromises",
    "FirebaseAnalytics",
    "FirebaseCore",
    "FirebaseCoreInternal",
    "FirebaseInstallations",
    "GoogleAdsOnDeviceConversion",
    "GoogleAppMeasurement",
    "GoogleAppMeasurementIdentitySupport",
    "GoogleUtilities",
    "nanopb",
]

let firebaseCrashlyticsDependencies: [Target.Dependency] = [
    "FirebaseCoreExtension",
    "FirebaseCrashlytics",
    "FirebaseRemoteConfigInterop",
    "FirebaseSessions",
    "Promises",
]

let firebasePerformanceDependencies: [Target.Dependency] = [
    "FirebaseABTesting",
    "FirebaseCoreExtension",
    "FirebasePerformance",
    "FirebaseRemoteConfig",
    "FirebaseRemoteConfigInterop",
    "FirebaseSessions",
    "FirebaseSharedSwift",
    "Promises",
]

let firebaseSetupDependencies: [Target.Dependency] = [
    "GoogleDataTransport",
    "FirebaseCoreExtension",
    "FirebaseCrashlytics",
    "FirebaseRemoteConfigInterop",
    "FirebaseSessions",
    "Promises",
    "FirebaseABTesting",
    "FirebasePerformance",
    "FirebaseRemoteConfig",
    "FirebaseSharedSwift",
    "FBLPromises",
    "FirebaseAnalytics",
    "FirebaseCore",
    "FirebaseCoreInternal",
    "FirebaseInstallations",
    "GoogleAdsOnDeviceConversion",
    "GoogleAppMeasurement",
    "GoogleAppMeasurementIdentitySupport",
    "GoogleUtilities",
    "nanopb",
]

let firebaseMessagingDependencies: [Target.Dependency] = [
    "FirebaseMessaging",
]

let firebaseFirestoreDependencies: [Target.Dependency] = [
    "FirebaseAppCheckInterop",
    "FirebaseCoreExtension",
    "FirebaseFirestore",
    "FirebaseFirestoreInternal",
    "FirebaseSharedSwift",
    "absl",
    "grpc",
    "grpcpp",
    "leveldb",
    "openssl_grpc",
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
            dependencies: firebaseSetupDependencies,
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
            name: "GoogleAdsOnDeviceConversion",
            path: "./Frameworks/Firebase/FirebaseAnalytics/GoogleAdsOnDeviceConversion.xcframework"
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
            name: "FirebaseRemoteConfigInterop",
            path: "./Frameworks/Firebase/FirebasePerformance/FirebaseRemoteConfigInterop.xcframework"
        ),
        .binaryTarget(
            name: "FirebaseSessions",
            path: "./Frameworks/Firebase/FirebasePerformance/FirebaseSessions.xcframework"
        ),
        .binaryTarget(
            name: "GoogleDataTransport",
            path: "./Frameworks/Firebase/FirebaseCrashlytics/GoogleDataTransport.xcframework"
        ),
        .binaryTarget(
            name: "Promises",
            path: "./Frameworks/Firebase/FirebasePerformance/Promises.xcframework"
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
            name: "FirebaseAppCheckInterop",
            path: "./Frameworks/Firebase/FirebaseFirestore/FirebaseAppCheckInterop.xcframework"
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
            name: "FirebaseFirestoreInternal",
            path: "./Frameworks/Firebase/FirebaseFirestore/FirebaseFirestoreInternal.xcframework"
        ),
        .binaryTarget(
            name: "FirebaseSharedSwift",
            path: "./Frameworks/Firebase/FirebaseFirestore/FirebaseSharedSwift.xcframework"
        ),
        .binaryTarget(
            name: "absl",
            path: "./Frameworks/Firebase/FirebaseFirestore/absl.xcframework"
        ),
        .binaryTarget(
            name: "grpc",
            path: "./Frameworks/Firebase/FirebaseFirestore/grpc.xcframework"
        ),
        .binaryTarget(
            name: "grpcpp",
            path: "./Frameworks/Firebase/FirebaseFirestore/grpcpp.xcframework"
        ),
        .binaryTarget(
            name: "leveldb",
            path: "./Frameworks/Firebase/FirebaseFirestore/leveldb.xcframework"
        ),
        .binaryTarget(
            name: "openssl_grpc",
            path: "./Frameworks/Firebase/FirebaseFirestore/openssl_grpc.xcframework"
        ),
    ]
)

for target in package.targets {
    if [.regular, .test].contains(target.type) {
        target.swiftSettings = debugSwiftSettings
    }
}
