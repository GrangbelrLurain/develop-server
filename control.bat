@echo off
CHCP 65001 > NUL
CLS

:: Create log directory if it doesn't exist
IF NOT EXIST ".\log" MKDIR ".\log"

:MENU
ECHO.
ECHO =====================================
ECHO   Development Environment Control
ECHO =====================================
ECHO.
ECHO   [Setup and Installation]
ECHO   1. Setup Windows Dev Environment
ECHO   2. Setup Linux Dev Environment
ECHO   3. Setup WSL2 Dev Environment
ECHO.
ECHO   [Reset and Uninstall]
ECHO   4. Reset Linux Dev Environment
ECHO   5. Run Windows Temp Uninstall Script
ECHO   6. Uninstall Windows Environment
ECHO   7. Clear apt Cache
ECHO.
ECHO   [Cache Management]
ECHO   8. Clear temp_archive Cache
ECHO.
ECHO   0. Exit
ECHO.
SET /P CHOICE="Select an option: "
ECHO Your choice: %CHOICE%
PAUSE

IF "%CHOICE%"=="1" GOTO SETUP_WINDOWS
IF "%CHOICE%"=="2" GOTO SETUP_LINUX
IF "%CHOICE%"=="3" GOTO SETUP_WSL2
IF "%CHOICE%"=="4" GOTO RESET_LINUX
IF "%CHOICE%"=="5" GOTO TEMP_UNINSTALL
IF "%CHOICE%"=="6" GOTO UNINSTALL_WINDOWS
IF "%CHOICE%"=="7" GOTO CLEAR_CACHE
IF "%CHOICE%"=="8" GOTO CLEAR_CACHE
IF "%CHOICE%"=="0" GOTO END

ECHO.
ECHO Invalid choice. Please try again.
PAUSE
GOTO MENU

:SETUP_WINDOWS
ECHO.
ECHO Setting up Windows Dev Environment...
CALL "%~dp0scripts\setup-windows.bat"
PAUSE
GOTO MENU

:SETUP_LINUX
ECHO.
ECHO Setting up Linux Dev Environment...
SET "SCRIPT_NAME=setup-linux-dev.sh"
SET "SCRIPT_WIN_PATH=%~dp0scripts\%SCRIPT_NAME%"
FOR /F "delims=" %%i IN ('wsl -d Ubuntu wslpath -a "%SCRIPT_WIN_PATH%"') DO SET "SCRIPT_WSL_PATH=%%i"
wsl -d Ubuntu bash "%SCRIPT_WSL_PATH%"
PAUSE
GOTO MENU

:SETUP_WSL2
ECHO.
ECHO Setting up WSL2 Dev Environment...
SET "SCRIPT_NAME=setup-wsl2-dev-env.sh"
SET "SCRIPT_WIN_PATH=%~dp0scripts\%SCRIPT_NAME%"
FOR /F "delims=" %%i IN ('wsl -d Ubuntu wslpath -a "%SCRIPT_WIN_PATH%"') DO SET "SCRIPT_WSL_PATH=%%i"
wsl -d Ubuntu bash "%SCRIPT_WSL_PATH%"
PAUSE
GOTO MENU

:RESET_LINUX
ECHO.
ECHO Resetting Linux Dev Environment...
SET "SCRIPT_NAME=reset-linux-dev.sh"
SET "SCRIPT_WIN_PATH=%~dp0scripts\%SCRIPT_NAME%"
FOR /F "delims=" %%i IN ('wsl -d Ubuntu wslpath -a "%SCRIPT_WIN_PATH%"') DO SET "SCRIPT_WSL_PATH=%%i"
wsl -d Ubuntu bash "%SCRIPT_WSL_PATH%"
PAUSE
GOTO MENU

:TEMP_UNINSTALL
ECHO.
ECHO Running Windows Temporary Uninstall Script...
CALL "%~dp0scripts\temp_uninstall.bat"
PAUSE
GOTO MENU

:UNINSTALL_WINDOWS
ECHO.
ECHO Uninstalling Windows Environment...
CALL "%~dp0scripts\uninstall-windows.bat"
PAUSE
GOTO MENU

:CLEAR_APT
ECHO.
ECHO Clearing apt cache...
SET "SCRIPT_NAME=reset-apt.sh"
SET "SCRIPT_WIN_PATH=%~dp0scripts\%SCRIPT_NAME%"
FOR /F "delims=" %%i IN ('wsl -d Ubuntu wslpath -a "%SCRIPT_WIN_PATH%"') DO SET "SCRIPT_WSL_PATH=%%i"
wsl -d Ubuntu bash "%SCRIPT_WSL_PATH%"
PAUSE
GOTO MENU

:CLEAR_CACHE
ECHO.
ECHO Clearing temp_archive cache...
RMDIR /S /Q temp_archive > %~dp0.\log\clear-cache_%DATE:~0,4%%DATE:~5,2%%DATE:~8,2%_%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%.log 2>&1 > .\log\clear-cache_%DATE:~0,4%%DATE:~5,2%%DATE:~8,2%_%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%.log 2>&1
IF EXIST temp_archive (
    ECHO Failed to delete temp_archive folder.
) ELSE (
    ECHO temp_archive folder deleted successfully.
)
PAUSE
GOTO MENU

:END
ECHO.
ECHO Exiting program.
PAUSE
EXIT /B 0 > .\log\clear-cache_%DATE:~0,4%%DATE:~5,2%%DATE:~8,2%_%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%.log 2>&1