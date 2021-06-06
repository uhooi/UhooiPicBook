rm -f $SRCROOT/$TARGET_NAME/Generated/MockResults.swift
SDKROOT=macosx
swift build -c release --package-path Tools/UhooiPicBookTools --product mockolo
Tools/UhooiPicBookTools/.build/release/mockolo --sourcedirs $SRCROOT/$TARGET_NAME $SRCROOT/Shared --destination $SRCROOT/$TARGET_NAME/Generated/MockResults.swift --mock-final

