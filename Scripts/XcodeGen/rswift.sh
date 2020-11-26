if which mint >/dev/null; then
  xcrun --sdk macosx mint run R.swift rswift generate "$SRCROOT/$TARGET_NAME/Generated/R.generated.swift"
else
  echo "warning: Mint not installed, download from https://github.com/yonaskolb/Mint"
fi

