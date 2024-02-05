English / [Japanese](./README.ja.md)

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

<a href="https://apps.apple.com/jp/app/ウホーイ図鑑/id1501657213?itsct=apps_box_badge&amp;itscg=30200" style="display: inline-block; overflow: hidden; border-radius: 13px; width: 250px; height: 83px;"><img src="https://tools.applemediaservices.com/api/badges/download-on-the-app-store/black/en-us?size=250x83&amp;releaseDate=1593561600&h=b17e195bc020808628890cbe7fcde25f" alt="Download on the App Store" style="border-radius: 13px; width: 250px; height: 83px;"></a>

## Table of Contents

- [Screenshots](#screenshots)
- [Development](#development)
- [Contribution](#contribution)
- [Stats](#stats)

## Screenshots

<details><summary>Screenshots</summary>

### Light

|MonsterList|MonsterDetail|ImagePopup|
|:--:|:--:|:--:|
|<img src="./Docs/Screenshots/iPhone11ProMax/iOS15_2/Light/MonsterList.png" width="207">|<img src="./Docs/Screenshots/iPhone11ProMax/iOS15_2/Light/MonsterDetail_English.png" width="207">|<img src="./Docs/Screenshots/iPhone11ProMax/iOS15_2/Light/ImagePopup_English.png" width="207">|

|Menu opened in MonsterList|Spotlight|iMessage|
|:--:|:--:|:--:|
|<img src="./Docs/Screenshots/iPhone11ProMax/iOS15_2/Light/MenuOpenedInMonsterList_English.png" width="207">|<img src="./Docs/Screenshots/iPhone11ProMax/iOS14_3/Light/Spotlight_English.png" width="207">|<img src="./Docs/Screenshots/iPhone11ProMax/iOS14_3/Light/iMessage_English.png" width="207">|

|Widgets|
|:--:|
|<img src="./Docs/Screenshots/iPhone11ProMax/iOS14_3/Light/Widgets_English.png" width="207">|

### Dark

|MonsterList|MonsterDetail|ImagePopup|
|:--:|:--:|:--:|
|<img src="./Docs/Screenshots/iPhone11ProMax/iOS15_2/Dark/MonsterList.png" width="207">|<img src="./Docs/Screenshots/iPhone11ProMax/iOS15_2/Dark/MonsterDetail_English.png" width="207">|<img src="./Docs/Screenshots/iPhone11ProMax/iOS15_2/Dark/ImagePopup_English.png" width="207">|

|Menu opened in MonsterList|Spotlight|iMessage|
|:--:|:--:|:--:|
|<img src="./Docs/Screenshots/iPhone11ProMax/iOS15_2/Dark/MenuOpenedInMonsterList_English.png" width="207">|<img src="./Docs/Screenshots/iPhone11ProMax/iOS14_3/Dark/Spotlight_English.png" width="207">|<img src="./Docs/Screenshots/iPhone11ProMax/iOS14_3/Dark/iMessage_English.png" width="207">|

|Widgets|
|:--:|
|<img src="./Docs/Screenshots/iPhone11ProMax/iOS14_3/Dark/Widgets_English.png" width="207">|

</details>

## Development

You can develop this project.

### Environment

- macOS 13.5+
- Xcode 15.2 (Swift 5.9.2)
- Mint
- Make

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
install-mint-dependencies            Install Mint dependencies
download-firebase-sdk                Download firebase-ios-sdk
generate-licenses                    Generate licenses with LicensePlist
generate-mocks                       Generate mocks with Mockolo
open                                 Open workspace in Xcode
clean                                Delete cache
lint                                 Lint with SwiftLint
fix                                  Fix with SwiftLint
analyze                              Analyze with SwiftLint
lint-ib                              Lint with IBLinter
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
