PRODUCT_NAME := UhooiPicBook
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
	bundle install --jobs 4 --retry 3

.PHONY: install-mint
install-mint: # Install Mint dependencies
	mint bootstrap

.PHONY: install-cocoapods
install-cocoapods: # Install CocoaPods dependencies and generate workspace
	bundle exec pod install

.PHONY: install-carthage
install-carthage: # Install Carthage dependencies
	mint run carthage carthage bootstrap --platform iOS --cache-builds

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
	open ./${PRODUCT_NAME}.xcworkspace

.PHONY: clean
clean: # Delete cache
	xcodebuild clean -alltargets
	rm -rf ./Pods
	rm -rf ./Carthage
	rm -rf ./vendor/bundle
	rm -rf ./Templates

