@echo off
setlocal EnableExtensions EnableDelayedExpansion

:: Shader Cache Cleaner by Gametism
:: Version 0.3

title Shader Cache Cleaner by Gametism
color 0A

net session >nul 2>&1
if %errorLevel% neq 0 (
    color 0E
    echo Requesting administrative privileges...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
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
set "MyGamesRoot=%USERPROFILE%\Documents\My Games"

set "LogFile=%LOCALAPPDATA%\ShaderCacheCleaner.log"
set "FoundList=%TEMP%\ShaderCacheCleaner_Found_%RANDOM%_%RANDOM%.txt"

type nul > "%FoundList%"

echo ...................................................
echo         Shader Cache Cleaner by Gametism
echo                  Version 0.3
echo ...................................................
echo.

set /a FoundCount=0
set /a DeletedCount=0
set /a FailedCount=0

echo Scanning for shader caches...
echo.

call :scan_dir "%NVIDIA_cache1%" "NVIDIA DXCache"
call :scan_dir "%NVIDIA_cache2%" "NVIDIA GLCache"
call :scan_dir "%NVIDIA_cache3%" "NVIDIA NV_Cache"

call :scan_dir "%AMD_cache1%" "AMD DXCache"
call :scan_dir "%AMD_cache2%" "AMD GLCache"

call :scan_dir "%Intel_cache1%" "Intel ShaderCache"
call :scan_dir "%Intel_cache2%" "Intel Low ShaderCache"

call :scan_dir "%DirectX_cache%" "DirectX D3DSCache"

call :scan_pattern "%LOCALAPPDATA%" "*.upipelinecache"
call :scan_pattern "%LOCALAPPDATA%" "*.ushaderprecache"
call :scan_pattern "%MyGamesRoot%" "*.upipelinecache"
call :scan_pattern "%MyGamesRoot%" "*.ushaderprecache"
call :scan_pattern "%MyGamesRoot%" "D3DDriverByteCodeBlob_*.ushaderprecache"

echo.

if %FoundCount% EQU 0 (
    color 0E
    echo No shader caches were found.
    goto finish
)

color 0B
echo Found %FoundCount% cache item(s):
echo -----------------------------------------------
type "%FoundList%"
echo -----------------------------------------------
echo.

color 0A
choice /c YN /M "Delete these shader caches"

if %errorlevel% EQU 2 (
    color 0E
    echo Operation canceled.
    goto finish
)

echo.
echo Cleaning shader caches...
echo.

for /f "usebackq tokens=1,* delims=|" %%A in ("%FoundList%") do (
    if /I "%%A"=="DIR" call :clear_dir "%%B"
    if /I "%%A"=="FILE" call :delete_file "%%B"
)

echo.
color 0B
echo ===============================================
echo Deleted: %DeletedCount%
echo Failed : %FailedCount%
echo ===============================================
echo.

color 0A
echo Done.
echo Restart your PC if shaders do not recompile.
goto finish


:scan_dir
if not exist "%~1" exit /b

dir /a /b "%~1" >nul 2>&1
if errorlevel 1 exit /b

set /a FoundCount+=1
echo DIR^|%~1>>"%FoundList%"
exit /b


:scan_pattern
if not exist "%~1" exit /b

for /r "%~1" %%F in (%~2) do (
    if exist "%%~fF" (
        set /a FoundCount+=1
        echo FILE^|%%~fF>>"%FoundList%"
    )
)
exit /b


:clear_dir
del /f /q /a "%~1\*" >nul 2>&1
for /d %%D in ("%~1\*") do rd /s /q "%%~fD" >nul 2>&1

dir /a /b "%~1" >nul 2>&1
if errorlevel 1 (
    color 0A
    echo Deleted folder contents: %~1
    set /a DeletedCount+=1
) else (
    color 0C
    echo Failed folder: %~1
    set /a FailedCount+=1
)
exit /b


:delete_file
del /f /q /a "%~1" >nul 2>&1

if exist "%~1" (
    color 0C
    echo Failed file: %~1
    set /a FailedCount+=1
) else (
    color 0A
    echo Deleted file: %~1
    set /a DeletedCount+=1
)
exit /b


:finish
if exist "%FoundList%" del /f /q "%FoundList%" >nul 2>&1
echo.
pause
exit /b