@echo off
setlocal

:: =============================================================================
::            TEMPORARY Uninstall Script for Windows (No Confirmation)
:: =============================================================================

:: --- Configuration Variables ---
set "WSL_DISTRO_NAME=Ubuntu"
set "LINUX_RESET_SCRIPT_NAME=reset-linux-dev.sh"

:: 1. Administrator Privileges Check
:: -----------------------------------------------------------------------------
echo Checking for Administrator privileges...
net session >nul 2>&1
if %errorLevel% == 0 (
    echo   -> Success: Administrator permissions confirmed.
) else (
    echo   -> ERROR: This script requires Administrator permissions.
    pause
    exit /b 1
)

:: 2. Reset Linux Environment
:: -----------------------------------------------------------------------------
echo.
echo [Phase 1/3] Resetting the Linux environment inside WSL...
set "SCRIPT_DIR_WIN=%~dp0"
set "SCRIPT_PATH_WIN=%SCRIPT_DIR_WIN%%LINUX_RESET_SCRIPT_NAME%"

if not exist "%SCRIPT_PATH_WIN%" (
    echo   -> WARNING: Linux reset script '%LINUX_RESET_SCRIPT_NAME%' not found. Skipping.
) else (
    wsl -d %WSL_DISTRO_NAME% -e exit >nul 2>&1
    if %errorLevel% == 0 (
        wsl -d %WSL_DISTRO_NAME% -- bash "/mnt/e/Develop/develop-server/reset-linux-dev.sh"
        echo   -> Linux environment has been reset.
    ) else (
        echo   -> '%WSL_DISTRO_NAME%' not found, skipping Linux reset.
    )
)

:: 3. Uninstall WSL Distribution
:: -----------------------------------------------------------------------------
echo.
echo [Phase 2/3] Uninstalling the '%WSL_DISTRO_NAME%' WSL distribution...
wsl --unregister %WSL_DISTRO_NAME%
if %errorLevel% == 0 (
    echo   -> '%WSL_DISTRO_NAME%' has been successfully unregistered.
) else (
    echo   -> WARNING: Failed to unregister '%WSL_DISTRO_NAME%'. It might not exist.
)

:: 4. Uninstall Docker Desktop
:: -----------------------------------------------------------------------------
echo.
echo [Phase 3/3] Uninstalling Docker Desktop...
if exist "%ProgramFiles%\Docker\Docker\Docker Desktop Installer.exe" (
    echo   -> Starting Docker Desktop uninstallation...
    "%ProgramFiles%\Docker\Docker\Docker Desktop Installer.exe" uninstall
    echo   -> Docker Desktop uninstallation process started.
) else (
    echo   -> Docker Desktop installation not found, skipping.
)

:: 5. Final Instructions
:: -----------------------------------------------------------------------------
echo.
echo --- Uninstallation Complete ---
pause
exit /b 0
