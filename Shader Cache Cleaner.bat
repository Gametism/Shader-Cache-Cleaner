:: Shader Cache Cleaner
@echo off
setlocal EnableExtensions EnableDelayedExpansion

:: -----------------------------------------------------
::
::                 ██████╗ ████████╗
::                ██╔════╝ ╚══██╔══╝
::                ██║  ███╗   ██║
::                ██║   ██║   ██║
::                ╚██████╔╝   ██║
::                 ╚═════╝    ╚═╝
::
::                 CREATED BY
::                    GAMETISM
::
:: -----------------------------------------------------

:: Shader Cache Cleaner by Gametism
:: Version 0.5

title Shader Cache Cleaner by Gametism
color 0A

set "LogFile=%LOCALAPPDATA%\ShaderCacheCleaner.log"
set "FoundList=%TEMP%\ShaderCacheCleaner_Found_%RANDOM%_%RANDOM%.txt"

if /I "%~1"=="ELEVATED" (
    >>"%LogFile%" echo.
    >>"%LogFile%" echo Elevated instance started at: %date% %time%
) else (
    >"%LogFile%" (
        echo Shader Cache Cleaner Log
        echo Version 0.5
        echo -----------------------------------------------
        echo Started at: %date% %time%
        echo.
    )
)

powershell -NoProfile -ExecutionPolicy Bypass -Command "$p=[Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent(); if($p.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)){exit 0}else{exit 1}" >nul 2>&1

