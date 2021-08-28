SDKROOT=$(xcrun --sdk macosx --show-sdk-path)
swift run -c release --package-path Tools/UhooiPicBookTools iblinter lint

