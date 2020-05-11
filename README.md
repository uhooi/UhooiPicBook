# UhooiPicBook-iOS

![Logo](./Docs/Logo.png)

Uhooi's character book for iOS.

[![](https://github.com/uhooi/UhooiPicBook/workflows/CI/badge.svg)](https://github.com/uhooi/UhooiPicBook/actions?query=workflow%3ACI)
[![License](https://img.shields.io/github/license/uhooi/UhooiPicBook)](https://github.com/uhooi/UhooiPicBook/blob/master/LICENSE)
[![Twitter](https://img.shields.io/twitter/url?style=social&url=https%3A%2F%2Ftwitter.com%2Fthe_uhooi)](https://twitter.com/the_uhooi)

## Screenshots

|MonsterList|MonsterDetail|ImagePopup|
|:--|:--|:--|
|![MonsterList](./Docs/Screenshots/MonsterList.png)|![MonsterDetail](./Docs/Screenshots/MonsterDetail.png)|![ImagePopup](./Docs/Screenshots/ImagePopup.png)|

## Demo

TBD

## Environment

- Xcode: 11.3.1
- Swift: 5.1.3
- Bundler: 2.1.4
- Mint: 0.14.1

## Configuration

- UI implementation: Storyboard + XIB
- Branching model: Git-flow

## Setup

1. Clone the project.

```
$ git clone https://github.com/uhooi/UhooiPicBook.git
$ cd UhooiPicBook
```

2. Install [Bundler](https://github.com/rubygems/bundler) and [Mint](https://github.com/yonaskolb/Mint) .

3. Run `make setup` .  
After setup is complete, Workspace automatically opens in Xcode.

## Development

Run `make help` .

```
$ make help
build-debug                                Xcode build for debug
clean                                      Delete cache
generate-licenses                          Generate licenses with LicensePlist and regenerate project
generate-module MODULE_NAME=[module name]  Generate module with Generamba and regenerate project
generate-xcodeproj                         Generate project with XcodeGen
install-bundler                            Install Bundler dependencies
install-carthage                           Install Carthage dependencies
install-cocoapods                          Install CocoaPods dependencies and generate workspace
install-mint                               Install Mint dependencies
install-templates                          Install Generamba templates
open                                       Open workspace in Xcode
setup                                      Install dependencies and prepared development configuration
test                                       Xcode test
update-carthage                            Update Carthage dependencies
update-cocoapods                           Update CocoaPods dependencies and generate workspace
```

## Architecture

VIPER
