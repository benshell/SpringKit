## SpringKit — XCFramework & Binary SPM Package Build
##
## Targets:
##   make xcframework     Build SpringKit.xcframework (device + simulator slices)
##   make zip             Zip the XCFramework and compute SPM checksum
##   make binary-package  Generate a ready-to-publish binary Package.swift
##   make clean           Remove all build artifacts
##
## Prerequisites: Xcode 17+, iOS 26 SDK, active developer dir pointing at Xcode:
##   sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
##
## Open Package.swift in Xcode at least once first so the workspace exists at
## .swiftpm/xcode/package.xcworkspace.
##
## Usage:
##   make xcframework
##   make binary-package RELEASE_URL=https://github.com/you/SpringKit/releases/download/1.0.0/SpringKit.xcframework.zip

# ── Configuration ─────────────────────────────────────────────────────────────

SCHEME          := SpringKit
WORKSPACE       := .swiftpm/xcode/package.xcworkspace
BUNDLE_NAME     := SpringKit_SpringKit.bundle

BUILD_DIR       := build
IOS_ARCHIVE     := $(BUILD_DIR)/archives/SpringKit-iOS.xcarchive
SIM_ARCHIVE     := $(BUILD_DIR)/archives/SpringKit-iOS-Simulator.xcarchive
IOS_DERIVED     := $(BUILD_DIR)/DerivedData-iOS
SIM_DERIVED     := $(BUILD_DIR)/DerivedData-Sim
XCFRAMEWORK     := $(BUILD_DIR)/SpringKit.xcframework
XCFRAMEWORK_ZIP := $(BUILD_DIR)/SpringKit.xcframework.zip
CHECKSUM_FILE   := $(BUILD_DIR)/SpringKit.xcframework.checksum
BINARY_PKG_DIR  := $(BUILD_DIR)/BinaryPackage

RELEASE_URL ?= https://REPLACE_WITH_YOUR_HOSTING_URL/SpringKit.xcframework.zip

# ── Phony targets ─────────────────────────────────────────────────────────────

.PHONY: xcframework zip binary-package clean help

# ── xcframework ───────────────────────────────────────────────────────────────

xcframework:
	@echo "▸ Archiving for iOS (device)…"
	xcodebuild archive \
		-workspace "$(WORKSPACE)" \
		-scheme "$(SCHEME)" \
		-destination "generic/platform=iOS" \
		-archivePath "$(IOS_ARCHIVE)" \
		-derivedDataPath "$(IOS_DERIVED)" \
		BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
		SKIP_INSTALL=NO

	@echo "▸ Archiving for iOS Simulator…"
	xcodebuild archive \
		-workspace "$(WORKSPACE)" \
		-scheme "$(SCHEME)" \
		-destination "generic/platform=iOS Simulator" \
		-archivePath "$(SIM_ARCHIVE)" \
		-derivedDataPath "$(SIM_DERIVED)" \
		BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
		SKIP_INSTALL=NO

	@echo "▸ Embedding resource bundle into frameworks…"
	@IOS_FW=$$(find "$(IOS_ARCHIVE)" -name "SpringKit.framework" -type d | head -1); \
	 SIM_FW=$$(find "$(SIM_ARCHIVE)" -name "SpringKit.framework" -type d | head -1); \
	 if [ -z "$$IOS_FW" ]; then echo "✗ iOS framework not found in archive."; exit 1; fi; \
	 if [ -z "$$SIM_FW" ]; then echo "✗ Simulator framework not found in archive."; exit 1; fi; \
	 IOS_BUNDLE=$$(find "$(IOS_DERIVED)" -name "$(BUNDLE_NAME)" | head -1); \
	 SIM_BUNDLE=$$(find "$(SIM_DERIVED)" -name "$(BUNDLE_NAME)" | head -1); \
	 if [ -n "$$IOS_BUNDLE" ]; then \
	   echo "  Embedding bundle into iOS framework…"; \
	   cp -r "$$IOS_BUNDLE" "$$IOS_FW/"; \
	 else \
	   echo "  ⚠ iOS resource bundle not found (colors/fonts will not be embedded)."; \
	 fi; \
	 if [ -n "$$SIM_BUNDLE" ]; then \
	   echo "  Embedding bundle into Simulator framework…"; \
	   cp -r "$$SIM_BUNDLE" "$$SIM_FW/"; \
	 else \
	   echo "  ⚠ Simulator resource bundle not found (colors/fonts will not be embedded)."; \
	 fi; \
	 echo "▸ Creating XCFramework…"; \
	 rm -rf "$(XCFRAMEWORK)"; \
	 xcodebuild -create-xcframework \
	   -framework "$$IOS_FW" \
	   -framework "$$SIM_FW" \
	   -output "$(XCFRAMEWORK)"

	@echo "✓ Built: $(XCFRAMEWORK)"
	@echo ""
	@find "$(XCFRAMEWORK)" -maxdepth 4 -name "*.bundle" | sed 's/^/  Bundle: /'
	@echo ""

