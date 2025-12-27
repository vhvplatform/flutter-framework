@echo off
REM Flutter Framework Setup Script for Windows
REM This script automates the setup process for the Flutter SaaS Framework

setlocal enabledelayedexpansion

echo.
echo ===================================================
echo   Flutter Framework Setup
echo ===================================================
echo.

echo Starting automated setup process...
echo.

REM Step 1: Check prerequisites
echo ===================================================
echo   Step 1: Checking Prerequisites
echo ===================================================
echo.

set "ALL_GOOD=true"

REM Check Flutter
where flutter >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=2" %%i in ('flutter --version 2^>^&1 ^| findstr /B "Flutter"') do set FLUTTER_VERSION=%%i
    echo [OK] Flutter is installed (version: !FLUTTER_VERSION!)
) else (
    echo [ERROR] Flutter is not installed
    echo Please install Flutter from: https://flutter.dev/docs/get-started/install
    set "ALL_GOOD=false"
)

REM Check Dart
where dart >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=4" %%i in ('dart --version 2^>^&1') do set DART_VERSION=%%i
    echo [OK] Dart is installed (version: !DART_VERSION!)
) else (
    echo [ERROR] Dart is not installed
    echo Dart should come with Flutter. Please check your Flutter installation.
    set "ALL_GOOD=false"
)

REM Check Git
where git >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=3" %%i in ('git --version') do set GIT_VERSION=%%i
    echo [OK] Git is installed (version: !GIT_VERSION!)
) else (
    echo [ERROR] Git is not installed
    echo Please install Git from: https://git-scm.com/downloads
    set "ALL_GOOD=false"
)

REM Check Melos
where melos >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Melos is installed
) else (
    echo [WARNING] Melos is not installed
    echo Attempting to install Melos...
    dart pub global activate melos
    if !errorlevel! equ 0 (
        echo [OK] Melos installed successfully
        echo Make sure the pub-cache\bin directory is in your PATH
        echo Location: %LOCALAPPDATA%\Pub\Cache\bin
    ) else (
        echo [ERROR] Failed to install Melos
        set "ALL_GOOD=false"
    )
)

echo.

if "!ALL_GOOD!" == "false" (
    echo [ERROR] Some prerequisites are missing. Please install them and run this script again.
    pause
    exit /b 1
)

echo [OK] All prerequisites are satisfied!
echo.

REM Step 2: Run Flutter doctor
echo ===================================================
echo   Step 2: Running Flutter Doctor
echo ===================================================
echo This will check for any Flutter setup issues...
echo.

flutter doctor

echo.
echo If you see any issues above, please resolve them before continuing.
pause

REM Step 3: Bootstrap the project
echo.
echo ===================================================
echo   Step 3: Bootstrapping Project
echo ===================================================
echo Installing dependencies for all packages...
echo.

call melos bootstrap
if %errorlevel% neq 0 (
    echo [ERROR] Failed to bootstrap project
    pause
    exit /b 1
)

echo [OK] Dependencies installed successfully
echo.

REM Step 4: Generate code (if needed)
echo ===================================================
echo   Step 4: Code Generation (Optional)
echo ===================================================
echo Checking if code generation is needed...
echo.

findstr /s /i "build_runner" packages\*\pubspec.yaml apps\*\pubspec.yaml >nul 2>&1
if %errorlevel% equ 0 (
    echo Running code generation...
    call melos generate 2>nul
    if !errorlevel! equ 0 (
        echo [OK] Code generation completed
    ) else (
        echo [WARNING] Code generation skipped (no packages require it or command not available)
    )
) else (
    echo No code generation needed
)

echo.

REM Step 5: Run analysis
echo ===================================================
echo   Step 5: Running Analysis
echo ===================================================
echo Checking for any code issues...
echo.

call melos analyze
if %errorlevel% equ 0 (
    echo [OK] Analysis completed with no issues
) else (
    echo [WARNING] Analysis found some issues (see above)
    echo These issues don't prevent you from running the app
)

echo.

REM Step 6: Setup complete
echo ===================================================
echo   Setup Complete!
echo ===================================================
echo.

echo [OK] The Flutter Framework is now ready to use!
echo.
echo Next steps:
echo.
echo   1. Navigate to an example app:
echo      cd apps\app1
echo.
echo   2. Run the app:
echo      flutter run
echo.
echo      Or select a specific device:
echo      flutter run -d chrome    # For web
echo      flutter run -d windows   # For Windows
echo.
echo Useful commands:
echo   * melos bootstrap  - Reinstall dependencies
echo   * melos analyze    - Run code analysis
echo   * melos test       - Run all tests
echo   * melos clean      - Clean all packages
echo.
echo For more information, see SETUP.md and Readme.md
echo.

pause
