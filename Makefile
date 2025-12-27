.PHONY: help setup bootstrap install clean build test analyze format get upgrade generate doctor run-app1 run-app2 outdated

# Default target - show help
help:
	@echo ""
	@echo "Flutter Framework - Available Commands"
	@echo "======================================="
	@echo ""
	@echo "Setup & Installation:"
	@echo "  make setup          - Run automated setup script (recommended for first time)"
	@echo "  make bootstrap      - Install dependencies for all packages"
	@echo "  make install        - Alias for bootstrap"
	@echo ""
	@echo "Development:"
	@echo "  make run-app1       - Run app1 (example application)"
	@echo "  make run-app2       - Run app2 (example application)"
	@echo "  make analyze        - Run code analysis on all packages"
	@echo "  make format         - Format all Dart files"
	@echo "  make test           - Run tests for all packages"
	@echo "  make generate       - Run code generation (json_serializable, etc.)"
	@echo ""
	@echo "Maintenance:"
	@echo "  make clean          - Clean all packages"
	@echo "  make get            - Run pub get for all packages"
	@echo "  make upgrade        - Upgrade dependencies for all packages"
	@echo "  make outdated       - Check for outdated dependencies"
	@echo ""
	@echo "Build:"
	@echo "  make build          - Build all apps"
	@echo ""
	@echo "Diagnostics:"
	@echo "  make doctor         - Run flutter doctor"
	@echo ""
	@echo "For more information, see SETUP.md and Readme.md"
	@echo ""

# Initial setup - run setup script
setup:
	@./setup.sh

# Bootstrap all packages (install dependencies and link local packages)
bootstrap:
	@echo "Installing dependencies for all packages..."
	@melos bootstrap

# Alias for bootstrap
install: bootstrap

# Clean all packages
clean:
	@echo "Cleaning all packages..."
	@melos clean

# Build all apps
build:
	@echo "Building all apps..."
	@melos build

# Run tests for all packages
test:
	@echo "Running tests for all packages..."
	@melos test

# Analyze all packages
analyze:
	@echo "Running analysis on all packages..."
	@melos analyze

# Format all Dart files
format:
	@echo "Formatting all Dart files..."
	@melos format

# Get dependencies for all packages
get:
	@echo "Running pub get for all packages..."
	@melos get

# Upgrade dependencies for all packages
upgrade:
	@echo "Upgrading dependencies for all packages..."
	@melos upgrade

# Generate code (json_serializable, build_runner, etc.)
generate:
	@echo "Running code generation..."
	@melos generate

# Run flutter doctor
doctor:
	@flutter doctor

# Run app1
run-app1:
	@echo "Running app1..."
	@cd apps/app1 && flutter run

# Run app2
run-app2:
	@echo "Running app2..."
	@cd apps/app2 && flutter run

# Check for outdated dependencies
outdated:
	@echo "Checking for outdated dependencies..."
	@melos outdated