# ── zip ───────────────────────────────────────────────────────────────────────

zip: xcframework
	@echo "▸ Zipping XCFramework…"
	@rm -f "$(XCFRAMEWORK_ZIP)"
	cd "$(BUILD_DIR)" && zip -r SpringKit.xcframework.zip SpringKit.xcframework
	@echo "▸ Computing SPM checksum…"
	@CHECKSUM=$$(swift package compute-checksum "$(XCFRAMEWORK_ZIP)"); \
	 echo "$$CHECKSUM" > "$(CHECKSUM_FILE)"; \
	 echo "✓ Checksum: $$CHECKSUM"; \
	 echo "✓ Zip:      $(XCFRAMEWORK_ZIP)"

# ── binary-package ────────────────────────────────────────────────────────────

binary-package: zip
	@mkdir -p "$(BINARY_PKG_DIR)"
	@cp "$(XCFRAMEWORK_ZIP)" "$(BINARY_PKG_DIR)/"
	@CHECKSUM=$$(cat "$(CHECKSUM_FILE)"); \
	 echo "▸ Generating binary Package.swift (checksum: $$CHECKSUM)…"; \
	 printf '// swift-tools-version: 6.2\n//\n// SpringKit — Binary Distribution Package\n//\n// Consumers add this package (not the source package) via:\n//   Xcode → Add Package Dependencies → <your distribution repo URL>\n//\nimport PackageDescription\n\nlet package = Package(\n    name: "SpringKit",\n    platforms: [\n        .iOS(.v26)\n    ],\n    products: [\n        .library(\n            name: "SpringKit",\n            targets: ["SpringKit"]\n        )\n    ],\n    targets: [\n        .binaryTarget(\n            name: "SpringKit",\n            url: "$(RELEASE_URL)",\n            checksum: "'"$$CHECKSUM"'"\n        )\n    ]\n)\n' > "$(BINARY_PKG_DIR)/Package.swift"
	@echo ""
	@echo "✓ Binary package ready at: $(BINARY_PKG_DIR)/"
	@echo ""
	@echo "  Next steps:"
	@echo "  1. Upload $(XCFRAMEWORK_ZIP) to $(RELEASE_URL)"
	@echo "  2. Publish $(BINARY_PKG_DIR)/Package.swift to your distribution repo"
	@echo "  3. Tag the release: git tag 1.0.0 && git push --tags"

# ── clean ─────────────────────────────────────────────────────────────────────

clean:
	@rm -rf "$(BUILD_DIR)"
	@echo "✓ Cleaned build/"

# ── help ──────────────────────────────────────────────────────────────────────

help:
	@echo ""
	@echo "SpringKit build targets"
	@echo "────────────────────────────────────────────────────────────────"
	@echo "  make xcframework                   Build SpringKit.xcframework"
	@echo "  make zip                           Zip + compute SPM checksum"
	@echo "  make binary-package RELEASE_URL=…  Generate binary Package.swift"
	@echo "  make clean                         Remove build/"
	@echo ""
	@echo "  make binary-package RELEASE_URL=https://github.com/you/SpringKit/releases/download/1.0.0/SpringKit.xcframework.zip"
	@echo ""
