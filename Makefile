# Variables

PRODUCT_NAME := UhooiPicBook
PROJECT_NAME := ${PRODUCT_NAME}.xcodeproj
SCHEME_NAME := ${PRODUCT_NAME}
UI_TESTS_TARGET_NAME := ${PRODUCT_NAME}UITests

TEST_SDK := iphonesimulator
TEST_CONFIGURATION := Debug
TEST_PLATFORM := iOS Simulator
TEST_DEVICE ?= iPhone 12 Pro Max
TEST_OS ?= 14.4
TEST_DESTINATION := 'platform=${TEST_PLATFORM},name=${TEST_DEVICE},OS=${TEST_OS}'
COVERAGE_OUTPUT := html_report

XCODEBUILD_BUILD_LOG_NAME := xcodebuild_build.log
XCODEBUILD_TEST_LOG_NAME := xcodebuild_test.log

DEVELOP_BUNDLE_IDENTIFIER :=com.theuhooi.UhooiPicBook-Develop
PRODUCTION_BUNDLE_IDENTIFIER :=com.theuhooi.UhooiPicBook

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

.PHONY: install-templates
install-templates: # Install Generamba templates
	bundle exec generamba template install

.PHONY: generate-licenses
generate-licenses: # Generate licenses with LicensePlist
	swift run -c release --package-path Tools/UhooiPicBookTools license-plist --output-path ${PRODUCT_NAME}/Settings.bundle --add-version-numbers

.PHONY: generate-module
generate-module: # Generate module with Generamba # MODULE_NAME=[module name]
	bundle exec generamba gen ${MODULE_NAME} ${MODULE_TEMPLATE_NAME}

.PHONY: generate-xcodeproj-develop
generate-xcodeproj-develop: # Generate project with XcodeGen for develop
	$(MAKE) copy-googleserviceinfo-develop
	$(MAKE) generate-xcodeproj BUNDLE_IDENTIFIER=${DEVELOP_BUNDLE_IDENTIFIER}

.PHONY: generate-xcodeproj-production
generate-xcodeproj-production: # Generate project with XcodeGen for production
	$(MAKE) copy-googleserviceinfo-production
	$(MAKE) generate-xcodeproj BUNDLE_IDENTIFIER=${PRODUCTION_BUNDLE_IDENTIFIER}

.PHONY: generate-xcodeproj
generate-xcodeproj:
	swift run -c release --package-path Tools/UhooiPicBookTools xcodegen generate
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
	rm -rf ./vendor/bundle
	rm -rf ./SourcePackages
	rm -rf ./Templates
	xcodebuild clean -alltargets

.PHONY: analyze
analyze: # Analyze with SwiftLint
	$(MAKE) build-debug
	swift run -c release --package-path Tools/UhooiPicBookTools swiftlint analyze --autocorrect --compiler-log-path ./${XCODEBUILD_BUILD_LOG_NAME}

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
| swift run -c release --package-path Tools/UhooiPicBookTools xcbeautify

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
clean test \
2>&1 \
| tee ./${XCODEBUILD_TEST_LOG_NAME} \
| swift run -c release --package-path Tools/UhooiPicBookTools xcbeautify --is-ci

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

