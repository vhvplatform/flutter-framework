# Quick Start Guide

Get the Flutter SaaS Framework up and running in minutes!

## Prerequisites

You need:
- **Flutter** (version 3.0.0 or higher)
- **Git**

That's it! Other tools will be installed automatically.

### Check if Flutter is installed

```bash
flutter --version
```

If this command works, you're good to go! If not, install Flutter from [flutter.dev](https://flutter.dev/docs/get-started/install).

## Installation

### Step 1: Clone the Repository

```bash
git clone https://github.com/vhvplatform/flutter-framework.git
cd flutter-framework
```

### Step 2: Run Automated Setup

**Option A: Using the setup script (recommended)**

```bash
./setup.sh
```

**Option B: Using Makefile**

```bash
make setup
```

The setup process will:
1. Check that Flutter, Dart, and Git are installed
2. Install Melos (if needed)
3. Install all dependencies
4. Run code generation
5. Verify everything works

This takes about 2-5 minutes depending on your internet speed.

### Step 3: Run an Example App

```bash
cd apps/app1
flutter run
```

Or use the shortcut:

```bash
make run-app1
```

Select your target device when prompted (web, mobile, desktop).

## What's Next?

### Explore the Example Apps

- **app1**: Located in `apps/app1` - Full featured example
- **app2**: Located in `apps/app2` - Alternative configuration

### Learn the Commands

```bash
make help          # Show all available commands
make analyze       # Check code quality
make test          # Run tests
make format        # Format code
make clean         # Clean build files
```

### Read the Documentation

- **[SETUP.md](SETUP.md)** - Detailed setup instructions
- **[Readme.md](Readme.md)** - Complete framework overview
- **[DEV_GUIDE.md](DEV_GUIDE.md)** - Development best practices
- **[UI_KIT_GUIDE.md](UI_KIT_GUIDE.md)** - UI components guide

### Create Your First Module

```bash
cd packages/modules
mkdir my_module
cd my_module
# Create pubspec.yaml and lib/my_module.dart
# See SETUP.md for detailed instructions
```

## Troubleshooting

### "flutter: command not found"

Install Flutter from [flutter.dev](https://flutter.dev/docs/get-started/install) and add it to your PATH.

### "melos: command not found" (after setup)

The setup script should install Melos automatically. If it still doesn't work:

```bash
dart pub global activate melos
export PATH="$PATH:$HOME/.pub-cache/bin"
```

Add the export line to your `~/.bashrc` or `~/.zshrc` to make it permanent.

### Setup script fails

Try manual setup:

```bash
# Install Melos
dart pub global activate melos

# Bootstrap
melos bootstrap

# Run app
cd apps/app1
flutter run
```

### Build errors

```bash
# Clean and rebuild
make clean
make bootstrap
cd apps/app1
flutter run
```

### Need more help?

- Check [SETUP.md](SETUP.md) for detailed troubleshooting
- Run `./verify-prerequisites.sh` to diagnose issues
- Open an issue on GitHub

## Common Tasks

### Run on specific device

```bash
flutter devices                  # List available devices
flutter run -d chrome            # Run on Chrome
flutter run -d macos             # Run on macOS
flutter run -d <device-id>       # Run on specific device
```

### Update dependencies

```bash
make bootstrap
# or
melos bootstrap
```

### Format code before committing

```bash
make format
# or
melos format
```

### Run tests

```bash
make test
# or
melos test
```

## Success! 🎉

You now have the Flutter SaaS Framework running. Start building your app by:

1. Exploring the example apps
2. Reading the documentation
3. Creating your own modules
4. Customizing the UI theme

Happy coding!
