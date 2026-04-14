@echo off
setlocal EnableExtensions EnableDelayedExpansion

:: Shader Cache Cleaner by Gametism
:: Version 0.2

net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting administrative privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

set "NVIDIA_cache1=%LOCALAPPDATA%\NVIDIA\DXCache"
set "NVIDIA_cache2=%LOCALAPPDATA%\NVIDIA\GLCache"
set "NVIDIA_cache3=%LOCALAPPDATA%\NVIDIA Corporation\NV_Cache"

set "AMD_cache1=%LOCALAPPDATA%\AMD\DxCache"
set "AMD_cache2=%LOCALAPPDATA%\AMD\GLCache"

set "Intel_cache1=%LOCALAPPDATA%\Intel\ShaderCache"
set "Intel_cache2=%LOCALAPPDATA%\Low\Intel\ShaderCache"

set "DirectX_cache=%LOCALAPPDATA%\D3DSCache"

set "LogFile=%LOCALAPPDATA%\ShaderCacheCleaner.log"
set "FoundList=%TEMP%\ShaderCacheCleaner_Found_%RANDOM%_%RANDOM%.txt"

echo Shader Cache Cleaner Log > "%LogFile%"
echo Version 0.2 >> "%LogFile%"
echo --------------------------------------- >> "%LogFile%"
echo Started at: %date% %time% >> "%LogFile%"
echo. >> "%LogFile%"

break > "%FoundList%"

set /a FoundCount=0
set /a DeletedCount=0
set /a FailedCount=0

echo Welcome to the Shader Cache Cleaner by Gametism!
echo Version 0.2
echo.
echo Scanning for shader caches...
echo Scanning for shader caches... >> "%LogFile%"
echo.


call :scan_dir "%NVIDIA_cache1%" "NVIDIA DXCache"
call :scan_dir "%NVIDIA_cache2%" "NVIDIA GLCache"
call :scan_dir "%NVIDIA_cache3%" "NVIDIA NV_Cache"

call :scan_dir "%AMD_cache1%" "AMD DXCache"
call :scan_dir "%AMD_cache2%" "AMD GLCache"

call :scan_dir "%Intel_cache1%" "Intel ShaderCache"
call :scan_dir "%Intel_cache2%" "Intel Low ShaderCache"

call :scan_dir "%DirectX_cache%" "DirectX D3DSCache"

call :scan_pattern "%LOCALAPPDATA%" "*_ShaderCacheCheck.bin" "Unreal ShaderCacheCheck file"
call :scan_pattern "%LOCALAPPDATA%" "*.upipelinecache" "Unreal Pipeline Cache file"

if %FoundCount% EQU 0 (
    echo No shader caches were found.
    echo No shader caches were found. >> "%LogFile%"
    goto finish
)

echo Found %FoundCount% cache item(s):
echo.
type "%FoundList%"
echo.
echo Found %FoundCount% cache item(s). >> "%LogFile%"
echo. >> "%LogFile%"
type "%FoundList%" >> "%LogFile%"
echo. >> "%LogFile%"

choice /c YN /M "Delete these found shader caches"
if %ERRORLEVEL% EQU 2 (
    echo Deletion canceled.
    echo Deletion canceled by user. >> "%LogFile%"
    goto finish
)

echo.
echo Starting deletion...
echo Starting deletion... >> "%LogFile%"
echo.

for /f "usebackq tokens=1,2,* delims=|" %%A in ("%FoundList%") do (
    if /I "%%A"=="DIR" call :delete_dir "%%C" "%%B"
    if /I "%%A"=="FILE" call :delete_file "%%C" "%%B"
)

echo.
echo Deletion summary:
echo Deleted: %DeletedCount%
echo Failed:  %FailedCount%
echo.
echo Deletion summary: Deleted=%DeletedCount%, Failed=%FailedCount% >> "%LogFile%"

echo If shaders still are not recompiling after this, restart your computer and try again.
echo Some files may still be in use by Windows, the GPU driver, or a running game.
echo.
echo You can also reset shader cache from your GPU control panel:
echo NVIDIA: Manage 3D Settings - Shader Cache Size
echo AMD: Graphics - Advanced - Reset Shader Cache

goto finish


:scan_dir
set "scanPath=%~1"
set "scanLabel=%~2"

if exist "%scanPath%" (
    set /a FoundCount+=1
    echo [Folder] %scanLabel%
    >> "%FoundList%" echo DIR^|%scanLabel%^|%scanPath%
    >> "%LogFile%" echo Found folder: %scanLabel% - %scanPath%
)
exit /b

:scan_pattern
set "searchRoot=%~1"
set "filePattern=%~2"
set "scanLabel=%~3"

for /r "%searchRoot%" %%F in (%filePattern%) do (
    if exist "%%~fF" (
        set /a FoundCount+=1
        echo [File] %%~fF
        >> "%FoundList%" echo FILE^|%scanLabel%^|%%~fF
        >> "%LogFile%" echo Found file: %%~fF
    )
)
exit /b

:delete_dir
set "targetPath=%~1"
set "targetLabel=%~2"

echo Deleting folder: %targetLabel%
echo Deleting folder: %targetLabel% - %targetPath% >> "%LogFile%"

rmdir /s /q "%targetPath%" >nul 2>&1

if exist "%targetPath%" (
    echo Failed: %targetPath%
    echo Failed to delete folder: %targetPath% >> "%LogFile%"
    set /a FailedCount+=1
) else (
    echo Deleted: %targetPath%
    echo Deleted folder: %targetPath% >> "%LogFile%"
    set /a DeletedCount+=1
)
exit /b

:delete_file
set "targetPath=%~1"
set "targetLabel=%~2"

echo Deleting file: %targetPath%
echo Deleting file: %targetPath% >> "%LogFile%"

del /f /q "%targetPath%" >nul 2>&1

if exist "%targetPath%" (
    echo Failed: %targetPath%
    echo Failed to delete file: %targetPath% >> "%LogFile%"
    set /a FailedCount+=1
) else (
    echo Deleted: %targetPath%
    echo Deleted file: %targetPath% >> "%LogFile%"
    set /a DeletedCount+=1
)
exit /b

:finish
echo. >> "%LogFile%"
echo Finished at: %date% %time% >> "%LogFile%"

if exist "%FoundList%" del /f /q "%FoundList%" >nul 2>&1

pause
exit /b