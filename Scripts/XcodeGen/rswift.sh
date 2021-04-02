export MINT_PATH=mint/lib
export MINT_LINK_PATH=mint/bin
if which mint >/dev/null; then
  xcrun --sdk macosx mint run mac-cain13/R.swift rswift generate "$SRCROOT/$TARGET_NAME/Generated/R.generated.swift"
else
  echo "warning: Mint not installed, download from https://github.com/yonaskolb/Mint"
fi

