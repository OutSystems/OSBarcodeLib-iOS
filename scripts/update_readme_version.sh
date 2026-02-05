#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

VERSION="${1:-}"
LIB_NAME="${2:-}"
README_FILE="${3:-README.md}"

if [ -z "$VERSION" ] || [ -z "$LIB_NAME" ]; then
  log_error "Usage: update_readme_version.sh <version> <lib_name> [readme_path]"
  exit 1
fi

if [ ! -f "$README_FILE" ]; then
  log_error "README file not found at $README_FILE"
  exit 1
fi

log_info "Updating CocoaPods version in $README_FILE..."

# Update the CocoaPods version line in README.md
# This will match lines like: pod 'LibName', '~> 1.0.1'
sed -i '' -E "s/(pod '$LIB_NAME', '~> )[0-9]+\.[0-9]+(\.[0-9]+)?'/\1$VERSION'/g" "$README_FILE"

log_success "Updated $LIB_NAME version to $VERSION in $README_FILE"
