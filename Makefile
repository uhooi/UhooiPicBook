# Variables

PRODUCT_NAME := UhooiPicBook
PROJECT_NAME := ${PRODUCT_NAME}.xcodeproj
SCHEME_NAME := ${PRODUCT_NAME}
UI_TESTS_TARGET_NAME := ${PRODUCT_NAME}UITests

TEST_SDK := iphonesimulator
TEST_CONFIGURATION := Debug
TEST_PLATFORM := iOS Simulator
TEST_DEVICE ?= iPhone 12 Pro Max
TEST_OS ?= 14.3
TEST_DESTINATION := 'platform=${TEST_PLATFORM},name=${TEST_DEVICE},OS=${TEST_OS}'
COVERAGE_OUTPUT := html_report

XCODEBUILD_BUILD_LOG_NAME := xcodebuild_build.log
XCODEBUILD_TEST_LOG_NAME := xcodebuild_test.log

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
	$(MAKE) generate-licenses

.PHONY: install-bundler
install-bundler: # Install Bundler dependencies
	bundle config path vendor/bundle
	bundle install --without=documentation --jobs 4 --retry 3

.PHONY: update-bundler
update-bundler: # Update Bundler dependencies
	bundle config path vendor/bundle
	bundle update --jobs 4 --retry 3

.PHONY: install-mint
install-mint: # Install Mint dependencies
	mint bootstrap --overwrite y

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
	$(MAKE) open

.PHONY: open
open: # Open project in Xcode
	open ./${PROJECT_NAME}

.PHONY: clean
clean: # Delete cache
	rm -rf ./vendor/bundle
	rm -rf ./Templates
	xcodebuild clean -alltargets

.PHONY: analyze
analyze: # Analyze with SwiftLint
	$(MAKE) build-debug
	mint run swiftlint swiftlint analyze --autocorrect --compiler-log-path ./${XCODEBUILD_BUILD_LOG_NAME}

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
build \
| tee ./${XCODEBUILD_BUILD_LOG_NAME} \
| bundle exec xcpretty --color

.PHONY: test
test: # Xcode test # TEST_DEVICE=[device] TEST_OS=[OS]
	set -o pipefail \
&& xcodebuild \
-sdk ${TEST_SDK} \
-configuration ${TEST_CONFIGURATION} \
-project ${PROJECT_NAME} \
-scheme ${SCHEME_NAME} \
-destination ${TEST_DESTINATION} \
-skip-testing:${UI_TESTS_TARGET_NAME} \
-clonedSourcePackagesDirPath './SourcePackages' \
clean test \
| tee ./${XCODEBUILD_TEST_LOG_NAME} \
| bundle exec xcpretty --color --report html

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
