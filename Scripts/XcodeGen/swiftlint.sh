export MINT_PATH=mint/lib
export MINT_LINK_PATH=mint/bin
if which mint >/dev/null; then
  xcrun --sdk macosx mint run realm/SwiftLint swiftlint autocorrect --format
  xcrun --sdk macosx mint run realm/SwiftLint swiftlint
else
  echo "warning: Mint not installed, download from https://github.com/yonaskolb/Mint"
fi

