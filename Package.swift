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
    "FirebaseFirestore",
    "abseil",
    "gRPC-C++",
    "gRPC-Core",
    "leveldb-library",
]

let otherSwiftFlags: [String] = [
    "-Xfrontend", "-warn-long-expression-type-checking=500",
    "-Xfrontend", "-warn-long-function-bodies=500",
    "-Xfrontend", "-warn-concurrency",
    "-Xfrontend", "-enable-actor-data-race-checks",
]

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
        .library(name: "AppModule", targets: ["AppModule"]),
        .library(name: "MonsterWidgets", targets: ["MonsterWidgets"]),
        .library(name: "MonstersRepository", targets: ["MonstersRepository"]), // FIXME: Remove later
        .library(name: "Shared", targets: ["Shared"]), // FIXME: Remove later
        .library(name: "ImageLoader", targets: ["ImageLoader"]), // FIXME: Remove later
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "FirebaseSetup",
            dependencies: firebaseCrashlyticsDependencies + firebasePerformanceDependencies + firebaseAnalyticsDependencies,
            linkerSettings: [
                .unsafeFlags(["-ObjC"]),
            ]
        ),
        .target(
            name: "FirebaseMessagingBridge",
            dependencies: firebaseMessagingDependencies + firebaseAnalyticsDependencies,
            linkerSettings: [
                .unsafeFlags(["-ObjC"]),
            ]
        ),
        .target(
            name: "AppModule",
            dependencies: [
                "MonstersRepository",
                "Shared",
                "Logger",
                "ImageLoader",
            ],
            swiftSettings: [
                .unsafeFlags(otherSwiftFlags, .when(configuration: .debug)),
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
            ],
            swiftSettings: [
                .unsafeFlags(otherSwiftFlags, .when(configuration: .debug)),
            ]
        ),
        .target(
            name: "MonstersRepository",
            dependencies: firebaseFirestoreDependencies + firebaseAnalyticsDependencies,
            swiftSettings: [
                .unsafeFlags(otherSwiftFlags, .when(configuration: .debug)),
            ],
            linkerSettings: [
                .unsafeFlags(["-ObjC"]),
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
            ],
            swiftSettings: [
                .unsafeFlags(otherSwiftFlags, .when(configuration: .debug)),
            ]
        ),
        .target(
            name: "ImageLoader",
            dependencies: [
            ],
            swiftSettings: [
                .unsafeFlags(otherSwiftFlags, .when(configuration: .debug)),
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
            name: "abseil",
            path: "./Frameworks/Firebase/FirebaseFirestore/abseil.xcframework"
        ),
        .binaryTarget(
            name: "BoringSSL-GRPC",
            path: "./Frameworks/Firebase/FirebaseFirestore/BoringSSL-GRPC.xcframework"
        ),
        .binaryTarget(
            name: "FirebaseFirestore",
            path: "./Frameworks/Firebase/FirebaseFirestore/FirebaseFirestore.xcframework"
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