if errorlevel 1 (
    if /I "%~1"=="ELEVATED" (
        color 0C
        echo.
        echo ERROR: Administrative privileges could not be verified.
        echo Please try running the BAT file manually as Administrator.
        echo.
        >>"%LogFile%" echo ERROR: Administrative privileges could not be verified.
        >>"%LogFile%" echo Elevation stopped to prevent an infinite relaunch loop.
        >>"%LogFile%" echo Finished at: %date% %time%
        echo Press any key to close Shader Cache Cleaner...
        pause >nul
        exit
    )

    color 0E
    echo Requesting administrative privileges...
    >>"%LogFile%" echo Requesting administrative privileges...

    powershell -NoProfile -ExecutionPolicy Bypass -Command "try { Start-Process -FilePath '%~f0' -ArgumentList 'ELEVATED' -Verb RunAs -ErrorAction Stop; exit 0 } catch { exit 1 }"

    if errorlevel 1 (
        color 0C
        echo.
        echo Administrative privileges were NOT granted.
        echo Shader Cache Cleaner was not started.
        echo.
        >>"%LogFile%" echo Administrative privileges were not granted.
        >>"%LogFile%" echo Finished at: %date% %time%
        echo Press any key to close Shader Cache Cleaner...
        pause >nul
    )

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

set /a FoundCount=0
set /a DeletedCount=0
set /a FailedCount=0

cls
echo ...................................................
echo         Shader Cache Cleaner by Gametism
echo                  Version 0.5
echo ...................................................
echo.
echo Scanning for shader caches...
echo.

>>"%LogFile%" echo Scanning for shader caches...

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

call :scan_pattern "%LOCALAPPDATA%\Starfield" "Pipeline.cache" "Starfield Pipeline Cache"
call :scan_pattern "%LOCALAPPDATA%\id Software\Rage 2" "Pipelines.cache" "RAGE 2 Pipeline Cache"
call :scan_pattern "%LOCALAPPDATA%\TangoGameworks\The Evil Within 2" "FileCache*.bin" "The Evil Within 2 File Cache"
call :scan_pattern "%LOCALAPPDATA%\SquareEnix\FINAL FANTASY XVI" "*.psol" "FINAL FANTASY XVI PSO Cache"
call :scan_pattern "%LOCALAPPDATA%\IO Interactive\HITMAN3" "Pipeline*.bin" "HITMAN 3 Pipeline Cache"

call :scan_pattern "%USERPROFILE%\Documents\Assassin's Creed Shadows\cache\DX12" "pipelinecache*.bin" "Assassin's Creed Shadows DX12 Pipeline Cache"
call :scan_pattern "%USERPROFILE%\Documents\Assassin's Creed Black Flag Resynced\cache\DX12" "pipelinecache*.bin" "Assassin's Creed Black Flag Resynced DX12 Pipeline Cache"

call :scan_dir "%USERPROFILE%\Documents\Assassin's Creed Mirage\cache" "Assassin's Creed Mirage Cache"
call :scan_dir "%USERPROFILE%\Documents\Assassin's Creed Odyssey\cache" "Assassin's Creed Odyssey Cache"
call :scan_dir "%USERPROFILE%\Documents\Assassin's Creed Valhalla\cache" "Assassin's Creed Valhalla Cache"
call :scan_dir "%USERPROFILE%\Documents\Immortals Fenyx Rising\cache" "Immortals Fenyx Rising Cache"

call :scan_pattern "%USERPROFILE%\Documents\My Games\Ghost Recon Breakpoint\PersistentStorage" "*.cache" "Ghost Recon Breakpoint Cache"

call :scan_pattern "%USERPROFILE%\Documents\My Games\Tom Clancy's The Division\ShaderCache\dx11" "*.mcache" "The Division DX11 Shader Cache"
call :scan_pattern "%USERPROFILE%\Documents\My Games\Tom Clancy's The Division\ShaderCache\dx12" "*.mcache" "The Division DX12 Shader Cache"
call :scan_pattern "%USERPROFILE%\Documents\My Games\Tom Clancy's The Division 2\ShaderCache\dx11" "*.mcache" "The Division 2 DX11 Shader Cache"
call :scan_pattern "%USERPROFILE%\Documents\My Games\Tom Clancy's The Division 2\ShaderCache\dx12" "*.mcache" "The Division 2 DX12 Shader Cache"

call :scan_dir "%USERPROFILE%\Documents\Dead Space (2023)\cache" "Dead Space (2023) Cache"

call :scan_file "%USERPROFILE%\Documents\dying light 2\out\dx12psocache.bin" "Dying Light 2 DX12 PSO Cache"

call :scan_dir "%USERPROFILE%\Documents\Avalanche Studios\GenerationZero\Cache" "Generation Zero Cache"

echo.

if %FoundCount% EQU 0 (
    color 0E
    echo No shader caches were found.
    >>"%LogFile%" echo No shader caches were found.
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

>>"%LogFile%" echo Found %FoundCount% cache item(s):

for /f "usebackq tokens=1,2,* delims=|" %%A in ("%FoundList%") do (
    >>"%LogFile%" echo [%%A] %%B - %%C
)

>>"%LogFile%" echo.

color 0A
choice /c YN /M "Delete these shader caches"

if errorlevel 2 (
    color 0E
    echo.
    echo Operation canceled.
    >>"%LogFile%" echo Operation canceled by user.
    goto finish
)

echo.
echo Cleaning shader caches...
echo.
>>"%LogFile%" echo Cleaning shader caches...

for /f "usebackq tokens=1,2,* delims=|" %%A in ("%FoundList%") do (
    if /I "%%A"=="DIR" call :clear_dir "%%C" "%%B"
    if /I "%%A"=="FILE" call :delete_file "%%C" "%%B"
)

echo.

if %FailedCount% EQU 0 (
    color 0A
    echo ===============================================
    echo Cleanup completed successfully.
    echo ===============================================
    echo.
    echo Deleted: %DeletedCount%
    echo Failed : 0
    echo.
    >>"%LogFile%" echo Cleanup completed successfully.
) else (
    color 0E
    echo ===============================================
    echo Cleanup completed with some failures.
    echo ===============================================
    echo.
    echo Deleted: %DeletedCount%
    echo Failed : %FailedCount%
    echo.
    echo Some cache files may still be locked or in use.
    echo.
    >>"%LogFile%" echo Cleanup completed with some failures.
)

>>"%LogFile%" echo Deleted: %DeletedCount%
>>"%LogFile%" echo Failed : %FailedCount%
>>"%LogFile%" echo.

echo Restart your PC if shaders do not recompile.
echo Log saved to: %LogFile%
goto finish


:scan_dir
if not exist "%~1" exit /b

dir /a /b "%~1" >nul 2>&1
if errorlevel 1 exit /b

set /a FoundCount+=1
echo [Folder] %~2
>>"%FoundList%" echo DIR^|%~2^|%~1
>>"%LogFile%" echo Found folder: %~2 - %~1
exit /b


:scan_pattern
if not exist "%~1" exit /b

for /r "%~1" %%F in (%~2) do (
    if exist "%%~fF" (
        set /a FoundCount+=1
        echo [File] %~3 - %%~fF
        >>"%FoundList%" echo FILE^|%~3^|%%~fF
        >>"%LogFile%" echo Found file: %~3 - %%~fF
    )
)
exit /b


:scan_file
if not exist "%~1" exit /b

set /a FoundCount+=1
echo [File] %~2 - %~1
>>"%FoundList%" echo FILE^|%~2^|%~1
>>"%LogFile%" echo Found file: %~2 - %~1
exit /b


:clear_dir
echo Cleaning folder: %~2
>>"%LogFile%" echo Cleaning folder: %~2 - %~1

dir /a /b "%~1" >nul 2>&1

if errorlevel 1 (
    color 0E
    echo No files found: %~1
    >>"%LogFile%" echo No files found: %~1
    exit /b
)

del /f /q /a "%~1\*" >nul 2>&1

for /d %%D in ("%~1\*") do (
    rd /s /q "%%~fD" >nul 2>&1
)

dir /a /b "%~1" >nul 2>&1

if errorlevel 1 (
    color 0A
    echo Cleaned folder: %~1
    >>"%LogFile%" echo Cleaned folder: %~1
    set /a DeletedCount+=1
) else (
    color 0E
    echo Partially cleaned, some files are locked or still in use:
    echo %~1
    >>"%LogFile%" echo Partially cleaned, some files are locked or still in use: %~1
    set /a FailedCount+=1
)

exit /b


:delete_file
echo Deleting file: %~2
>>"%LogFile%" echo Deleting file: %~2 - %~1

del /f /q /a "%~1" >nul 2>&1

if exist "%~1" (
    color 0C
    echo Failed file: %~1
    >>"%LogFile%" echo Failed file: %~1
    set /a FailedCount+=1
) else (
    color 0A
    echo Deleted file: %~1
    >>"%LogFile%" echo Deleted file: %~1
    set /a DeletedCount+=1
)

exit /b


:finish
>>"%LogFile%" echo.
>>"%LogFile%" echo Finished at: %date% %time%
>>"%LogFile%" echo Log saved to: %LogFile%

if exist "%FoundList%" (
    del /f /q "%FoundList%" >nul 2>&1
)

echo.
echo Press any key to close Shader Cache Cleaner...
powershell -NoProfile -ExecutionPolicy Bypass -Command "try { while ([Console]::KeyAvailable) { [void][Console]::ReadKey($true) }; [void][Console]::ReadKey($true); exit 0 } catch { exit 1 }" >nul 2>&1
if errorlevel 1 pause >nul
exit
