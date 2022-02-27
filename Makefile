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

DEVELOP_PROJECT_NAME := Develop
PRODUCTION_PROJECT_NAME := Production

CLI_TOOLS_PACKAGE_PATH := Tools/${PRODUCT_NAME}Tools
CLI_TOOLS_PATH := ${CLI_TOOLS_PACKAGE_PATH}/.build/release

MOCK_FILE_PATH := ./Tests/AppModuleTests/Generated/MockResults.swift

FIREBASE_VERSION := v8.12.1

REPORTS_PATH := ./Reports

.DEFAULT_GOAL := help

# Targets

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?# .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":[^#]*? #| #"}; {printf "%-36s%s\n", $$1 $$3, $$2}'

.PHONY: setup
setup: # Install dependencies and prepared development configuration
	$(MAKE) build-cli-tools
	$(MAKE) download-firebase-sdk
	$(MAKE) generate-licenses
	$(MAKE) generate-mocks
	$(MAKE) open

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

.PHONY: download-firebase-sdk
download-firebase-sdk: # Download firebase-ios-sdk
	curl -OL https://github.com/firebase/firebase-ios-sdk/releases/download/${FIREBASE_VERSION}/Firebase.zip
	unzip -o Firebase.zip -d Frameworks/
	rm -f Firebase.zip

.PHONY: generate-licenses
generate-licenses: # Generate licenses with LicensePlist
	${CLI_TOOLS_PATH}/license-plist --output-path App/${PRODUCT_NAME}/Resources/Settings.bundle --add-version-numbers --config-path .lic-plist.yml

.PHONY: generate-mocks
generate-mocks: # Generate mocks with Mockolo
	rm -f ${MOCK_FILE_PATH}
	${CLI_TOOLS_PATH}/mockolo --sourcedirs ./Sources --destination ${MOCK_FILE_PATH} --testable-imports AppModule --exclude-imports FirebaseMessaging --mock-final

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
	rm -rf ./${CLI_TOOLS_PACKAGE_PATH}/.swiftpm
	rm -rf ./${CLI_TOOLS_PACKAGE_PATH}/.build
	xcodebuild clean -alltargets

.PHONY: clean-cli-tools
clean-cli-tools: # Delete build artifacts for CLI tools managed by SwiftPM
	swift package --package-path ${CLI_TOOLS_PACKAGE_PATH} clean

.PHONY: analyze
analyze: # Analyze with SwiftLint
	$(MAKE) build-debug-develop
	${CLI_TOOLS_PATH}/swiftlint analyze --autocorrect --compiler-log-path ./${XCODEBUILD_BUILD_LOG_NAME}

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
| ${CLI_TOOLS_PATH}/xcbeautify

.PHONY: test-debug-develop
test-debug-develop: # Xcode debug test for develop
	$(MAKE) test-debug-project PROJECT_NAME=${DEVELOP_PROJECT_NAME}

.PHONY: test-debug-production
test-debug-production: # Xcode debug test for production
	$(MAKE) test-debug-project PROJECT_NAME=${PRODUCTION_PROJECT_NAME}

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
-resultBundlePath '${REPORTS_PATH}/${XCRESULT_NAME}.xcresult' \
clean test \
2>&1 \
| tee ${REPORTS_PATH}/${LOG_NAME}_Test.log \
| ${CLI_TOOLS_PATH}/xcbeautify --is-ci

.PHONY: merge-test-results
merge-test-results: # Merge test results
	rm -rf ${REPORTS_PATH}/TestResults.xcresult/
	xcrun xcresulttool merge ${REPORTS_PATH}/${PRODUCT_NAME}_${DEVELOP_PROJECT_NAME}.xcresult ${REPORTS_PATH}/AppModuleTests.xcresult --output-path ${REPORTS_PATH}/TestResults.xcresult

.PHONY: show-devices
show-devices: # Show devices
	xcrun xctrace list devices

