#!/bin/bash

# Flutter Framework Setup Script
# This script automates the setup process for the Flutter SaaS Framework

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored output
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

# Check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Main setup function
main() {
    print_header "Flutter Framework Setup"
    
    print_info "Starting automated setup process..."
    echo ""
    
    # Step 1: Check prerequisites
    print_header "Step 1: Checking Prerequisites"
    
    local all_good=true
    
    # Check Flutter
    if command_exists flutter; then
        FLUTTER_VERSION=$(flutter --version 2>&1 | head -n 1 | cut -d ' ' -f 2)
        print_success "Flutter is installed (version: $FLUTTER_VERSION)"
    else
        print_error "Flutter is not installed"
        print_info "Please install Flutter from: https://flutter.dev/docs/get-started/install"
        all_good=false
    fi
    
    # Check Dart
    if command_exists dart; then
        DART_VERSION=$(dart --version 2>&1 | sed -n 's/.*Dart SDK version: \([0-9.]*\).*/\1/p' || echo "unknown")
        print_success "Dart is installed (version: $DART_VERSION)"
    else
        print_error "Dart is not installed"
        print_info "Dart should come with Flutter. Please check your Flutter installation."
        all_good=false
    fi
    
    # Check Git
    if command_exists git; then
        GIT_VERSION=$(git --version | cut -d ' ' -f 3)
        print_success "Git is installed (version: $GIT_VERSION)"
    else
        print_error "Git is not installed"
        print_info "Please install Git from: https://git-scm.com/downloads"
        all_good=false
    fi
    
    # Check Melos
    if command_exists melos; then
        MELOS_VERSION=$(melos --version 2>&1 | sed -n 's/.*\([0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\).*/\1/p' | head -n 1 || echo "unknown")
        print_success "Melos is installed (version: $MELOS_VERSION)"
    else
        print_warning "Melos is not installed"
        print_info "Attempting to install Melos..."
        
        if dart pub global activate melos; then
            print_success "Melos installed successfully"
            
            # Check if pub-cache/bin is in PATH
            if ! command_exists melos; then
                print_warning "Melos installed but not in PATH"
                print_info "Add the following to your PATH:"
                print_info "  export PATH=\"\$PATH:\$HOME/.pub-cache/bin\""
                print_info ""
                print_info "For this session, run:"
                export PATH="$PATH:$HOME/.pub-cache/bin"
                print_success "Temporarily added to PATH for this session"
            fi
        else
            print_error "Failed to install Melos"
            all_good=false
        fi
    fi
    
    if [ "$all_good" = false ]; then
        echo ""
        print_error "Some prerequisites are missing. Please install them and run this script again."
        exit 1
    fi
    
    echo ""
    print_success "All prerequisites are satisfied!"
    
    # Step 2: Run Flutter doctor
    print_header "Step 2: Running Flutter Doctor"
    print_info "This will check for any Flutter setup issues..."
    echo ""
    
    flutter doctor
    
    echo ""
    print_info "If you see any issues above, please resolve them before continuing."
    read -p "Press Enter to continue or Ctrl+C to exit..."
    
    # Step 3: Bootstrap the project
    print_header "Step 3: Bootstrapping Project"
    print_info "Installing dependencies for all packages..."
    echo ""
    
    if melos bootstrap; then
        print_success "Dependencies installed successfully"
    else
        print_error "Failed to bootstrap project"
        exit 1
    fi
    
    # Step 4: Generate code (if needed)
    print_header "Step 4: Code Generation (Optional)"
    print_info "Checking if code generation is needed..."
    
    # Check if any package has build_runner
    has_build_runner=false
    if [ -d "packages" ] || [ -d "apps" ]; then
        if find packages apps -name "pubspec.yaml" -type f 2>/dev/null | xargs grep -l "build_runner" > /dev/null 2>&1; then
            has_build_runner=true
        fi
    fi
    
    if [ "$has_build_runner" = true ]; then
        print_info "Running code generation..."
        if melos generate 2>/dev/null; then
            print_success "Code generation completed"
        else
            print_warning "Code generation skipped (no packages require it or command not available)"
        fi
    else
        print_info "No code generation needed"
    fi
    
    # Step 5: Run analysis
    print_header "Step 5: Running Analysis"
    print_info "Checking for any code issues..."
    echo ""
    
    if melos analyze; then
        print_success "Analysis completed with no issues"
    else
        print_warning "Analysis found some issues (see above)"
        print_info "These issues don't prevent you from running the app"
    fi
    
    # Step 6: Setup complete
    print_header "Setup Complete!"
    
    echo ""
    print_success "The Flutter Framework is now ready to use!"
    echo ""
    print_info "Next steps:"
    echo ""
    echo "  1. Navigate to an example app:"
    echo "     ${GREEN}cd apps/app1${NC}"
    echo ""
    echo "  2. Run the app:"
    echo "     ${GREEN}flutter run${NC}"
    echo ""
    echo "     Or select a specific device:"
    echo "     ${GREEN}flutter run -d chrome${NC}    # For web"
    echo "     ${GREEN}flutter run -d macos${NC}     # For macOS"
    echo ""
    print_info "Useful commands:"
    echo "  • ${GREEN}melos bootstrap${NC}  - Reinstall dependencies"
    echo "  • ${GREEN}melos analyze${NC}    - Run code analysis"
    echo "  • ${GREEN}melos test${NC}       - Run all tests"
    echo "  • ${GREEN}melos clean${NC}      - Clean all packages"
    echo "  • ${GREEN}make help${NC}        - Show all available commands (if Makefile is present)"
    echo ""
    print_info "For more information, see SETUP.md and Readme.md"
    echo ""
}

# Run main function
main
