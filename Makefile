# Variables

PRODUCT_NAME := UhooiPicBook
WORKSPACE_NAME := ${PRODUCT_NAME}.xcworkspace
SCHEME_NAME := ${PRODUCT_NAME}
UI_TESTS_TARGET_NAME := ${PRODUCT_NAME}UITests

TEST_SDK := iphonesimulator
TEST_CONFIGURATION := Debug
TEST_PLATFORM := iOS Simulator
TEST_DEVICE ?= iPhone 12 Pro Max
TEST_OS ?= 14.1
TEST_DESTINATION := 'platform=${TEST_PLATFORM},name=${TEST_DEVICE},OS=${TEST_OS}'
COVERAGE_OUTPUT := html_report

MODULE_TEMPLATE_NAME ?= uhooi_viper

.DEFAULT_GOAL := help

# Targets

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?# .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":[^#]*? #| #"}; {printf "%-42s%s\n", $$1 $$3, $$2}'

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
	@$(MAKE) export-carthage-config
	mint run carthage carthage bootstrap --platform iOS --cache-builds
	@$(MAKE) show-carthage-dependencies

.PHONY: update-carthage
update-carthage: # Update Carthage dependencies
	@$(MAKE) export-carthage-config
	mint run carthage carthage update --platform iOS
	@$(MAKE) show-carthage-dependencies

.PHONY: show-carthage-dependencies
show-carthage-dependencies:
	@echo '*** Resolved dependencies:'
	@cat 'Cartfile.resolved'

.PHONY: export-carthage-config
export-carthage-config:
	export XCODE_XCCONFIG_FILE=Configs/Carthage.xcconfig

.PHONY: install-templates
install-templates: # Install Generamba templates
	bundle exec generamba template install

.PHONY: generate-licenses
generate-licenses: # Generate licenses with LicensePlist and regenerate project
	mint run LicensePlist license-plist --output-path ${PRODUCT_NAME}/Settings.bundle --add-version-numbers
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
	set -o pipefail \
&& xcodebuild \
-sdk ${TEST_SDK} \
-configuration ${TEST_CONFIGURATION} \
-workspace ${WORKSPACE_NAME} \
-scheme ${SCHEME_NAME} \
build \
| bundle exec xcpretty

.PHONY: test
test: # Xcode test # TEST_DEVICE=[device] TEST_OS=[OS]
	set -o pipefail \
&& xcodebuild \
-sdk ${TEST_SDK} \
-configuration ${TEST_CONFIGURATION} \
-workspace ${WORKSPACE_NAME} \
-scheme ${SCHEME_NAME} \
-destination ${TEST_DESTINATION} \
-skip-testing:${UI_TESTS_TARGET_NAME} \
clean test \
| bundle exec xcpretty --report html

.PHONY: get-coverage
get-coverage: # Get code coverage
	bundle exec slather coverage --html --output-directory ${COVERAGE_OUTPUT}

.PHONY: show-devices
show-devices: # Show devices
	xcrun xctrace list devices

