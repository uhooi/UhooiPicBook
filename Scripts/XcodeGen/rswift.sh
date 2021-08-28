SDKROOT=$(xcrun --sdk macosx --show-sdk-path)
swift run -c release --package-path Tools/UhooiPicBookTools rswift generate "$SRCROOT/$TARGET_NAME/Generated/R.generated.swift"

