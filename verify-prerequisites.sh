#!/bin/bash

# Prerequisites Verification Script
# This script checks if all required tools are installed and properly configured

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_header() {
    echo ""
    echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
    echo ""
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

check_version() {
    local required_version=$1
    local actual_version=$2
    
    # Simple version comparison (assumes format X.Y.Z)
    if [[ "$actual_version" == "$required_version" ]] || [[ "$actual_version" > "$required_version" ]]; then
        return 0
    else
        return 1
    fi
}

main() {
    print_header "Prerequisites Check"
    
    local all_satisfied=true
    local warnings=0
    
    # Check Flutter
    print_info "Checking Flutter..."
    if command_exists flutter; then
        FLUTTER_VERSION=$(flutter --version 2>&1 | head -n 1 | cut -d ' ' -f 2)
        print_success "Flutter installed: version $FLUTTER_VERSION"
        
        # Check minimum version (3.0.0)
        if check_version "3.0.0" "$FLUTTER_VERSION" || [[ "$FLUTTER_VERSION" =~ ^3\. ]]; then
            print_success "Flutter version meets minimum requirement (≥3.0.0)"
        else
            print_warning "Flutter version is below 3.0.0. Please upgrade."
            warnings=$((warnings + 1))
        fi
    else
        print_error "Flutter is NOT installed"
        print_info "Install from: https://flutter.dev/docs/get-started/install"
        all_satisfied=false
    fi
    
    echo ""
    
    # Check Dart
    print_info "Checking Dart..."
    if command_exists dart; then
        DART_VERSION=$(dart --version 2>&1 | grep -oP 'Dart SDK version: \K[0-9.]+' || echo "unknown")
        print_success "Dart installed: version $DART_VERSION"
        
        # Check minimum version (3.0.0)
        if [[ "$DART_VERSION" =~ ^3\. ]] || [[ "$DART_VERSION" > "3.0.0" ]]; then
            print_success "Dart version meets minimum requirement (≥3.0.0)"
        else
            print_warning "Dart version is below 3.0.0. Please upgrade Flutter."
            warnings=$((warnings + 1))
        fi
    else
        print_error "Dart is NOT installed"
        print_info "Dart comes with Flutter. Please check your Flutter installation."
        all_satisfied=false
    fi
    
    echo ""
    
    # Check Git
    print_info "Checking Git..."
    if command_exists git; then
        GIT_VERSION=$(git --version | cut -d ' ' -f 3)
        print_success "Git installed: version $GIT_VERSION"
    else
        print_error "Git is NOT installed"
        print_info "Install from: https://git-scm.com/downloads"
        all_satisfied=false
    fi
    
    echo ""
    
    # Check Melos
    print_info "Checking Melos..."
    if command_exists melos; then
        MELOS_VERSION=$(melos --version 2>&1 | grep -oP '[0-9]+\.[0-9]+\.[0-9]+' | head -n 1 || echo "unknown")
        print_success "Melos installed: version $MELOS_VERSION"
    else
        print_error "Melos is NOT installed"
        print_info "Install with: dart pub global activate melos"
        print_info "Then add to PATH: export PATH=\"\$PATH:\$HOME/.pub-cache/bin\""
        all_satisfied=false
    fi
    
    echo ""
    
    # Check if pub-cache/bin is in PATH
    if [[ ":$PATH:" == *":$HOME/.pub-cache/bin:"* ]]; then
        print_success "Pub cache bin directory is in PATH"
    else
        print_warning "Pub cache bin directory is NOT in PATH"
        print_info "Add to your shell profile (~/.bashrc, ~/.zshrc, etc.):"
        print_info "  export PATH=\"\$PATH:\$HOME/.pub-cache/bin\""
        warnings=$((warnings + 1))
    fi
    
    echo ""
    print_header "Summary"
    
    if [ "$all_satisfied" = true ] && [ "$warnings" -eq 0 ]; then
        print_success "All prerequisites are satisfied!"
        echo ""
        print_info "You're ready to run: ${GREEN}./setup.sh${NC} or ${GREEN}make setup${NC}"
        return 0
    elif [ "$all_satisfied" = true ]; then
        print_warning "All required tools are installed, but there are $warnings warnings"
        echo ""
        print_info "You can proceed, but consider addressing the warnings above"
        return 0
    else
        print_error "Some prerequisites are missing"
        echo ""
        print_info "Please install the missing tools and run this script again"
        return 1
    fi
}

# Run main function
main
exit $?
