@echo off

set network_folder=\\server\share\folder
set local_folder=C:\scom_agent_install

echo Checking if SCOM agent service is installed...
sc query "HealthService" >nul 2>&1
if %errorlevel% equ 0 (
    echo SCOM agent service is already installed. Exiting script.
    exit /b
)

echo Copying network folder to local folder...
xcopy /s /e /y "%network_folder%" "%local_folder%"

echo Installing SCOM agent from local folder...
"%local_folder%\setup.exe" /silent

echo Checking status of SCOM agent service...
sc query "HealthService" | find "RUNNING" >nul
if %errorlevel% equ 0 (
    echo SCOM agent service is running.
) else (
    echo SCOM agent service is not running.
)

echo Deleting local folder...
rmdir /s /q "%local_folder%"
