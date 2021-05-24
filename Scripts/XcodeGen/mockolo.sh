rm -f $SRCROOT/$TARGET_NAME/Generated/MockResults.swift
SDKROOT=macosx
swift run -c release --package-path UhooiPicBookMockolo mockolo --sourcedirs $SRCROOT/$TARGET_NAME $SRCROOT/Shared --destination $SRCROOT/$TARGET_NAME/Generated/MockResults.swift --mock-final

