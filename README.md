# UhooiPicBook-iOS

[![Release](https://img.shields.io/github/v/release/uhooi/UhooiPicBook)](https://github.com/uhooi/UhooiPicBook/releases/latest)
[![License](https://img.shields.io/github/license/uhooi/UhooiPicBook)](https://github.com/uhooi/UhooiPicBook/blob/main/LICENSE)
[![Platform](https://img.shields.io/badge/platform-iOS-lightgrey)](https://github.com/uhooi/UhooiPicBook)
[![Twitter](https://img.shields.io/twitter/follow/the_uhooi?style=social)](https://twitter.com/the_uhooi)

|Branch|CI|Code coverage|
|:--|:--|:--|
|[main](https://github.com/uhooi/UhooiPicBook/tree/main)|[![CI](https://github.com/uhooi/UhooiPicBook/actions/workflows/main.yml/badge.svg?branch=main)](https://github.com/uhooi/UhooiPicBook/actions/workflows/main.yml)|[![codecov](https://codecov.io/gh/uhooi/UhooiPicBook/branch/main/graph/badge.svg?token=4HTK2YK2FG)](https://codecov.io/gh/uhooi/UhooiPicBook)|
|[develop](https://github.com/uhooi/UhooiPicBook/tree/develop)|[![CI](https://github.com/uhooi/UhooiPicBook/actions/workflows/main.yml/badge.svg?branch=develop)](https://github.com/uhooi/UhooiPicBook/actions/workflows/main.yml)|[![codecov](https://codecov.io/gh/uhooi/UhooiPicBook/branch/develop/graph/badge.svg?token=4HTK2YK2FG)](https://codecov.io/gh/uhooi/UhooiPicBook)|

![Logo](./Docs/Logo.png)

UhooiPicBook-iOS is Uhooi's character book for iOS.

[![Download_on_the_App_Store_Badge](./Docs/Download_on_the_App_Store_Badge_US-UK_RGB_blk_092917.svg)](https://apps.apple.com/jp/app/id1501657213)

## Screenshots

### Light

|MonsterList|MonsterDetail|ImagePopup|
|:--|:--|:--|
|<img src="./Docs/Screenshots/iPhone11ProMax/iOS14_3/Light/MonsterList.png" width="207">|<img src="./Docs/Screenshots/iPhone11ProMax/iOS14_3/Light/MonsterDetail_English.png" width="207">|<img src="./Docs/Screenshots/iPhone11ProMax/iOS14_3/Light/ImagePopup_English.png" width="207">|

|Menu opened in MonsterList|Spotlight|iMessage|
|:--|:--|:--|
|<img src="./Docs/Screenshots/iPhone11ProMax/iOS14_3/Light/MenuOpenedInMonsterList_English.png" width="207">|<img src="./Docs/Screenshots/iPhone11ProMax/iOS14_3/Light/Spotlight_English.png" width="207">|<img src="./Docs/Screenshots/iPhone11ProMax/iOS14_3/Light/iMessage_English.png" width="207">|

|Widgets|
|:--|
|<img src="./Docs/Screenshots/iPhone11ProMax/iOS14_3/Light/Widgets_English.png" width="207">|

### Dark

|MonsterList|MonsterDetail|ImagePopup|
|:--|:--|:--|
|<img src="./Docs/Screenshots/iPhone11ProMax/iOS14_3/Dark/MonsterList.png" width="207">|<img src="./Docs/Screenshots/iPhone11ProMax/iOS14_3/Dark/MonsterDetail_English.png" width="207">|<img src="./Docs/Screenshots/iPhone11ProMax/iOS14_3/Dark/ImagePopup_English.png" width="207">|

|Menu opened in MonsterList|Spotlight|iMessage|
|:--|:--|:--|
|<img src="./Docs/Screenshots/iPhone11ProMax/iOS14_3/Dark/MenuOpenedInMonsterList_English.png" width="207">|<img src="./Docs/Screenshots/iPhone11ProMax/iOS14_3/Dark/Spotlight_English.png" width="207">|<img src="./Docs/Screenshots/iPhone11ProMax/iOS14_3/Dark/iMessage_English.png" width="207">|

|Widgets|
|:--|
|<img src="./Docs/Screenshots/iPhone11ProMax/iOS14_3/Dark/Widgets_English.png" width="207">|

## Development

You can develop this project.

### Configuration

- UI implementation: Storyboard + XIB
- Architecture: VIPER
- UITesting architecture: Page Object Pattern
- Branching model: Git-flow

### Setup

1. Install the following tools.

- [Xcode](https://apps.apple.com/jp/app/xcode/id497799835): 12.5.1
- [rbenv](https://github.com/rbenv/rbenv): 1.1.2

2. Clone the project.

```shell
$ git clone https://github.com/uhooi/UhooiPicBook.git
$ cd UhooiPicBook
```

3. Run `make setup` .  
After setup is complete, Workspace automatically opens in Xcode.

### Help

Run `make help` .

```shell
$ make help
setup                                      Install dependencies and prepared development configuration
install-bundler                            Install Bundler dependencies
update-bundler                             Update Bundler dependencies
install-templates                          Install Generamba templates
generate-licenses                          Generate licenses with LicensePlist
generate-module MODULE_NAME=[module name]  Generate module with Generamba
generate-xcodeproj-develop                 Generate project with XcodeGen for develop
generate-xcodeproj-production              Generate project with XcodeGen for production
open                                       Open project in Xcode
clean                                      Delete cache
clean-swift-packages                       Delete build artifacts
analyze                                    Analyze with SwiftLint
build-debug                                Xcode build for debug
test TEST_DEVICE=[device] TEST_OS=[OS]     Xcode test
get-coverage-html                          Get code coverage for HTML
get-coverage-cobertura                     Get code coverage for Cobertura
upload-coverage                            Upload code coverage to Codecov
show-devices                               Show devices
```

## Contribution

I would be happy if you contribute :)

- [New issue](https://github.com/uhooi/UhooiPicBook/issues/new)
- [New pull request](https://github.com/uhooi/UhooiPicBook/compare)
