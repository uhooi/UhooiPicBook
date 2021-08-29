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

SDKROOT=macosx
Tools/UhooiPicBookTools/.build/release/SpellChecker --yml $SRCROOT/spell-checker.yml -- $options

