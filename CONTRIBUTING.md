# Contributing to Flutter SaaS Framework

Thank you for your interest in contributing to the Flutter SaaS Framework! This document provides guidelines and instructions for contributing.

## Getting Started

### Prerequisites

Before you begin, ensure you have:
- **Flutter SDK** 3.0.0 or higher
- **Dart SDK** 3.0.0 or higher
- **Git** for version control
- **Melos** for monorepo management (auto-installed by setup script)

### Setup Development Environment

1. **Fork the repository** on GitHub

2. **Clone your fork**:
   ```bash
   git clone https://github.com/YOUR_USERNAME/flutter-framework.git
   cd flutter-framework
   ```

3. **Add upstream remote**:
   ```bash
   git remote add upstream https://github.com/vhvplatform/flutter-framework.git
   ```

4. **Run automated setup**:
   
   **Linux/macOS:**
   ```bash
   ./setup.sh
   ```
   
   **Windows (PowerShell):**
   ```powershell
   .\setup.ps1
   ```
   
   **Windows (Command Prompt):**
   ```cmd
   setup.bat
   ```

5. **Verify the setup**:
   ```bash
   make analyze
   make test
   ```

## Development Workflow

### Creating a Feature Branch

```bash
# Update your fork
git fetch upstream
git checkout main
git merge upstream/main

# Create a new branch
git checkout -b feature/your-feature-name
```

### Making Changes

1. Make your changes in your feature branch
2. Follow the coding standards (see below)
3. Write or update tests as needed
4. Run linters and tests locally:
   ```bash
   make format     # Format code
   make analyze    # Run analysis
   make test       # Run tests
   ```

### Committing Changes

1. **Write clear commit messages**:
   ```
   Add user profile feature
   
   - Implement user profile screen
   - Add profile edit functionality
   - Update user service with profile endpoints
   - Add tests for profile features
   ```

2. **Keep commits focused**: Each commit should represent a single logical change

3. **Commit your changes**:
   ```bash
   git add .
   git commit -m "Your descriptive commit message"
   ```

### Submitting a Pull Request

1. **Push your branch**:
   ```bash
   git push origin feature/your-feature-name
   ```

2. **Open a Pull Request** on GitHub:
   - Provide a clear title and description
   - Reference any related issues
   - Ensure CI checks pass
   - Request review from maintainers

3. **Address review feedback**:
   - Make requested changes
   - Push updates to your branch
   - The PR will automatically update

## Coding Standards

### Dart/Flutter Code Style

- Follow the [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use `dart format` to format your code (or `make format`)
- Follow Flutter best practices
- Use meaningful variable and function names
- Keep functions small and focused
- Add comments for complex logic

### Project-Specific Guidelines

1. **Use const constructors** wherever possible for better performance
2. **Dispose resources**: Always dispose controllers, streams, and listeners
3. **Handle errors**: Implement proper error handling and user feedback
4. **Type safety**: Leverage Dart's type system and null safety
5. **Modular design**: Keep features in separate modules
6. **Dependency Injection**: Use the service locator pattern (GetIt)
7. **Documentation**: Add dartdoc comments for public APIs

### File Organization

```
packages/
  modules/
    my_module/
      lib/
        my_module.dart          # Module entry point
        screens/                # UI screens
        services/               # Business logic
        repositories/           # Data access
        models/                 # Data models
        widgets/                # Reusable widgets
      test/                     # Tests
      pubspec.yaml
```

## Testing

### Running Tests

```bash
# Run all tests
make test

# Run tests for specific package
cd packages/core
flutter test

# Run tests with coverage
flutter test --coverage
```

### Writing Tests

- Write unit tests for business logic
- Write widget tests for UI components
- Follow the existing test structure
- Aim for good test coverage
- Test edge cases and error scenarios

Example:
```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MyService', () {
    test('should return user when login is successful', () async {
      // Arrange
      final service = MyService();
      
      // Act
      final result = await service.login('email', 'password');
      
      // Assert
      expect(result, isNotNull);
    });
  });
}
```

## Documentation

- Update documentation for any user-facing changes
- Add dartdoc comments for public APIs
- Update README.md if adding new features
- Update SETUP.md if changing setup process
- Keep QUICKSTART.md beginner-friendly

## Common Commands

```bash
make help          # Show all available commands
make setup         # Run automated setup
make bootstrap     # Install dependencies
make analyze       # Run code analysis
make format        # Format code
make test          # Run tests
make clean         # Clean build artifacts
make build         # Build all apps
make run-app1      # Run example app 1
make run-app2      # Run example app 2
```

## Reporting Issues

### Before Creating an Issue

1. Search existing issues to avoid duplicates
2. Run `./verify-prerequisites.sh` to check your setup
3. Try the latest version from `main` branch
4. Check the documentation

### Creating an Issue

Include:
- **Clear title** describing the problem
- **Description** with steps to reproduce
- **Expected behavior** vs actual behavior
- **Environment details** (OS, Flutter version, etc.)
- **Screenshots** if applicable
- **Error messages** or stack traces

## Code Review Process

1. All submissions require review
2. Maintainers will review your PR
3. Address feedback promptly
4. Once approved, maintainers will merge

## Questions?

- Check [SETUP.md](SETUP.md) for setup issues
- Check [DEV_GUIDE.md](DEV_GUIDE.md) for development tips
- Check [QUICKSTART.md](QUICKSTART.md) for quick reference
- Open an issue for questions or discussions

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

## Thank You!

Your contributions help make this framework better for everyone! 🎉
