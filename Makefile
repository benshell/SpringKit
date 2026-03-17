## SpringKit — XCFramework & Binary SPM Package Build
##
## Targets:
##   make xcframework     Build SpringKit.xcframework (device + simulator slices)
##   make zip             Zip the XCFramework and compute SPM checksum
##   make binary-package  Generate a ready-to-publish binary Package.swift
##   make clean           Remove all build artifacts
##
## Prerequisites: Xcode 17+, iOS 26 SDK. Open Package.swift in Xcode at least
## once before running so the auto-generated workspace exists at
## .swiftpm/xcode/package.xcworkspace.
##
## Usage:
##   make xcframework
##   make binary-package RELEASE_URL=https://github.com/you/SpringKit/releases/download/1.0.0/SpringKit.xcframework.zip

# ── Configuration ────────────────────────────────────────────────────────────

SCHEME          := SpringKit
WORKSPACE       := .swiftpm/xcode/package.xcworkspace

BUILD_DIR       := build
ARCHIVES_DIR    := $(BUILD_DIR)/archives
XCFRAMEWORK     := $(BUILD_DIR)/SpringKit.xcframework
XCFRAMEWORK_ZIP := $(BUILD_DIR)/SpringKit.xcframework.zip
CHECKSUM_FILE   := $(BUILD_DIR)/SpringKit.xcframework.checksum
BINARY_PKG_DIR  := $(BUILD_DIR)/BinaryPackage

# URL where SpringKit.xcframework.zip will be hosted.
# Override at the command line:  make binary-package RELEASE_URL=https://...
RELEASE_URL     ?= https://REPLACE_WITH_YOUR_HOSTING_URL/SpringKit.xcframework.zip

# Optional: pipe xcodebuild through xcpretty for readable output if installed.
XCPRETTY        := $(shell command -v xcpretty 2>/dev/null && echo "| xcpretty" || echo "")

# ── Phony targets ─────────────────────────────────────────────────────────────

.PHONY: xcframework zip binary-package clean help

# ── xcframework ───────────────────────────────────────────────────────────────

xcframework:
	@echo "▸ Archiving for iOS (device)…"
	xcodebuild archive \
		-workspace "$(WORKSPACE)" \
		-scheme "$(SCHEME)" \
		-destination "generic/platform=iOS" \
		-archivePath "$(ARCHIVES_DIR)/SpringKit-iOS" \
		BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
		SKIP_INSTALL=NO \
		$(XCPRETTY)

	@echo "▸ Archiving for iOS Simulator…"
	xcodebuild archive \
		-workspace "$(WORKSPACE)" \
		-scheme "$(SCHEME)" \
		-destination "generic/platform=iOS Simulator" \
		-archivePath "$(ARCHIVES_DIR)/SpringKit-iOS-Simulator" \
		BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
		SKIP_INSTALL=NO \
		$(XCPRETTY)

	@echo "▸ Locating built frameworks…"
	$(eval IOS_FW := $(shell find "$(ARCHIVES_DIR)/SpringKit-iOS.xcarchive" -name "SpringKit.framework" -type d | head -1))
	$(eval SIM_FW := $(shell find "$(ARCHIVES_DIR)/SpringKit-iOS-Simulator.xcarchive" -name "SpringKit.framework" -type d | head -1))

	@if [ -z "$(IOS_FW)" ]; then echo "✗ iOS framework not found in archive. Check that the archive succeeded."; exit 1; fi
	@if [ -z "$(SIM_FW)" ]; then echo "✗ Simulator framework not found in archive. Check that the archive succeeded."; exit 1; fi
	@echo "  iOS:       $(IOS_FW)"
	@echo "  Simulator: $(SIM_FW)"

	@echo "▸ Creating XCFramework…"
	@rm -rf "$(XCFRAMEWORK)"
	xcodebuild -create-xcframework \
		-framework "$(IOS_FW)" \
		-framework "$(SIM_FW)" \
		-output "$(XCFRAMEWORK)"

	@echo "✓ Built: $(XCFRAMEWORK)"

# ── zip ───────────────────────────────────────────────────────────────────────

zip: xcframework
	@echo "▸ Zipping XCFramework…"
	@rm -f "$(XCFRAMEWORK_ZIP)"
	cd "$(BUILD_DIR)" && zip -r SpringKit.xcframework.zip SpringKit.xcframework

	@echo "▸ Computing SPM checksum…"
	$(eval CHECKSUM := $(shell swift package compute-checksum "$(XCFRAMEWORK_ZIP)"))
	@echo "$(CHECKSUM)" > "$(CHECKSUM_FILE)"
	@echo "✓ Checksum: $(CHECKSUM)"
	@echo "✓ Zip: $(XCFRAMEWORK_ZIP)"

# ── binary-package ────────────────────────────────────────────────────────────

binary-package: zip
	$(eval CHECKSUM := $(shell cat "$(CHECKSUM_FILE)"))
	@mkdir -p "$(BINARY_PKG_DIR)"
	@cp "$(XCFRAMEWORK_ZIP)" "$(BINARY_PKG_DIR)/"

	@echo "▸ Generating binary Package.swift…"
	@printf '// swift-tools-version: 6.0\n\
//\n\
// SpringKit — Binary Distribution Package\n\
//\n\
// This Package.swift references a pre-compiled XCFramework.\n\
// Consumers add this package (not the source package) for faster builds\n\
// and without needing the source.\n\
//\n\
// To publish a new release:\n\
//   1. Host SpringKit.xcframework.zip at RELEASE_URL\n\
//   2. Update the url and checksum below\n\
//   3. Tag the release in git\n\
\nimport PackageDescription\n\
\nlet package = Package(\n\
    name: "SpringKit",\n\
    platforms: [\n\
        .iOS(.v26)\n\
    ],\n\
    products: [\n\
        .library(\n\
            name: "SpringKit",\n\
            targets: ["SpringKit"]\n\
        )\n\
    ],\n\
    targets: [\n\
        .binaryTarget(\n\
            name: "SpringKit",\n\
            url: "$(RELEASE_URL)",\n\
            checksum: "$(CHECKSUM)"\n\
        )\n\
    ]\n\
)\n' > "$(BINARY_PKG_DIR)/Package.swift"

	@echo ""
	@echo "✓ Binary package ready: $(BINARY_PKG_DIR)/"
	@echo ""
	@echo "  Next steps:"
	@echo "  1. Upload $(XCFRAMEWORK_ZIP) to: $(RELEASE_URL)"
	@echo "  2. Publish $(BINARY_PKG_DIR)/Package.swift to your distribution repo"
	@echo "  3. Tag the release (e.g. git tag 1.0.0 && git push --tags)"
	@echo ""
	@echo "  Consumers add the binary package via:"
	@echo "  Xcode → Add Package Dependencies → enter your distribution repo URL"

# ── clean ─────────────────────────────────────────────────────────────────────

clean:
	@rm -rf "$(BUILD_DIR)"
	@echo "✓ Cleaned build/"

# ── help ──────────────────────────────────────────────────────────────────────

help:
	@echo ""
	@echo "SpringKit build targets"
	@echo "───────────────────────────────────────────────────────────────────"
	@echo "  make xcframework                   Build SpringKit.xcframework"
	@echo "  make zip                           Zip + compute SPM checksum"
	@echo "  make binary-package RELEASE_URL=…  Generate binary Package.swift"
	@echo "  make clean                         Remove build/"
	@echo ""
	@echo "Example full release:"
	@echo "  make binary-package RELEASE_URL=https://github.com/you/SpringKit/releases/download/1.0.0/SpringKit.xcframework.zip"
	@echo ""
