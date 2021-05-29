rm -f $SRCROOT/$TARGET_NAME/Generated/MockResults.swift
SDKROOT=macosx
swift build -c release --package-path Tools/UhooiPicBookMockolo --product mockolo
Tools/UhooiPicBookMockolo/.build/release/mockolo --sourcedirs $SRCROOT/$TARGET_NAME $SRCROOT/Shared --destination $SRCROOT/$TARGET_NAME/Generated/MockResults.swift --mock-final

