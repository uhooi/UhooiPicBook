// FIXME: `echo` は後で削除する
echo $MINT_PATH
echo $MINT_LINK_PATH
if which mint >/dev/null; then
  xcrun --sdk macosx mint run swiftlint swiftlint autocorrect --format
  xcrun --sdk macosx mint run swiftlint swiftlint
else
  echo "warning: Mint not installed, download from https://github.com/yonaskolb/Mint"
fi

