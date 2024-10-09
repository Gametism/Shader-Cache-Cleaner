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
set "Intel_cache2=%LocalAppData%Low\Intel\ShaderCache"

echo Welcome to the Shader Cache Cleaner by Gametism!
echo Version 0.1
echo.

choice /c YN /M "Do you want to delete all shader caches?"
if %ERRORLEVEL% == 2 (
    echo Tschüss.
    goto end
)

echo Starting cache cleaning process...
echo.

:: Function to delete cache if it exists
call :delete_cache "%NVidia_cache1%" "NVidia DXCache"
call :delete_cache "%NVidia_cache2%" "NVidia GLCache"
call :delete_cache "%NVidia_cache3%" "NVidia NV_Cache"
call :delete_cache "%AMD_cache1%" "AMD DXCache"
call :delete_cache "%AMD_cache2%" "AMD GLCache"
call :delete_cache "%Intel_cache1%" "Intel ShaderCache"
call :delete_cache "%Intel_cache2%" "Intel Low ShaderCache"


echo.
echo If shaders still aren’t recompiling after this, restart your computer and try again.
echo Some files in the DXCache folder might still be in use.
echo Another solution is to disable-enable/reset the shader cache in your designated control panel:
echo NVIDIA: Manage 3D Settings - Shader Cache Size
echo AMD: Graphics - Advanced - Reset Shader Cache

:end
pause
exit /b

:delete_cache
if exist %1 (
    echo Deleting %2...
    del /s /f /q "%~1\*.*" >nul 2>&1
    rmdir /s /q "%~1" >nul 2>&1
    if exist %1 (
        echo Failed to delete %2. Some files may still be in use.
    ) else (
        echo %2 deleted.
    )
) else (
    echo %2 not found.
)
exit /b
