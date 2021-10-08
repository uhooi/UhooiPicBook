rm -f $SRCROOT/$TARGET_NAME/Generated/MockResults.swift
SDKROOT=$(xcrun --sdk macosx --show-sdk-path)
Tools/UhooiPicBookMockolo/.build/release/mockolo --sourcedirs $SRCROOT/$TARGET_NAME $SRCROOT/Shared --destination $SRCROOT/$TARGET_NAME/Generated/MockResults.swift --mock-final

