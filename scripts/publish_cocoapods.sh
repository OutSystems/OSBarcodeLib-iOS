#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
source "${SCRIPT_DIR}/common.sh"

VERSION="${1:-}"
PROJECT_NAME="${2:-}"
PODSPEC_PATH="${3:-${PROJECT_NAME}.podspec}"

if [ -z "$VERSION" ]; then
  log_error "No version specified. Usage: publish_cocoapods.sh <version> <project_name> [podspec_path]"
  exit 1
fi

if [ -z "$PROJECT_NAME" ]; then
  log_error "Usage: publish_cocoapods.sh <version> <project_name> [podspec_path]"
  exit 1
fi

trap 'log_error "Publish failed."' ERR

log_info "Preparing to publish version $VERSION to CocoaPods"

if [ -z "${COCOAPODS_TRUNK_TOKEN:-}" ]; then
  log_warning "COCOAPODS_TRUNK_TOKEN not set; skipping CocoaPods publish."
  exit 0
fi

log_info "Checking if version ${VERSION} already exists on CocoaPods for ${PROJECT_NAME}"
INFO="$(pod trunk info "${PROJECT_NAME}" 2>/dev/null || true)"
if echo "$INFO" | grep -E -q "\\b${VERSION}\\b"; then
  log_warning "Version ${VERSION} already exists on CocoaPods for ${PROJECT_NAME}; skipping publish."
  exit 0
fi

log_info "Running pod trunk push on ${PODSPEC_PATH}"
pod trunk push "${PODSPEC_PATH}" --allow-warnings --skip-tests

log_success "CocoaPods publish finished"
