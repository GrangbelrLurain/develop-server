@echo off
setlocal enabledelayedexpansion

REM --- Section 1: Initial Environment Prerequisite Check ---
echo --- Checking for WSL2...
wsl -l -v >nul 2>&1
if %errorlevel% neq 0 (
    echo WSL is not installed. Attempting to install...
    wsl --install --no-distribution
    if %errorlevel% neq 0 (
        echo WSL installation failed. Please install it manually and restart your computer.
        pause
        goto :eof
    )
    echo WSL has been installed. Please restart your computer to complete the installation.
    pause
    goto :eof
) else {
    echo WSL is already installed.
}

echo.
echo --- Checking for Docker Desktop...
where docker >nul 2>&1
if %errorlevel% neq 0 (
    echo Docker Desktop is not installed. Attempting to install using winget...
    winget install -e --id Docker.DockerDesktop
    if %errorlevel% neq 0 (
        echo Docker Desktop installation via winget failed. Please install it manually.
        pause
        goto :eof
    )
    echo Docker Desktop has been installed. Please start it and configure WSL/Kubernetes integration.
    pause
) else {
    echo Docker Desktop is already installed.
}

REM --- Section 2: Dynamic Configuration from .env file ---
echo.
echo --- Reading configuration from .env file...
if not exist .env (
    echo .env file not found. Please create it with APP_NAME and DEV_HOST_PATH.
    pause
    goto :eof
)
for /f "usebackq tokens=1,* delims==" %%a in (".env") do (
    set "%%a=%%b"
)

REM --- Validate required variables ---
if not defined APP_NAME (
    echo APP_NAME not found in .env file.
    pause
    goto :eof
)
if not defined DEV_HOST_PATH (
    echo DEV_HOST_PATH not found in .env file.
    pause
    goto :eof
)

REM --- Convert Windows path for Kubernetes ---
set "K8S_HOST_PATH=!DEV_HOST_PATH:C:=/run/desktop/mnt/host/c!"
set "K8S_HOST_PATH=!K8S_HOST_PATH:\=/!"

echo App Name: %APP_NAME%
echo Host Path: %DEV_HOST_PATH%
echo Kubernetes Path: %K8S_HOST_PATH%
echo.

REM --- Section 3: Build and Deploy ---

REM --- Create temporary YAML from template ---
set "TEMP_YAML=k8s-deployment.temp.yaml"
(
    for /f "usebackq delims=" %%L in ("k8s-deployment.yaml") do (
        set "line=%%L"
        set "line=!line:##APP_NAME##=%APP_NAME%!"
        set "line=!line:##DEV_HOST_PATH##=%K8S_HOST_PATH%!"
        echo !line!
    )
)>"%TEMP_YAML%"

echo --- Building new Docker image (%APP_NAME%:latest) ---
docker build -t %APP_NAME%:latest .
if %errorlevel% neq 0 (
    echo Docker image build failed.
    del "%TEMP_YAML%"
    pause
    goto :eof
)
echo Image built successfully.
echo.

REM --- Create or Update Kubernetes Secret ---
set "SECRET_NAME=%APP_NAME%-secret"
echo Updating secret '%SECRET_NAME%'...
kubectl delete secret %SECRET_NAME% --ignore-not-found=true >nul 2>&1
kubectl create secret generic %SECRET_NAME% --from-env-file=.env
if %errorlevel% neq 0 (
    echo Failed to create Kubernetes secret.
    del "%TEMP_YAML%"
    pause
    goto :eof
)
echo Secret updated successfully.
echo.

REM --- Applying Kubernetes deployment ---
echo --- Applying Kubernetes deployment...
kubectl apply -f "%TEMP_YAML%"
if %errorlevel% neq 0 (
    echo Failed to apply Kubernetes deployment.
    del "%TEMP_YAML%"
    pause
    goto :eof
)
echo.
echo Deployment has been applied successfully.

REM --- Section 4: Cleanup and Final Instructions ---
del "%TEMP_YAML%"

echo.
echo ===================================================
echo Development environment setup is complete.
echo App Name: %APP_NAME%
echo ===================================================
echo.
echo You can monitor the status with: kubectl get pods -w
echo To get a shell inside the container, use:
echo kubectl exec -it deployment/%APP_NAME% -- /bin/bash

endlocal
pause
