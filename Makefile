# Variables

PRODUCT_NAME := UhooiPicBook
PROJECT_NAME := ${PRODUCT_NAME}.xcodeproj
SCHEME_NAME := ${PRODUCT_NAME}
UI_TESTS_TARGET_NAME := ${PRODUCT_NAME}UITests

TEST_SDK := iphonesimulator
TEST_CONFIGURATION := Debug
TEST_PLATFORM := iOS Simulator
TEST_DEVICE ?= iPhone 13 Pro Max
TEST_OS ?= 15.0
TEST_DESTINATION := 'platform=${TEST_PLATFORM},name=${TEST_DEVICE},OS=${TEST_OS}'
COVERAGE_OUTPUT := html_report

XCODEBUILD_BUILD_LOG_NAME := xcodebuild_build.log
XCODEBUILD_TEST_LOG_NAME := xcodebuild_test.log

DEVELOP_ENVIRONMENT := DEVELOP
PRODUCTION_ENVIRONMENT := PRODUCTION

DEVELOP_BUNDLE_IDENTIFIER :=com.theuhooi.UhooiPicBook-Develop
PRODUCTION_BUNDLE_IDENTIFIER :=com.theuhooi.UhooiPicBook

CLI_TOOLS_PACKAGE_PATH := Tools/${PRODUCT_NAME}Tools
CLI_TOOLS_PATH := ${CLI_TOOLS_PACKAGE_PATH}/.build/release

FIREBASE_VERSION := 8.6.0

MODULE_TEMPLATE_NAME ?= uhooi_viper

.DEFAULT_GOAL := help

# Targets

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?# .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":[^#]*? #| #"}; {printf "%-42s%s\n", $$1 $$3, $$2}'

.PHONY: setup
setup: # Install dependencies and prepared development configuration
	$(MAKE) install-ruby
	$(MAKE) install-bundler
	$(MAKE) install-templates
	$(MAKE) build-cli-tools
	$(MAKE) build-mockolo
	$(MAKE) download-firebase-sdk
	$(MAKE) generate-licenses
	$(MAKE) generate-xcodeproj-develop

.PHONY: install-ruby
install-ruby:
	cat .ruby-version | xargs rbenv install --skip-existing

.PHONY: install-bundler
install-bundler: # Install Bundler dependencies
	bundle config path vendor/bundle
	bundle install --without=documentation --jobs 4 --retry 3

.PHONY: update-bundler
update-bundler: # Update Bundler dependencies
	bundle config path vendor/bundle
	bundle update --jobs 4 --retry 3

.PHONY: build-cli-tools
build-cli-tools: # Build CLI tools managed by SwiftPM
	$(MAKE) build-cli-tool CLI_TOOL_NAME=xcodegen
	$(MAKE) build-cli-tool CLI_TOOL_NAME=swiftlint
	$(MAKE) build-cli-tool CLI_TOOL_NAME=iblinter
	$(MAKE) build-cli-tool CLI_TOOL_NAME=SpellChecker
	# $(MAKE) build-cli-tool CLI_TOOL_NAME=mockolo
	$(MAKE) build-cli-tool CLI_TOOL_NAME=license-plist
	$(MAKE) build-cli-tool CLI_TOOL_NAME=rswift
	$(MAKE) build-cli-tool CLI_TOOL_NAME=xcbeautify

.PHONY: build-cli-tool
build-cli-tool:
	swift build -c release --package-path ${CLI_TOOLS_PACKAGE_PATH} --product ${CLI_TOOL_NAME}

.PHONY: build-mockolo
build-mockolo:
	swift build -c release --package-path Tools/UhooiPicBookMockolo --product mockolo

.PHONY: install-templates
install-templates: # Install Generamba templates
	bundle exec generamba template install

.PHONY: download-firebase-sdk
download-firebase-sdk: # Download firebase-ios-sdk
	curl -OL https://github.com/firebase/firebase-ios-sdk/releases/download/${FIREBASE_VERSION}/Firebase.zip
	unzip -o Firebase.zip -d Frameworks/
	rm -f Firebase.zip

.PHONY: generate-licenses
generate-licenses: # Generate licenses with LicensePlist
	${CLI_TOOLS_PATH}/license-plist --output-path ${PRODUCT_NAME}/Settings.bundle --add-version-numbers --config-path lic-plist.yml

.PHONY: generate-module
generate-module: # Generate module with Generamba # MODULE_NAME=[module name]
	bundle exec generamba gen ${MODULE_NAME} ${MODULE_TEMPLATE_NAME}

