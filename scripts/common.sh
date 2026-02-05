#!/bin/bash

# Common utilities for project scripts
# This file contains shared functions used across multiple scripts

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;36m'
NC='\033[0m' # No Color

# Logging functions with consistent formatting
log_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
log_success() { echo -e "${GREEN}✅ $1${NC}"; }
log_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
log_error() { echo -e "${RED}❌ $1${NC}"; }

# Utility functions
check_command() {
    if ! command -v "$1" &> /dev/null; then
        log_error "$1 is required but not installed"
        return 1
    fi
    return 0
}

check_file() {
    if [[ ! -f "$1" ]]; then
        log_error "File not found: $1"
        return 1
    fi
    return 0
}

check_directory() {
    if [[ ! -d "$1" ]]; then
        log_error "Directory not found: $1"
        return 1
    fi
    return 0
}
