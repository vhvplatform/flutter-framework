# Flutter Framework Setup Script for Windows (PowerShell)
# This script automates the setup process for the Flutter SaaS Framework

# Enable strict mode
$ErrorActionPreference = "Stop"
$ProgressPreference = 'SilentlyContinue'  # Speed up downloads

# Colors for output
function Write-Info($message) {
    Write-Host "ℹ " -ForegroundColor Blue -NoNewline
    Write-Host $message
}

function Write-Success($message) {
    Write-Host "✓ " -ForegroundColor Green -NoNewline
    Write-Host $message
}

function Write-Warning($message) {
    Write-Host "⚠ " -ForegroundColor Yellow -NoNewline
    Write-Host $message
}

function Write-Error($message) {
    Write-Host "✗ " -ForegroundColor Red -NoNewline
    Write-Host $message
}

function Write-Header($message) {
    Write-Host ""
    Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Blue
    Write-Host "  $message" -ForegroundColor Blue
    Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Blue
    Write-Host ""
}

# Check if a command exists
function Test-CommandExists($command) {
    $null = Get-Command $command -ErrorAction SilentlyContinue
    return $?
}

# Main setup function
function Main {
    Write-Header "Flutter Framework Setup"
    
    Write-Info "Starting automated setup process..."
    Write-Host ""
    
    # Step 1: Check prerequisites
    Write-Header "Step 1: Checking Prerequisites"
    
    $allGood = $true
    
    # Check Flutter
    if (Test-CommandExists "flutter") {
        try {
            $flutterOutput = flutter --version 2>&1 | Select-Object -First 1
            $flutterVersion = if ($flutterOutput -match "Flutter (\S+)") { $matches[1] } else { "unknown" }
            Write-Success "Flutter is installed (version: $flutterVersion)"
        } catch {
            Write-Warning "Flutter is installed but version check failed"
        }
    } else {
        Write-Error "Flutter is not installed"
        Write-Info "Please install Flutter from: https://flutter.dev/docs/get-started/install"
        $allGood = $false
    }
    
    # Check Dart
    if (Test-CommandExists "dart") {
        try {
            $dartOutput = dart --version 2>&1
            $dartVersion = if ($dartOutput -match "(\d+\.\d+\.\d+)") { $matches[1] } else { "unknown" }
            Write-Success "Dart is installed (version: $dartVersion)"
        } catch {
            Write-Warning "Dart is installed but version check failed"
        }
    } else {
        Write-Error "Dart is not installed"
        Write-Info "Dart should come with Flutter. Please check your Flutter installation."
        $allGood = $false
    }
    
    # Check Git
    if (Test-CommandExists "git") {
        try {
            $gitOutput = git --version
            $gitVersion = if ($gitOutput -match "(\d+\.\d+\.\d+)") { $matches[1] } else { "unknown" }
            Write-Success "Git is installed (version: $gitVersion)"
        } catch {
            Write-Warning "Git is installed but version check failed"
        }
    } else {
        Write-Error "Git is not installed"
        Write-Info "Please install Git from: https://git-scm.com/downloads"
        $allGood = $false
    }
    
    # Check Melos
    if (Test-CommandExists "melos") {
        Write-Success "Melos is installed"
    } else {
        Write-Warning "Melos is not installed"
        Write-Info "Attempting to install Melos..."
        
        try {
            dart pub global activate melos
            Write-Success "Melos installed successfully"
            
            # Check if pub-cache/bin is in PATH
            # Try to get actual pub cache directory
            $pubCacheBin = "$env:USERPROFILE\.pub-cache\bin"
            if (Test-Path "$env:APPDATA\Pub\Cache\bin") {
                $pubCacheBin = "$env:APPDATA\Pub\Cache\bin"
            }
            
            if ($env:PATH -notlike "*$pubCacheBin*") {
                Write-Warning "Melos installed but not in PATH"
                Write-Info "Add the following to your PATH:"
                Write-Info "  $pubCacheBin"
                Write-Info ""
                Write-Info "For this session, temporarily adding to PATH..."
                $env:PATH = "$env:PATH;$pubCacheBin"
                Write-Success "Temporarily added to PATH for this session"
            }
        } catch {
            Write-Error "Failed to install Melos"
            $allGood = $false
        }
    }
    
    if (-not $allGood) {
        Write-Host ""
        Write-Error "Some prerequisites are missing. Please install them and run this script again."
        exit 1
    }
    
    Write-Host ""
    Write-Success "All prerequisites are satisfied!"
    
    # Step 2: Run Flutter doctor
    Write-Header "Step 2: Running Flutter Doctor"
    Write-Info "This will check for any Flutter setup issues..."
    Write-Host ""
    
    flutter doctor
    
    Write-Host ""
    Write-Info "If you see any issues above, please resolve them before continuing."
    Read-Host "Press Enter to continue or Ctrl+C to exit"
    
    # Step 3: Bootstrap the project
    Write-Header "Step 3: Bootstrapping Project"
    Write-Info "Installing dependencies for all packages..."
    Write-Host ""
    
    try {
        melos bootstrap
        Write-Success "Dependencies installed successfully"
    } catch {
        Write-Error "Failed to bootstrap project"
        exit 1
    }
    
    # Step 4: Generate code (if needed)
    Write-Header "Step 4: Code Generation (Optional)"
    Write-Info "Checking if code generation is needed..."
    
    $hasBuildRunner = $false
    if ((Test-Path "packages") -or (Test-Path "apps")) {
        try {
            $hasBuildRunner = Get-ChildItem -Path "packages","apps" -Recurse -Filter "pubspec.yaml" -ErrorAction SilentlyContinue | 
                              ForEach-Object { Select-String -Path $_.FullName -Pattern "build_runner" -Quiet } | 
                              Where-Object { $_ -eq $true } | 
                              Select-Object -First 1
        } catch {
            # Silently continue if paths don't exist
        }
    }
    
    if ($hasBuildRunner) {
        Write-Info "Running code generation..."
        try {
            melos generate 2>$null
            Write-Success "Code generation completed"
        } catch {
            Write-Warning "Code generation skipped (no packages require it or command not available)"
        }
    } else {
        Write-Info "No code generation needed"
    }
    
    # Step 5: Run analysis
    Write-Header "Step 5: Running Analysis"
    Write-Info "Checking for any code issues..."
    Write-Host ""
    
    try {
        melos analyze
        Write-Success "Analysis completed with no issues"
    } catch {
        Write-Warning "Analysis found some issues (see above)"
        Write-Info "These issues don't prevent you from running the app"
    }
    
    # Step 6: Setup complete
    Write-Header "Setup Complete!"
    
    Write-Host ""
    Write-Success "The Flutter Framework is now ready to use!"
    Write-Host ""
    Write-Info "Next steps:"
    Write-Host ""
    Write-Host "  1. Navigate to an example app:"
    Write-Host "     cd apps\app1" -ForegroundColor Green
    Write-Host ""
    Write-Host "  2. Run the app:"
    Write-Host "     flutter run" -ForegroundColor Green
    Write-Host ""
    Write-Host "     Or select a specific device:"
    Write-Host "     flutter run -d chrome    # For web" -ForegroundColor Green
    Write-Host "     flutter run -d windows   # For Windows" -ForegroundColor Green
    Write-Host ""
    Write-Info "Useful commands:"
    Write-Host "  • melos bootstrap" -ForegroundColor Green -NoNewline
    Write-Host "  - Reinstall dependencies"
    Write-Host "  • melos analyze" -ForegroundColor Green -NoNewline
    Write-Host "    - Run code analysis"
    Write-Host "  • melos test" -ForegroundColor Green -NoNewline
    Write-Host "       - Run all tests"
    Write-Host "  • melos clean" -ForegroundColor Green -NoNewline
    Write-Host "      - Clean all packages"
    Write-Host ""
    Write-Info "For more information, see SETUP.md and Readme.md"
    Write-Host ""
}

# Run main function
try {
    Main
} catch {
    Write-Host ""
    Write-Error "An error occurred during setup:"
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}
