#!/bin/bash

# Check if a section header is provided
if [ -z "$1" ]; then
  echo "No section header provided. Usage: ./extract_release_notes.sh section_header"
  exit 1
fi

SECTION_HEADER=$1

# Escape the section header for use in awk
ESCAPED_HEADER=$(echo "$SECTION_HEADER" | sed 's/[]\/$*.^|[]/\\&/g')

# Extract the specified section from CHANGELOG.md, remove the empty line after the header, and convert ### to #
awk -v header="$ESCAPED_HEADER" '
  $0 ~ "## " header {flag=1; next}
  flag && /^$/ {next}
  /^## / && !($0 ~ "## " header) {flag=0}
  flag {gsub(/^### /, "# "); print}
' CHANGELOG.md
