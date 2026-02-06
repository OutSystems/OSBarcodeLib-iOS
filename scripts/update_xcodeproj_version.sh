#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

VERSION="${1:-}"
PBXPROJ="${2:-}"

if [ -z "$VERSION" ] || [ -z "$PBXPROJ" ]; then
  log_error "Usage: update_xcodeproj_version.sh <version> <pbxproj_path>"
  exit 1
fi

if [ ! -f "$PBXPROJ" ]; then
  log_error "project.pbxproj not found at $PBXPROJ"
  exit 1
fi
          
log_info "Updating MARKETING_VERSION in $PBXPROJ..."
sed -i '' -E "s/MARKETING_VERSION = [0-9]+\.[0-9]+(\.[0-9]+)?;/MARKETING_VERSION = $VERSION;/g" "$PBXPROJ"
log_info "Updating CURRENT_PROJECT_VERSION..."
current_proj_version=$(grep -m1 'CURRENT_PROJECT_VERSION =' "$PBXPROJ" | sed -E 's/.*CURRENT_PROJECT_VERSION = ([0-9]+);/\1/')
new_proj_version=$((current_proj_version+1))
sed -i '' -E "s/CURRENT_PROJECT_VERSION = [0-9]+;/CURRENT_PROJECT_VERSION = $new_proj_version;/g" "$PBXPROJ"
log_success "Bumped MARKETING_VERSION to $VERSION, CURRENT_PROJECT_VERSION to $new_proj_version"
