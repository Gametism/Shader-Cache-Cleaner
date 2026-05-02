```bat
@echo off
setlocal EnableExtensions EnableDelayedExpansion

:: Shader Cache Cleaner by Gametism
:: Version 0.5

title Shader Cache Cleaner by Gametism
color 0A

set "LogFile=%LOCALAPPDATA%\ShaderCacheCleaner.log"
set "FoundList=%TEMP%\ShaderCacheCleaner_Found_%RANDOM%_%RANDOM%.txt"

> "%LogFile%" (
    echo Shader Cache Cleaner Log
    echo Version 0.5
    echo -----------------------------------------------
    echo Started at: %date% %time%
    echo.
)

net session >nul 2>&1
if %errorLevel% neq 0 (
    color 0E
    echo Requesting administrative privileges...
    echo Requesting administrative privileges... >> "%LogFile%"
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

type nul > "%FoundList%"

echo ...................................................
echo         Shader Cache Cleaner by Gametism
echo                  Version 0.5
echo ...................................................
echo.

set /a FoundCount=0
set /a DeletedCount=0
set /a FailedCount=0

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
call :scan_pattern "%LOCALAPPDATA%" "*.upipelinecache" "Unreal Pipeline Cache"
call :scan_pattern "%LOCALAPPDATA%" "*.ushaderprecache" "Unreal Shader Precache"
call :scan_pattern "%MyGamesRoot%" "*.upipelinecache" "My Games Unreal Pipeline Cache"
call :scan_pattern "%MyGamesRoot%" "*.ushaderprecache" "My Games Unreal Shader Precache"
call :scan_pattern "%MyGamesRoot%" "D3DDriverByteCodeBlob_*.ushaderprecache" "My Games D3D Driver ByteCode Blob"
call :scan_pattern "%LOCALAPPDATA%\Starfield" "Pipeline.cache" "Starfield Pipeline Cache"
call :scan_pattern "%LOCALAPPDATA%\id Software\Rage 2" "Pipelines.cache" "RAGE 2 Pipeline Cache"
call :scan_pattern "%LOCALAPPDATA%\TangoGameworks\The Evil Within 2" "FileCache*.bin" "The Evil Within 2 File Cache"
call :scan_pattern "%LOCALAPPDATA%\SquareEnix\FINAL FANTASY XVI" "*.psol" "FINAL FANTASY XVI PSO Cache"
call :scan_pattern "%LOCALAPPDATA%\IO Interactive\HITMAN3" "Pipeline*.bin" "HITMAN 3 Pipeline Cache"
call :scan_pattern "%USERPROFILE%\Documents\Assassin's Creed Shadows\cache\DX12" "pipelinecache*.bin" "AC Shadows DX12 Pipeline Cache"
call :scan_dir "%USERPROFILE%\Documents\Assassin's Creed Mirage\cache" "AC Mirage Cache"
call :scan_dir "%USERPROFILE%\Documents\Assassin's Creed Odyssey\cache" "AC Odyssey Cache"
call :scan_dir "%USERPROFILE%\Documents\Assassin's Creed Valhalla\cache" "AC Valhalla Cache"
call :scan_dir "%USERPROFILE%\Documents\Immortals Fenyx Rising\cache" "Immortals Fenyx Rising Cache"
call :scan_pattern "%USERPROFILE%\Documents\My Games\Ghost Recon Breakpoint\PersistentStorage" "*.cache" "Ghost Recon Breakpoint Cache"
call :scan_pattern "%USERPROFILE%\Documents\My Games\Tom Clancy's The Division\ShaderCache\dx11" "*.mcache" "The Division DX11 Shader Cache"
call :scan_pattern "%USERPROFILE%\Documents\My Games\Tom Clancy's The Division\ShaderCache\dx12" "*.mcache" "The Division DX12 Shader Cache"
call :scan_pattern "%USERPROFILE%\Documents\My Games\Tom Clancy's The Division 2\ShaderCache\dx11" "*.mcache" "The Division 2 DX11 Shader Cache"
call :scan_pattern "%USERPROFILE%\Documents\My Games\Tom Clancy's The Division 2\ShaderCache\dx12" "*.mcache" "The Division 2 DX12 Shader Cache"
call :scan_dir "%USERPROFILE%\Documents\Dead Space (2023)\cache" "Dead Space (2023) Cache"
call :scan_pattern "%USERPROFILE%\Documents\dying light 2\out" "dx12psocache.bin" "Dying Light 2 DX12 PSO Cache"
call :scan_dir "%USERPROFILE%\Documents\Avalanche Studios\GenerationZero\Cache" "Generation Zero Cache"

echo.

if %FoundCount% EQU 0 (
    color 0E
    echo No shader caches were found.
    echo No shader caches were found. >> "%LogFile%"
    goto finish
)

color 0B
echo Found %FoundCount% cache item(s):
echo -----------------------------------------------
for /f "usebackq tokens=1,2,* delims=|" %%A in ("%FoundList%") do (
    echo [%%A] %%B - %%C
)
echo -----------------------------------------------
echo.

echo Found %FoundCount% cache item(s): >> "%LogFile%"
for /f "usebackq tokens=1,2,* delims=|" %%A in ("%FoundList%") do (
    echo [%%A] %%B - %%C >> "%LogFile%"
)
echo. >> "%LogFile%"

color 0A
choice /c YN /M "Delete these shader caches"

if %errorlevel% EQU 2 (
    color 0E
    echo Operation canceled.
    echo Operation canceled by user. >> "%LogFile%"
    goto finish
)

echo.
echo Cleaning shader caches...
echo Cleaning shader caches... >> "%LogFile%"
echo.

for /f "usebackq tokens=1,2,* delims=|" %%A in ("%FoundList%") do (
    if /I "%%A"=="DIR" call :clear_dir "%%C" "%%B"
    if /I "%%A"=="FILE" call :delete_file "%%C" "%%B"
)

echo.
color 0B
echo ===============================================
echo Deleted: %DeletedCount%
echo Failed : %FailedCount%
echo ===============================================
echo.

echo Deletion summary: >> "%LogFile%"
echo Deleted: %DeletedCount% >> "%LogFile%"
echo Failed : %FailedCount% >> "%LogFile%"
echo. >> "%LogFile%"

color 0A
echo Done.
echo Restart your PC if shaders do not recompile.
echo Log saved to: %LogFile%
goto finish


:scan_dir
if not exist "%~1" exit /b

dir /a /b "%~1" >nul 2>&1
if errorlevel 1 exit /b

set /a FoundCount+=1
echo [Folder] %~2
echo DIR^|%~2^|%~1>>"%FoundList%"
echo Found folder: %~2 - %~1>>"%LogFile%"
exit /b


:scan_pattern
if not exist "%~1" exit /b

for /r "%~1" %%F in (%~2) do (
    if exist "%%~fF" (
        set /a FoundCount+=1
        echo [File] %~3 - %%~fF
        echo FILE^|%~3^|%%~fF>>"%FoundList%"
        echo Found file: %~3 - %%~fF>>"%LogFile%"
    )
)
exit /b


:clear_dir
echo Cleaning folder: %~2
echo Cleaning folder: %~2 - %~1>>"%LogFile%"

dir /a /b "%~1" >nul 2>&1
if errorlevel 1 (
    color 0E
    echo No files found: %~1
    echo No files found: %~1>>"%LogFile%"
    exit /b
)

del /f /q /a "%~1\*" >nul 2>&1
for /d %%D in ("%~1\*") do rd /s /q "%%~fD" >nul 2>&1

dir /a /b "%~1" >nul 2>&1
if errorlevel 1 (
    color 0A
    echo Cleaned folder: %~1
    echo Cleaned folder: %~1>>"%LogFile%"
    set /a DeletedCount+=1
) else (
    color 0E
    echo Partially cleaned, some files are locked or still in use: %~1
    echo Partially cleaned, some files are locked or still in use: %~1>>"%LogFile%"
    set /a FailedCount+=1
)
exit /b


:delete_file
echo Deleting file: %~2
echo Deleting file: %~2 - %~1>>"%LogFile%"

del /f /q /a "%~1" >nul 2>&1

if exist "%~1" (
    color 0C
    echo Failed file: %~1
    echo Failed file: %~1>>"%LogFile%"
    set /a FailedCount+=1
) else (
    color 0A
    echo Deleted file: %~1
    echo Deleted file: %~1>>"%LogFile%"
    set /a DeletedCount+=1
)
exit /b


:finish
echo.>>"%LogFile%"
echo Finished at: %date% %time%>>"%LogFile%"
echo Log saved to: %LogFile%>>"%LogFile%"

if exist "%FoundList%" del /f /q "%FoundList%" >nul 2>&1

echo.
pause
exit /b
```
