if which mint >/dev/null; then
  rm -f $SRCROOT/$TARGET_NAME/Generated/MockResults.swift
  xcrun --sdk macosx mint run uber/mockolo mockolo --sourcedirs $SRCROOT/$TARGET_NAME --destination $SRCROOT/$TARGET_NAME/Generated/MockResults.swift
else
  echo "warning: Mint not installed, download from https://github.com/yonaskolb/Mint"
fi

