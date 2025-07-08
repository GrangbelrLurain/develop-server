@echo off
setlocal

:: =============================================================================
::            Development Environment Setup Script for Windows
:: =============================================================================
:: This script performs the following actions:
:: 1. Checks for Administrator privileges.
:: 2. Installs and configures WSL2.
:: 3. Downloads and silently installs Docker Desktop.
:: 4. Executes the corresponding Linux setup script inside WSL2.
:: =============================================================================

:: --- Configuration Variables ---
set "WSL_DISTRO_NAME=Ubuntu"
set "NODE_VERSION=18.17.0"
set "DOCKER_DESKTOP_URL=https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe"
set "DOCKER_INSTALLER_NAME=DockerDesktopInstaller.exe"
set "LINUX_SCRIPT_NAME=setup-linux-dev.sh"


:: 1. Administrator Privileges Check
:: -----------------------------------------------------------------------------
echo Checking for Administrator privileges...
net session >nul 2>&1
if %errorLevel% == 0 (
    echo   -> Success: Administrator permissions confirmed.
) else (
    echo   -> ERROR: This script requires Administrator permissions.
    echo      Please right-click the script and select "Run as administrator".
    pause
    exit /b 1
)


:: 2. WSL2 Installation and Configuration
:: -----------------------------------------------------------------------------
echo.
echo [Phase 1/3] Setting up WSL2...

echo   -> Updating WSL2 to the latest version to avoid interactive prompts...
wsl --update
if %errorLevel% neq 0 (
    echo   -> WARNING: Failed to update WSL. This might be okay if it's already up-to-date.
)

echo   -> Enabling WSL2 required Windows features...
wsl --install --no-distribution
if %errorLevel% neq 0 (
    echo   -> ERROR: Failed to install WSL core components.
    pause
    exit /b 1
)

echo   -> Setting WSL version 2 as the default...
wsl --set-default-version 2
if %errorLevel% neq 0 (
    echo   -> ERROR: Failed to set default WSL version to 2.
    pause
    exit /b 1
)
echo   -> WSL2 setup complete. Please ensure your Linux distribution (%WSL_DISTRO_NAME%) is installed from the Microsoft Store.

:: 3. Verify and Install WSL Distro & Execute Linux Script
:: -----------------------------------------------------------------------------
echo.
echo [Phase 2/3] Verifying WSL distribution and running Linux setup...

echo   -> Checking if '%WSL_DISTRO_NAME%' is installed...
wsl -d %WSL_DISTRO_NAME% -e exit >nul 2>&1
if %errorLevel% == 0 (
    echo   -> '%WSL_DISTRO_NAME%' is already installed.
) else (
    echo   -> '%WSL_DISTRO_NAME%' not found. Attempting to install it now...
    wsl --install -d %WSL_DISTRO_NAME%
    if %errorLevel% neq 0 (
        echo   -> ERROR: Failed to install '%WSL_DISTRO_NAME%'.
        echo      Please try installing it manually from the Microsoft Store.
        pause
        exit /b 1
    )
    echo   -> '%WSL_DISTRO_NAME%' installed successfully.
)

echo.
echo   -> Preparing to run Linux setup script...
set "SCRIPT_DIR_WIN=%~dp0"
set "SCRIPT_PATH_WIN=%SCRIPT_DIR_WIN%%LINUX_SCRIPT_NAME%"

if not exist "%SCRIPT_PATH_WIN%" (
    echo   -> ERROR: Linux script '%LINUX_SCRIPT_NAME%' not found in the same directory.
    pause
    exit /b 1
)

echo   -> Converting Windows path to WSL path...
wsl -d %WSL_DISTRO_NAME% wslpath -a "%SCRIPT_PATH_WIN%" > wsl_path.tmp
set /p SCRIPT_PATH_WSL=<wsl_path.tmp
del wsl_path.tmp

echo   -> Executing '%SCRIPT_PATH_WSL%' inside '%WSL_DISTRO_NAME%'...
wsl -d %WSL_DISTRO_NAME% -- bash "%SCRIPT_PATH_WSL%" "%NODE_VERSION%"
if %errorLevel% neq 0 (
    echo   -> ERROR: The Linux setup script failed. Please check the output in the WSL terminal.
    pause
    exit /b 1
)


:: 4. Final Instructions
:: -----------------------------------------------------------------------------
echo.
echo [Phase 3/3] Windows setup complete!
echo.
echo --- Next Steps ---
echo 1. Open your WSL terminal (run 'wsl' in Command Prompt or Start Menu).
echo 2. Clone your project repository into your WSL home directory (e.g., /home/your_user/).
echo 3. Navigate to your project folder and start the development server with: docker-compose up -d
echo.
echo Setup finished.
pause
exit /b 0
