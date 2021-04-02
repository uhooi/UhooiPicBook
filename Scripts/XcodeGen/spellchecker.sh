export MINT_PATH=mint/lib
export MINT_LINK_PATH=mint/bin
if ! which mint >/dev/null; then
  echo "warning: Mint not installed, download from https://github.com/yonaskolb/Mint"
  exit 0
fi

git_path=/usr/local/bin/git
files=$($git_path diff --diff-filter=d --name-only -- "*.swift" "*.h" "*.m")
if (test -z $files) || (test ${#files[@]} -eq 0); then
  echo "no files changed."
  exit 0
fi

options=""
for file in $files
do
  options="$options $SRCROOT/$file"
done

xcrun --sdk macosx mint run fromkk/SpellChecker SpellChecker --yml $SRCROOT/spell-checker.yml -- $options

