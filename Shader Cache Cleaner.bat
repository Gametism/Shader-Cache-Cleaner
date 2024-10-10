@echo off
:: Check if the script is run as administrator
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting administrative privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: Now running with administrative privileges

set "NVidia_cache1=%LOCALAPPDATA%\NVIDIA\DXCache"
set "NVidia_cache2=%LOCALAPPDATA%\NVIDIA\GLCache"
set "NVidia_cache3=%LOCALAPPDATA%\NVIDIA Corporation\NV_Cache"
set "AMD_cache1=%LOCALAPPDATA%\AMD\DxCache"
set "AMD_cache2=%LOCALAPPDATA%\AMD\GLCache"
set "Intel_cache1=%LOCALAPPDATA%\Intel\ShaderCache"
set "Intel_cache2=%LOCALAPPDATA%\Low\Intel\ShaderCache"

:: Create log file
set "LogFile=%LOCALAPPDATA%\ShaderCacheCleaner.log"
echo Shader Cache Cleaner Log > "%LogFile%"
echo Version 0.1 >> "%LogFile%"
echo --------------------------------------- >> "%LogFile%"
echo Started at: %date% %time% >> "%LogFile%"
echo. >> "%LogFile%"

echo Welcome to the Shader Cache Cleaner by Gametism!
echo Version 0.1
echo.

:: Cache cleaning process starts here
echo "These directories will be deleted:"
echo %NVidia_cache1%
echo %NVidia_cache2%
echo %NVidia_cache3%
echo %AMD_cache1%
echo %AMD_cache2%
echo %Intel_cache1%
echo %Intel_cache2%

:: Confirmation for deletion
choice /c YN /M "Are you sure you want to delete these directories?"
if %ERRORLEVEL% == 2 (
    echo Deletion canceled.
    goto end
)

:: Ask if user wants to add a custom path to delete
set "CustomGameCache="
choice /c YN /M "Do you want to add a custom path for a game shader cache?"
if %ERRORLEVEL% == 1 (
    set /p CustomGameCache="Please copy and paste the path to the shader cache folder or file you want to delete: "
)

echo Starting cache cleaning process...
echo. >> "%LogFile%"

:: Function to delete cache if it exists
call :delete_cache "%NVidia_cache1%" "NVIDIA DXCache"
call :delete_cache "%NVidia_cache2%" "NVIDIA GLCache"
call :delete_cache "%NVidia_cache3%" "NVIDIA NV_Cache"
call :delete_cache "%AMD_cache1%" "AMD DXCache"
call :delete_cache "%AMD_cache2%" "AMD GLCache"
call :delete_cache "%Intel_cache1%" "Intel ShaderCache"
call :delete_cache "%Intel_cache2%" "Intel Low ShaderCache"

:: Check if user provided a custom path and delete it
if defined CustomGameCache (
    call :delete_file_or_directory "%CustomGameCache%" "Custom Game Shader Cache"
)

echo.
echo If shaders still aren't recompiling after this, restart your computer and try again.
echo Some files in the DXCache folder might still be in use.
echo Another solution is to disable-enable/reset the shader cache in your designated control panel:
echo NVIDIA: Manage 3D Settings - Shader Cache Size
echo AMD: Graphics - Advanced - Reset Shader Cache

:end
echo Finished at: %date% %time% >> "%LogFile%"
pause
exit /b

:delete_cache
if exist "%~1" (
    echo Deleting %2...
    echo Deleting %2... >> "%LogFile%"
    del /s /f /q "%~1\*.*" >nul 2>&1
    rmdir /s /q "%~1" >nul 2>&1
    if exist "%~1" (
        echo Failed to delete %2. Some files may still be in use. >> "%LogFile%"
        echo Failed to delete %2. Some files may still be in use.
    ) else (
        echo %2 deleted. >> "%LogFile%"
        echo %2 deleted.
    )
) else (
    echo %2 not found. >> "%LogFile%"
    echo %2 not found.
)
exit /b

:delete_file_or_directory
:: Delete a specific file or directory
set "path=%~1"
set "name=%~2"

if exist "%path%" (
    echo Deleting %name%...
    echo Deleting %name%... >> "%LogFile%"
    if exist "%path%\" (
        rmdir /s /q "%path%" >nul 2>&1
    ) else (
        del /f /q "%path%" >nul 2>&1
    )
    
    if exist "%path%" (
        echo Failed to delete %name%. The file or directory may still be in use. >> "%LogFile%"
        echo Failed to delete %name%. The file or directory may still be in use.
    ) else (
        echo %name% deleted. >> "%LogFile%"
        echo %name% deleted.
    )
) else (
    echo %name% not found. >> "%LogFile%"
    echo %name% not found.
)
exit /b
