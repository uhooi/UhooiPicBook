rm -f $SRCROOT/$TARGET_NAME/Generated/MockResults.swift
SDKROOT=macosx
Tools/UhooiPicBookTools/.build/release/mockolo --sourcedirs $SRCROOT/$TARGET_NAME $SRCROOT/Shared --destination $SRCROOT/$TARGET_NAME/Generated/MockResults.swift --mock-final

