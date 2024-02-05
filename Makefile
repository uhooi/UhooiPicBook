# Variables

PRODUCT_NAME := UhooiPicBook
WORKSPACE_NAME := ${PRODUCT_NAME}.xcworkspace
UI_TESTS_TARGET_NAME := ${PRODUCT_NAME}UITests

TEST_SDK := iphonesimulator
TEST_CONFIGURATION := Debug
TEST_PLATFORM := iOS Simulator
TEST_DEVICE ?= iPhone 15 Pro Max
TEST_OS ?= 17.2
TEST_DESTINATION := 'platform=${TEST_PLATFORM},name=${TEST_DEVICE},OS=${TEST_OS}'

DEVELOP_PROJECT_NAME := Develop
PRODUCTION_PROJECT_NAME := Production

export MINT_PATH := .mint/lib
export MINT_LINK_PATH := .mint/bin

MOCK_FILE_PATH := ./Tests/AppModuleTests/Generated/MockResults.swift

FIREBASE_VERSION := 10.3.0

REPORTS_PATH := ./Reports

.DEFAULT_GOAL := help

# Targets

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?# .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":[^#]*? #| #"}; {printf "%-36s%s\n", $$1 $$3, $$2}'

.PHONY: setup
setup: # Install dependencies and prepared development configuration
	$(MAKE) install-mint-dependencies
	$(MAKE) download-firebase-sdk
	$(MAKE) generate-licenses
	$(MAKE) generate-mocks
	$(MAKE) open

.PHONY: install-mint-dependencies
install-mint-dependencies: # Install Mint dependencies
	mint bootstrap --overwrite y

.PHONY: download-firebase-sdk
download-firebase-sdk: # Download firebase-ios-sdk
	curl -OL https://github.com/firebase/firebase-ios-sdk/releases/download/${FIREBASE_VERSION}/Firebase.zip
	unzip -o Firebase.zip -d Frameworks/
	rm -f Firebase.zip

.PHONY: generate-licenses
generate-licenses: # Generate licenses with LicensePlist
	mint run mono0926/LicensePlist license-plist --output-path App/${PRODUCT_NAME}/Resources/Settings.bundle --add-version-numbers --config-path .lic-plist.yml

.PHONY: generate-mocks
generate-mocks: # Generate mocks with Mockolo
	rm -f ${MOCK_FILE_PATH}
	mint run uber/mockolo mockolo --sourcedirs ./Sources --destination ${MOCK_FILE_PATH} --testable-imports AppModule --exclude-imports FirebaseMessaging --mock-final

.PHONY: open
open: # Open workspace in Xcode
	open ./${WORKSPACE_NAME}

.PHONY: clean
clean: # Delete cache
	rm -rf ./.swiftpm
	rm -rf ./.build
	rm -rf ./SourcePackages
	rm -rf ./Reports
	rm -rf ./.swiftlint
	rm -rf ./App/.swiftlint
	rm -rf ./.mint
	xcodebuild clean -alltargets

.PHONY: lint
lint: # Lint with SwiftLint
	mint run realm/SwiftLint swiftlint

.PHONY: fix
fix: # Fix with SwiftLint
	mint run realm/SwiftLint swiftlint --fix --format

.PHONY: analyze
analyze: # Analyze with SwiftLint
	$(MAKE) build-debug-develop
	mint run realm/SwiftLint swiftlint analyze --fix --compiler-log-path ${REPORTS_PATH}/${PRODUCT_NAME}_${PROJECT_NAME}_Build.log

.PHONY: lint-ib
lint-ib: # Lint with IBLinter
	mint run IBDecodable/IBLinter iblinter lint

.PHONY: build-debug-develop
build-debug-develop: # Xcode debug build for develop
	$(MAKE) build-debug PROJECT_NAME=${DEVELOP_PROJECT_NAME}

.PHONY: build-debug-production
build-debug-production: # Xcode debug build for production
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
| tee ${REPORTS_PATH}/${PRODUCT_NAME}_${PROJECT_NAME}_Build.log \
| mint run tuist/xcbeautify xcbeautify

.PHONY: test-debug-develop
test-debug-develop: # Xcode debug test for develop
	$(MAKE) test-debug-project PROJECT_NAME=${DEVELOP_PROJECT_NAME}

.PHONY: test-debug-project
test-debug-project:
	$(MAKE) test-debug SCHEME_NAME='${PRODUCT_NAME} (${PROJECT_NAME} project)' TEST_PLAN_NAME='${PROJECT_NAME}' XCRESULT_NAME=${PRODUCT_NAME}_${PROJECT_NAME} LOG_NAME=${PRODUCT_NAME}_${PROJECT_NAME}

.PHONY: test-debug-app-module
test-debug-app-module: # Xcode debug test for AppModule
	$(MAKE) test-debug-target TEST_TARGET_NAME='AppModuleTests'

.PHONY: test-debug-target
test-debug-target:
	$(MAKE) test-debug SCHEME_NAME='${TEST_TARGET_NAME}' TEST_PLAN_NAME='${TEST_TARGET_NAME}' XCRESULT_NAME='${TEST_TARGET_NAME}' LOG_NAME=${TEST_TARGET_NAME}

.PHONY: test-debug
test-debug:
	rm -rf ${REPORTS_PATH}/${XCRESULT_NAME}.xcresult/
	set -o pipefail \
&& NSUnbufferedIO=YES \
xcodebuild \
-sdk ${TEST_SDK} \
-configuration ${TEST_CONFIGURATION} \
-workspace ${WORKSPACE_NAME} \
-scheme '${SCHEME_NAME}' \
-destination ${TEST_DESTINATION} \
-testPlan '${TEST_PLAN_NAME}' \
-skip-testing:${UI_TESTS_TARGET_NAME} \
-clonedSourcePackagesDirPath './SourcePackages' \
-skipPackagePluginValidation \
-resultBundlePath '${REPORTS_PATH}/${XCRESULT_NAME}.xcresult' \
clean test \
2>&1 \
| tee ${REPORTS_PATH}/${LOG_NAME}_Test.log \
| mint run tuist/xcbeautify xcbeautify --is-ci

.PHONY: merge-test-results
merge-test-results: # Merge test results
	rm -rf ${REPORTS_PATH}/TestResults.xcresult/
	xcrun xcresulttool merge ${REPORTS_PATH}/${PRODUCT_NAME}_${DEVELOP_PROJECT_NAME}.xcresult ${REPORTS_PATH}/AppModuleTests.xcresult --output-path ${REPORTS_PATH}/TestResults.xcresult

.PHONY: show-devices
show-devices: # Show devices
	xcrun xctrace list devices

