PRODUCT_NAME := UhooiPicBook
SCHEME_NAME := ${PRODUCT_NAME}
WORKSPACE_NAME := ${PRODUCT_NAME}.xcworkspace
UI_TESTS_TARGET_NAME := ${PRODUCT_NAME}UITests

TEST_SDK := iphonesimulator
TEST_CONFIGURATION := Debug
TEST_PLATFORM := iOS Simulator
TEST_DEVICE ?= iPhone 11 Pro Max
TEST_OS ?= 13.3
TEST_DESTINATION := 'platform=${TEST_PLATFORM},name=${TEST_DEVICE},OS=${TEST_OS}'

SDK := iphoneos
CONFIGURATION := Release
ARCHIVE_PATH := ./build/${PRODUCT_NAME}.xcarchive
EXPORT_PATH := ./output/${SDK}/${CONFIGURATION}

DEVELOPMENT_TEAM := 47E56DYP3N
PRODUCT_BUNDLE_IDENTIFIER := com.theuhooi.UhooiPicBook
ADHOC_PROVISIONING_PROFILE_SPECIFIER := UhooiPicBook_AdHoc
ADHOC_EXPORT_OPTIONS_PATH := ./ExportOptions/ExportOptionsAdHoc.plist
APPSTORE_PROVISIONING_PROFILE_SPECIFIER := UhooiPicBook_AppStore
APPSTORE_EXPORT_OPTIONS_PATH := ./ExportOptions/ExportOptionsAppStore.plist

MODULE_TEMPLATE_NAME ?= uhooi_viper

.DEFAULT_GOAL := help

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?# .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":[^#]*? #| #"}; {printf "%-42s%s\n", $$1 $$3, $$2}'

.PHONY: setup
setup: # Install dependencies and prepared development configuration
	$(MAKE) install-bundler
	$(MAKE) install-templates
	$(MAKE) install-mint
	$(MAKE) install-carthage
	$(MAKE) generate-licenses

.PHONY: install-bundler
install-bundler: # Install Bundler dependencies
	bundle config path vendor/bundle
	bundle install --jobs 4 --retry 3

.PHONY: update-bundler
update-bundler: # Update Bundler dependencies
	bundle config path vendor/bundle
	bundle update --jobs 4 --retry 3

.PHONY: install-mint
install-mint: # Install Mint dependencies
	mint bootstrap

.PHONY: install-cocoapods
install-cocoapods: # Install CocoaPods dependencies and generate workspace
	bundle exec pod install

.PHONY: update-cocoapods
update-cocoapods: # Update CocoaPods dependencies and generate workspace
	bundle exec pod update

.PHONY: install-carthage
install-carthage: # Install Carthage dependencies
	mint run carthage carthage bootstrap --platform iOS --cache-builds
	$(MAKE) show-carthage-dependencies

.PHONY: update-carthage
update-carthage: # Update Carthage dependencies
	mint run carthage carthage update --platform iOS
	$(MAKE) show-carthage-dependencies

.PHONY: show-carthage-dependencies
show-carthage-dependencies:
	@echo '*** Resolved dependencies:'
	@cat 'Cartfile.resolved'

.PHONY: install-templates
install-templates: # Install Generamba templates
	bundle exec generamba template install

.PHONY: generate-licenses
generate-licenses: # Generate licenses with LicensePlist and regenerate project
	mint run LicensePlist license-plist --output-path ${PRODUCT_NAME}/Settings.bundle
	$(MAKE) generate-xcodeproj

.PHONY: generate-module
generate-module: # Generate module with Generamba and regenerate project # MODULE_NAME=[module name]
	bundle exec generamba gen ${MODULE_NAME} ${MODULE_TEMPLATE_NAME}
	$(MAKE) generate-xcodeproj

.PHONY: generate-xcodeproj
generate-xcodeproj: # Generate project with XcodeGen
	mint run xcodegen xcodegen generate
	$(MAKE) install-cocoapods
	$(MAKE) open

.PHONY: open
open: # Open workspace in Xcode
	open ./${WORKSPACE_NAME}

.PHONY: clean
clean: # Delete cache
	xcodebuild clean -alltargets
	rm -rf ./Pods
	rm -rf ./Carthage
	rm -rf ./vendor/bundle
	rm -rf ./Templates

.PHONY: build-debug
build-debug: # Xcode build for debug
	set -o pipefail && \
xcodebuild \
-sdk ${TEST_SDK} \
-configuration ${TEST_CONFIGURATION} \
-workspace ${WORKSPACE_NAME} \
-scheme ${SCHEME_NAME} \
build \
| bundle exec xcpretty

.PHONY: test
test: # Xcode test # TEST_DEVICE=[device] TEST_OS=[OS]
	set -o pipefail && \
xcodebuild \
-sdk ${TEST_SDK} \
-configuration ${TEST_CONFIGURATION} \
-workspace ${WORKSPACE_NAME} \
-scheme ${SCHEME_NAME} \
-destination ${TEST_DESTINATION} \
-skip-testing:${UI_TESTS_TARGET_NAME} \
clean test \
| bundle exec xcpretty

.PHONY: show-devices
show-devices: # Show devices
	instruments -s devices

.PHONY: generate-ipa-adhoc
generate-ipa-adhoc: # Generate IPA file for Ad Hoc
	$(MAKE) archive-adhoc
	$(MAKE) export-archive-adhoc

.PHONY: archive-adhoc
archive-adhoc:
	$(MAKE) archive PROVISIONING_PROFILE_SPECIFIER=${ADHOC_PROVISIONING_PROFILE_SPECIFIER}

.PHONY: export-archive-adhoc
export-archive-adhoc:
	$(MAKE) export-archive EXPORT_OPTIONS_PATH=${ADHOC_EXPORT_OPTIONS_PATH}

.PHONY: generate-ipa-appstore
generate-ipa-appstore: # Generate IPA file for App Store
	$(MAKE) archive-appstore
	$(MAKE) export-archive-appstore

.PHONY: archive-appstore
archive-appstore:
	$(MAKE) archive PROVISIONING_PROFILE_SPECIFIER=${APPSTORE_PROVISIONING_PROFILE_SPECIFIER}

.PHONY: export-archive-appstore
export-archive-appstore:
	$(MAKE) export-archive EXPORT_OPTIONS_PATH=${APPSTORE_EXPORT_OPTIONS_PATH}

.PHONY: archive
archive:
	set -o pipefail && \
xcodebuild \
-sdk ${SDK} \
-configuration ${CONFIGURATION} \
-workspace ${WORKSPACE_NAME} \
-scheme ${SCHEME_NAME} \
-archivePath ${ARCHIVE_PATH} \
CODE_SIGN_STYLE=Manual \
CODE_SIGN_IDENTITY="iPhone Distribution" \
PROVISIONING_PROFILE_SPECIFIER=${PROVISIONING_PROFILE_SPECIFIER} \
DEVELOPMENT_TEAM=${DEVELOPMENT_TEAM} \
PRODUCT_BUNDLE_IDENTIFIER=${PRODUCT_BUNDLE_IDENTIFIER} \
clean archive \
| bundle exec xcpretty

.PHONY: export-archive
export-archive:
	set -o pipefail && \
xcodebuild \
-exportArchive \
-archivePath ${ARCHIVE_PATH} \
-exportPath ${EXPORT_PATH} \
-exportOptionsPlist ${EXPORT_OPTIONS_PATH} \
| bundle exec xcpretty

