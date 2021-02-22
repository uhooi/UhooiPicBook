# UhooiPicBook-iOS

[![License](https://img.shields.io/github/license/uhooi/UhooiPicBook)](https://github.com/uhooi/UhooiPicBook/blob/master/LICENSE)
[![Twitter](https://img.shields.io/twitter/url?style=social&url=https%3A%2F%2Ftwitter.com%2Fthe_uhooi)](https://twitter.com/the_uhooi)

|Branch|CI|Code coverage|
|:--|:--|:--|
|[master](https://github.com/uhooi/UhooiPicBook/tree/master)|[![CI](https://github.com/uhooi/UhooiPicBook/actions/workflows/main.yml/badge.svg?branch=master)](https://github.com/uhooi/UhooiPicBook/actions/workflows/main.yml)|[![codecov](https://codecov.io/gh/uhooi/UhooiPicBook/branch/master/graph/badge.svg?token=4HTK2YK2FG)](https://codecov.io/gh/uhooi/UhooiPicBook)|
|[develop](https://github.com/uhooi/UhooiPicBook/tree/develop)|[![CI](https://github.com/uhooi/UhooiPicBook/actions/workflows/main.yml/badge.svg?branch=develop)](https://github.com/uhooi/UhooiPicBook/actions/workflows/main.yml)|[![codecov](https://codecov.io/gh/uhooi/UhooiPicBook/branch/develop/graph/badge.svg?token=4HTK2YK2FG)](https://codecov.io/gh/uhooi/UhooiPicBook)|

![Logo](./Docs/Logo.png)

UhooiPicBook-iOS is Uhooi's character book for iOS.

[![Download_on_the_App_Store_Badge](./Docs/Download_on_the_App_Store_Badge_US-UK_RGB_blk_092917.svg)](https://apps.apple.com/jp/app/id1501657213)

## Screenshots

### Light

|MonsterList|MonsterDetail|ImagePopup|
|:--|:--|:--|
|<img src="./Docs/Screenshots/iPhone11ProMax/Light/MonsterList.png" width="207">|<img src="./Docs/Screenshots/iPhone11ProMax/Light/MonsterDetail.png" width="207">|<img src="./Docs/Screenshots/iPhone11ProMax/Light/ImagePopup.png" width="207">|

|Activity|Spotlight|iMessage|
|:--|:--|:--|
|<img src="./Docs/Screenshots/iPhone11ProMax/Light/Activity.png" width="207">|<img src="./Docs/Screenshots/iPhone11ProMax/Light/Spotlight.png" width="207">|<img src="./Docs/Screenshots/iPhone11ProMax/Light/iMessage.png" width="207">|

|Widgets|
|:--|
|<img src="./Docs/Screenshots/iPhone11ProMax/Light/Widgets.png" width="207">|

### Dark

|MonsterList|MonsterDetail|ImagePopup|
|:--|:--|:--|
|<img src="./Docs/Screenshots/iPhone11ProMax/Dark/MonsterList.png" width="207">|<img src="./Docs/Screenshots/iPhone11ProMax/Dark/MonsterDetail.png" width="207">|<img src="./Docs/Screenshots/iPhone11ProMax/Dark/ImagePopup.png" width="207">|

|Activity|Spotlight|iMessage|
|:--|:--|:--|
|<img src="./Docs/Screenshots/iPhone11ProMax/Dark/Activity.png" width="207">|<img src="./Docs/Screenshots/iPhone11ProMax/Dark/Spotlight.png" width="207">|<img src="./Docs/Screenshots/iPhone11ProMax/Dark/iMessage.png" width="207">|

|Widgets|
|:--|
|<img src="./Docs/Screenshots/iPhone11ProMax/Dark/Widgets.png" width="207">|

## Development

You can develop UhooiPicBook-iOS.

### Environment

- Xcode: 12.3
- Swift: 5.3.2
- Bundler: 2.1.4
- Mint: 0.16.0

### Configuration

- UI implementation: Storyboard + XIB
- Architecture: VIPER
- UITesting architecture: Page Object Pattern
- Branching model: Git-flow

### Setup

1. Install [Bundler](https://github.com/rubygems/bundler) and [Mint](https://github.com/yonaskolb/Mint) .

2. Clone the project.

```
$ git clone https://github.com/uhooi/UhooiPicBook.git
$ cd UhooiPicBook
```

3. Run `make setup` .  
After setup is complete, Workspace automatically opens in Xcode.

### Help

Run `make help` .

```
$ make help
setup                                      Install dependencies and prepared development configuration
install-bundler                            Install Bundler dependencies
update-bundler                             Update Bundler dependencies
install-mint                               Install Mint dependencies
install-templates                          Install Generamba templates
generate-licenses                          Generate licenses with LicensePlist and regenerate project
generate-module MODULE_NAME=[module name]  Generate module with Generamba and regenerate project
generate-xcodeproj                         Generate project with XcodeGen
open                                       Open project in Xcode
clean                                      Delete cache
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
