# Variables

PRODUCT_NAME := UhooiPicBook
WORKSPACE_NAME := ${PRODUCT_NAME}.xcworkspace
UI_TESTS_TARGET_NAME := ${PRODUCT_NAME}UITests

TEST_SDK := iphonesimulator
TEST_CONFIGURATION := Debug
TEST_PLATFORM := iOS Simulator
TEST_DEVICE ?= iPhone 13 Pro Max
TEST_OS ?= 15.2
TEST_DESTINATION := 'platform=${TEST_PLATFORM},name=${TEST_DEVICE},OS=${TEST_OS}'
COVERAGE_OUTPUT := html_report

XCODEBUILD_BUILD_LOG_NAME := xcodebuild_build.log
XCODEBUILD_TEST_LOG_NAME := xcodebuild_test.log

DEVELOP_PROJECT_NAME := Develop
PRODUCTION_PROJECT_NAME := Production

CLI_TOOLS_PACKAGE_PATH := Tools/${PRODUCT_NAME}Tools
CLI_TOOLS_PATH := ${CLI_TOOLS_PACKAGE_PATH}/.build/release

MOCK_FILE_PATH := ./UhooiPicbookTests/Generated/MockResults.swift

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
	$(MAKE) download-firebase-sdk
	$(MAKE) generate-licenses
	$(MAKE) generate-mocks
	$(MAKE) open

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
	$(MAKE) build-cli-tool CLI_TOOL_NAME=swiftlint
	$(MAKE) build-cli-tool CLI_TOOL_NAME=iblinter
	$(MAKE) build-cli-tool CLI_TOOL_NAME=SpellChecker
	$(MAKE) build-cli-tool CLI_TOOL_NAME=mockolo
	$(MAKE) build-cli-tool CLI_TOOL_NAME=license-plist
	$(MAKE) build-cli-tool CLI_TOOL_NAME=xcbeautify

.PHONY: build-cli-tool
build-cli-tool:
	swift build -c release --package-path ${CLI_TOOLS_PACKAGE_PATH} --product ${CLI_TOOL_NAME}

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
	${CLI_TOOLS_PATH}/license-plist --output-path App/${PRODUCT_NAME}/Resources/Settings.bundle --add-version-numbers --config-path lic-plist.yml

.PHONY: generate-mocks
generate-mocks: # Generate mocks with Mockolo
	rm -f ${MOCK_FILE_PATH}
	${CLI_TOOLS_PATH}/mockolo --sourcedirs ./Sources --destination ${MOCK_FILE_PATH} --testable-imports AppModule --mock-final

.PHONY: generate-module
generate-module: # Generate module with Generamba # MODULE_NAME=[module name]
	bundle exec generamba gen ${MODULE_NAME} ${MODULE_TEMPLATE_NAME}

.PHONY: open
open: # Open workspace in Xcode
	open ./${WORKSPACE_NAME}

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
	$(MAKE) build-develop-debug
	${CLI_TOOLS_PATH}/swiftlint analyze --autocorrect --compiler-log-path ./${XCODEBUILD_BUILD_LOG_NAME}

.PHONY: build-develop-debug
build-develop-debug: # Xcode debug build for develop
	$(MAKE) build-debug PROJECT_NAME=${DEVELOP_PROJECT_NAME}

.PHONY: build-production-debug
build-production-debug: # Xcode debug build for production
	$(MAKE) build-debug PROJECT_NAME=${PRODUCTION_PROJECT_NAME}

.PHONY: build-debug
build-debug:
	set -o pipefail \
&& xcodebuild \
-sdk ${TEST_SDK} \
-configuration ${TEST_CONFIGURATION} \
-workspace ${WORKSPACE_NAME} \
-scheme '${PRODUCT_NAME} (${PROJECT_NAME} project)' \
-destination ${TEST_DESTINATION} \
-clonedSourcePackagesDirPath './SourcePackages' \
clean build \
| tee ./${XCODEBUILD_BUILD_LOG_NAME} \
| ${CLI_TOOLS_PATH}/xcbeautify

.PHONY: test-develop-debug
test-develop-debug: # Xcode debug test for develop
	rm -rf ./TestResults.xcresult/
	$(MAKE) test-debug PROJECT_NAME=${DEVELOP_PROJECT_NAME}

.PHONY: test-production-debug
test-production-debug: # Xcode debug test for production
	rm -rf ./TestResults.xcresult/
	$(MAKE) test-debug PROJECT_NAME=${PRODUCTION_PROJECT_NAME}

.PHONY: test-debug
test-debug:
	set -o pipefail \
&& NSUnbufferedIO=YES \
xcodebuild \
-sdk ${TEST_SDK} \
-configuration ${TEST_CONFIGURATION} \
-workspace ${WORKSPACE_NAME} \
-scheme '${PRODUCT_NAME} (${PROJECT_NAME} project)' \
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

.PHONY: show-devices
show-devices: # Show devices
	xcrun xctrace list devices

