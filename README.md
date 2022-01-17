# UhooiPicBook-iOS

[![Release](https://img.shields.io/github/v/release/uhooi/UhooiPicBook)](https://github.com/uhooi/UhooiPicBook/releases/latest)
[![License](https://img.shields.io/github/license/uhooi/UhooiPicBook)](https://github.com/uhooi/UhooiPicBook/blob/main/LICENSE)
[![Platform](https://img.shields.io/badge/platform-iOS-lightgrey)](https://github.com/uhooi/UhooiPicBook)
[![Twitter](https://img.shields.io/twitter/follow/the_uhooi?style=social)](https://twitter.com/the_uhooi)

|Branch|CI|Code coverage|
|:--|:--:|:--:|
|[main](https://github.com/uhooi/UhooiPicBook/tree/main)|[![CI](https://github.com/uhooi/UhooiPicBook/actions/workflows/main.yml/badge.svg?branch=main)](https://github.com/uhooi/UhooiPicBook/actions/workflows/main.yml)|-|
|[develop](https://github.com/uhooi/UhooiPicBook/tree/develop)|[![CI](https://github.com/uhooi/UhooiPicBook/actions/workflows/main.yml/badge.svg?branch=develop)](https://github.com/uhooi/UhooiPicBook/actions/workflows/main.yml)|-|

![Logo](./Docs/Logo.png)

UhooiPicBook-iOS is Uhooi's character book for iOS.

[![Download_on_the_App_Store_Badge](./Docs/Download_on_the_App_Store_Badge_US-UK_RGB_blk_092917.svg)](https://apps.apple.com/jp/app/id1501657213)

## Screenshots

### Light

|MonsterList|MonsterDetail|ImagePopup|
|:--:|:--:|:--:|
|<img src="./Docs/Screenshots/iPhone11ProMax/iOS14_3/Light/MonsterList.png" width="207">|<img src="./Docs/Screenshots/iPhone11ProMax/iOS14_3/Light/MonsterDetail_English.png" width="207">|<img src="./Docs/Screenshots/iPhone11ProMax/iOS14_3/Light/ImagePopup_English.png" width="207">|

|Menu opened in MonsterList|Spotlight|iMessage|
|:--:|:--:|:--:|
|<img src="./Docs/Screenshots/iPhone11ProMax/iOS14_3/Light/MenuOpenedInMonsterList_English.png" width="207">|<img src="./Docs/Screenshots/iPhone11ProMax/iOS14_3/Light/Spotlight_English.png" width="207">|<img src="./Docs/Screenshots/iPhone11ProMax/iOS14_3/Light/iMessage_English.png" width="207">|

|Widgets|
|:--:|
|<img src="./Docs/Screenshots/iPhone11ProMax/iOS14_3/Light/Widgets_English.png" width="207">|

### Dark

|MonsterList|MonsterDetail|ImagePopup|
|:--:|:--:|:--:|
|<img src="./Docs/Screenshots/iPhone11ProMax/iOS14_3/Dark/MonsterList.png" width="207">|<img src="./Docs/Screenshots/iPhone11ProMax/iOS14_3/Dark/MonsterDetail_English.png" width="207">|<img src="./Docs/Screenshots/iPhone11ProMax/iOS14_3/Dark/ImagePopup_English.png" width="207">|

|Menu opened in MonsterList|Spotlight|iMessage|
|:--:|:--:|:--:|
|<img src="./Docs/Screenshots/iPhone11ProMax/iOS14_3/Dark/MenuOpenedInMonsterList_English.png" width="207">|<img src="./Docs/Screenshots/iPhone11ProMax/iOS14_3/Dark/Spotlight_English.png" width="207">|<img src="./Docs/Screenshots/iPhone11ProMax/iOS14_3/Dark/iMessage_English.png" width="207">|

|Widgets|
|:--:|
|<img src="./Docs/Screenshots/iPhone11ProMax/iOS14_3/Dark/Widgets_English.png" width="207">|

## Development

You can develop this project.

### Environment

- [Xcode](https://apps.apple.com/jp/app/xcode/id497799835): 13.2.1

### Configuration

- UI implementation: Storyboard + XIB
- Architecture: VIPER
- UITesting architecture: Page Object Pattern
- Branching model: Git-flow

### Setup

1. Clone the project.

    ```shell
    $ git clone https://github.com/uhooi/UhooiPicBook.git
    $ cd UhooiPicBook
    ```

2. Enable faster builds for Swift projects. (Optional)

    ```shell
    $ defaults write com.apple.dt.XCBuild EnableSwiftBuildSystemIntegration 1
    ```

3. Run `make setup` .  
After setup is complete, Workspace automatically opens in Xcode.

### Help

Run `make help` .

```shell
$ make help
setup                                Install dependencies and prepared development configuration
build-cli-tools                      Build CLI tools managed by SwiftPM
download-firebase-sdk                Download firebase-ios-sdk
generate-licenses                    Generate licenses with LicensePlist
generate-mocks                       Generate mocks with Mockolo
open                                 Open workspace in Xcode
clean                                Delete cache
clean-cli-tools                      Delete build artifacts for CLI tools managed by SwiftPM
analyze                              Analyze with SwiftLint
build-debug-develop                  Xcode debug build for develop
build-debug-production               Xcode debug build for production
test-debug-develop                   Xcode debug test for develop
test-debug-production                Xcode debug test for production
test-debug-app-module                Xcode debug test for AppModule
merge-test-results                   Merge test results
show-devices                         Show devices
```

## Contribution

I would be happy if you contribute :)

- [New issue](https://github.com/uhooi/UhooiPicBook/issues/new)
- [New pull request](https://github.com/uhooi/UhooiPicBook/compare)

## Stats

[![Stats](https://repobeats.axiom.co/api/embed/1c29e1d49c64b444ae3a829603069d4fcfcf7596.svg "Repobeats analytics image")](https://github.com/uhooi/UhooiPicBook)
