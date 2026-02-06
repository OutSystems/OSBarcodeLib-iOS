#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
source "${SCRIPT_DIR}/common.sh"

PROJECT_NAME="${1:-}"
LICENSE_FILE="${2:-}"
BUILD_DIR="./build"

if [ -z "$PROJECT_NAME" ] || [ -z "$LICENSE_FILE" ]; then
	log_error "Usage: build_framework.sh <project_name> <license_file>"
	exit 1
fi

trap 'log_error "Build failed."' ERR

# Validate prerequisites
check_command "xcodebuild"
check_file "${PROJECT_NAME}.xcodeproj/project.pbxproj"
check_file "$LICENSE_FILE"

# Check for optional dependencies
if ! check_command "xcbeautify"; then
    log_warning "xcbeautify not found, output will not be formatted"
    XCBEAUTIFY_CMD="cat"
else
    XCBEAUTIFY_CMD="xcbeautify"
fi

log_info "🛠️ Building XCFramework for ${PROJECT_NAME}..."

# Clean build directory
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

# Define xcarchive paths
SIMULATOR_XCARCHIVE="$BUILD_DIR/${PROJECT_NAME}.framework-iphonesimulator.xcarchive"
DEVICE_XCARCHIVE="$BUILD_DIR/${PROJECT_NAME}.framework-iphoneos.xcarchive"

log_info "🏗️ Building iOS Simulator archive..."
xcodebuild archive \
	-scheme "$PROJECT_NAME" \
	-configuration Release \
	-destination 'generic/platform=iOS Simulator' \
	-archivePath "$SIMULATOR_XCARCHIVE" \
	SKIP_INSTALL=NO \
	BUILD_LIBRARIES_FOR_DISTRIBUTION=YES | ${XCBEAUTIFY_CMD}

log_info "🏗️ Building iOS Device archive..."
xcodebuild archive \
	-scheme "$PROJECT_NAME" \
	-configuration Release \
	-destination 'generic/platform=iOS' \
	-archivePath "$DEVICE_XCARCHIVE" \
	SKIP_INSTALL=NO \
	BUILD_LIBRARIES_FOR_DISTRIBUTION=YES | ${XCBEAUTIFY_CMD}

XCFRAMEWORK_PATH="$BUILD_DIR/${PROJECT_NAME}.xcframework"

# Define framework and dSYM paths
SIMULATOR_FRAMEWORK="$SIMULATOR_XCARCHIVE/Products/Library/Frameworks/${PROJECT_NAME}.framework"
SIMULATOR_DSYM="$SIMULATOR_XCARCHIVE/dSYMs/${PROJECT_NAME}.framework.dSYM"
DEVICE_FRAMEWORK="$DEVICE_XCARCHIVE/Products/Library/Frameworks/${PROJECT_NAME}.framework"
DEVICE_DSYM="$DEVICE_XCARCHIVE/dSYMs/${PROJECT_NAME}.framework.dSYM"

# Validate that frameworks were created successfully
if [ ! -d "$SIMULATOR_FRAMEWORK" ]; then
	log_error "iOS Simulator framework not found: $SIMULATOR_FRAMEWORK"
	exit 1
fi

if [ ! -d "$DEVICE_FRAMEWORK" ]; then
	log_error "iOS Device framework not found: $DEVICE_FRAMEWORK"
	exit 1
fi

log_info "📦 Creating XCFramework..."

# Build xcframework command with conditional dSYM inclusion
XCFRAMEWORK_ARGS="-framework $SIMULATOR_FRAMEWORK"
if [ -d "$SIMULATOR_DSYM" ]; then
	log_info "Including iOS Simulator debug symbols"
	XCFRAMEWORK_ARGS="$XCFRAMEWORK_ARGS -debug-symbols ${PWD}/$SIMULATOR_DSYM"
else
	log_warning "iOS Simulator debug symbols not found, skipping"
fi

XCFRAMEWORK_ARGS="$XCFRAMEWORK_ARGS -framework $DEVICE_FRAMEWORK"
if [ -d "$DEVICE_DSYM" ]; then
	log_info "Including iOS Device debug symbols"
	XCFRAMEWORK_ARGS="$XCFRAMEWORK_ARGS -debug-symbols ${PWD}/$DEVICE_DSYM"
else
	log_warning "iOS Device debug symbols not found, skipping"
fi

XCFRAMEWORK_ARGS="$XCFRAMEWORK_ARGS -output $XCFRAMEWORK_PATH"

eval "xcodebuild -create-xcframework $XCFRAMEWORK_ARGS"

# Validate XCFramework was created successfully
if [ ! -d "$XCFRAMEWORK_PATH" ]; then
	log_error "XCFramework creation failed"
	exit 1
fi

# Create distribution zip
log_info "📦 Creating distribution package..."
LICENSE_BASENAME="$(basename "$LICENSE_FILE")"
cp "$LICENSE_FILE" "$BUILD_DIR"
cd "$BUILD_DIR"
zip -r "${PROJECT_NAME}.zip" "${PROJECT_NAME}.xcframework" "$LICENSE_BASENAME"
mv "${PROJECT_NAME}.zip" ..

log_success "🎉 XCFramework built successfully: ${PROJECT_NAME}.zip"
