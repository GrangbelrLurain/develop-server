@echo off
setlocal

:: =============================================================================
::           Development Environment Uninstallation Script for Windows
:: =============================================================================
:: WARNING: This script will permanently delete the specified WSL distribution.
::          All data inside the WSL distribution will be PERMANENTLY LOST.
::          This action is irreversible.
::
:: NOTE: This script does NOT uninstall Docker Desktop. If you installed Docker
::       Engine directly in WSL2, Docker Desktop is not required.
::       If Docker Desktop was previously installed, you must uninstall it
::       separately via Windows' "Add or remove programs".
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
    echo     Please right-click the script and select "Run as administrator".
    pause
    exit /b 1
)

:: 2. User Confirmation
:: -----------------------------------------------------------------------------
echo.
echo WARNING: This script will completely uninstall the '%WSL_DISTRO_NAME%' WSL
echo distribution. All data inside the WSL distribution will be PERMANENTLY LOST.
echo This action is irreversible.
echo.
echo NOTE: This script does NOT uninstall Docker Desktop.
echo If you wish to uninstall Docker Desktop, please do so manually via Windows
echo "Add or remove programs".
echo.

set /p "CONFIRM=Are you sure you want to continue? (y/n): "
if /i not "%CONFIRM%"=="y" (
    echo Uninstall cancelled.
    pause
    exit /b 0
)

:: 3. Reset Linux Environment (if script exists and distro is running)
:: -----------------------------------------------------------------------------
echo.
echo [Phase 1/2] Attempting to reset the Linux environment inside WSL...
set "SCRIPT_DIR_WIN=%~dp0"
set "SCRIPT_PATH_WIN=%SCRIPT_DIR_WIN%scripts\%LINUX_RESET_SCRIPT_NAME%" REM Adjusted path

if not exist "%SCRIPT_PATH_WIN%" (
    echo   -> WARNING: Linux reset script '%LINUX_RESET_SCRIPT_NAME%' not found at "%SCRIPT_PATH_WIN%". Skipping reset.
) else (
    :: Check if the WSL distribution is registered before attempting to run the script
    wsl -l -q | findstr /I /C:"%WSL_DISTRO_NAME%" >nul 2>&1
    if %errorLevel% == 0 (
        echo   -> Running Linux reset script inside '%WSL_DISTRO_NAME%'...
        REM Use %~dp0scripts\ to get the current script's directory for wslpath conversion
        FOR /F "usebackq tokens=*" %%i IN (`wsl -d %WSL_DISTRO_NAME% wslpath -a "%SCRIPT_PATH_WIN%"`) DO SET "SCRIPT_PATH_WSL=%%i"
        
        if not "%SCRIPT_PATH_WSL%"=="" (
            wsl -d %WSL_DISTRO_NAME% -- bash "%SCRIPT_PATH_WSL%"
            if %errorLevel% equ 0 (
                echo   -> Linux environment has been reset.
            ) else (
                echo   -> ERROR: Linux reset script failed. Proceeding with unregistration.
            )
        ) else (
            echo   -> ERROR: Could not determine WSL path for reset script. Skipping reset.
        )
    ) else (
        echo   -> '%WSL_DISTRO_NAME%' distribution not found or not running. Skipping Linux reset.
    )
)

:: 4. Uninstall WSL Distribution
:: -----------------------------------------------------------------------------
echo.
echo [Phase 2/2] Uninstalling the '%WSL_DISTRO_NAME%' WSL distribution...
wsl --unregister %WSL_DISTRO_NAME%
if %errorLevel% == 0 (
    echo   -> '%WSL_DISTRO_NAME%' has been successfully unregistered.
) else (
    echo   -> WARNING: Failed to unregister '%WSL_DISTRO_NAME%'. It might not exist or be in use.
    echo     Please ensure all WSL windows are closed and try again if necessary.
)

:: 5. Final Instructions
:: -----------------------------------------------------------------------------
echo.
echo --- Uninstallation Complete ---
echo - The '%WSL_DISTRO_NAME%' distribution has been removed from your system.
echo - All data inside the WSL distribution has been PERMANENTLY LOST.
echo.
echo NOTE: This script did NOT uninstall Docker Desktop.
echo If Docker Desktop was installed and you wish to remove it, please use Windows'
echo "Add or remove programs" utility.
echo.
echo You may need to restart your computer to fully clear any lingering processes.
echo.
pause
exit /b 0