.PHONY: generate-xcodeproj-develop
generate-xcodeproj-develop: # Generate project with XcodeGen for develop
	$(MAKE) copy-googleserviceinfo-develop
	$(MAKE) generate-xcodeproj ENVIRONMENT=${DEVELOP_ENVIRONMENT} BUNDLE_IDENTIFIER=${DEVELOP_BUNDLE_IDENTIFIER}

.PHONY: generate-xcodeproj-production
generate-xcodeproj-production: # Generate project with XcodeGen for production
	$(MAKE) copy-googleserviceinfo-production
	$(MAKE) generate-xcodeproj ENVIRONMENT=${PRODUCTION_ENVIRONMENT} BUNDLE_IDENTIFIER=${PRODUCTION_BUNDLE_IDENTIFIER}

.PHONY: generate-xcodeproj
generate-xcodeproj:
	${CLI_TOOLS_PATH}/xcodegen generate
	$(MAKE) open

.PHONY: copy-googleserviceinfo-develop
copy-googleserviceinfo-develop:
	$(MAKE) copy-googleserviceinfo ENVIRONMENT=Develop

.PHONY: copy-googleserviceinfo-production
copy-googleserviceinfo-production:
	$(MAKE) copy-googleserviceinfo ENVIRONMENT=Production

.PHONY: copy-googleserviceinfo
copy-googleserviceinfo:
	mkdir -p ./Shared/Resources/
	cp -f ./GoogleServiceInfo/GoogleService-Info-${ENVIRONMENT}.plist ./Shared/Resources/GoogleService-Info.plist

.PHONY: open
open: # Open project in Xcode
	open ./${PROJECT_NAME}

.PHONY: clean
clean: # Delete cache
	rm -rf ./${CLI_TOOLS_PACKAGE_PATH}/.swiftpm
	rm -rf ./${CLI_TOOLS_PACKAGE_PATH}/.build
	rm -rf ./vendor/bundle
	rm -rf ./SourcePackages
	rm -rf ./Templates
	xcodebuild clean -alltargets

.PHONY: clean-cli-tools
clean-cli-tools: # Delete build artifacts for CLI tools managed by SwiftPM
	swift package --package-path ${CLI_TOOLS_PACKAGE_PATH} clean

.PHONY: analyze
analyze: # Analyze with SwiftLint
	$(MAKE) build-debug
	${CLI_TOOLS_PATH}/swiftlint analyze --autocorrect --compiler-log-path ./${XCODEBUILD_BUILD_LOG_NAME}

.PHONY: build-debug
build-debug: # Xcode build for debug
	set -o pipefail \
&& xcodebuild \
-sdk ${TEST_SDK} \
-configuration ${TEST_CONFIGURATION} \
-project ${PROJECT_NAME} \
-scheme ${SCHEME_NAME} \
-destination ${TEST_DESTINATION} \
-clonedSourcePackagesDirPath './SourcePackages' \
clean build \
| tee ./${XCODEBUILD_BUILD_LOG_NAME} \
| ${CLI_TOOLS_PATH}/xcbeautify

.PHONY: test
test: # Xcode test # TEST_DEVICE=[device] TEST_OS=[OS]
	set -o pipefail \
&& NSUnbufferedIO=YES \
xcodebuild \
-sdk ${TEST_SDK} \
-configuration ${TEST_CONFIGURATION} \
-project ${PROJECT_NAME} \
-scheme ${SCHEME_NAME} \
-destination ${TEST_DESTINATION} \
-skip-testing:${UI_TESTS_TARGET_NAME} \
-clonedSourcePackagesDirPath './SourcePackages' \
-resultBundlePath 'TestResults.xcresult' \
clean test \
2>&1 \
| tee ./${XCODEBUILD_TEST_LOG_NAME} \
| ${CLI_TOOLS_PATH}/xcbeautify --is-ci

.PHONY: get-coverage-html
get-coverage-html: # Get code coverage for HTML
	bundle exec slather coverage --html --output-directory ${COVERAGE_OUTPUT}

.PHONY: get-coverage-cobertura
get-coverage-cobertura: # Get code coverage for Cobertura
	bundle exec slather

.PHONY: upload-coverage
upload-coverage: # Upload code coverage to Codecov
	bash -c "bash <(curl -s https://codecov.io/bash) -f xml_report/cobertura.xml -X coveragepy -X gcov -X xcode"

.PHONY: show-devices
show-devices: # Show devices
	xcrun xctrace list devices

