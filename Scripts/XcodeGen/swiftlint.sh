SDKROOT=$(xcrun --sdk macosx --show-sdk-path)
swift run -c release --package-path Tools/UhooiPicBookTools swiftlint --fix --format
swift run -c release --package-path Tools/UhooiPicBookTools swiftlint

