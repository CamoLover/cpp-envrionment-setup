@echo off
setlocal enabledelayedexpansion

color a
:: Get the directory where the batch file is located
set "SCRIPT_DIR=%~dp0"
cd /d "%SCRIPT_DIR%"

echo Building project in: %SCRIPT_DIR%
echo.

if not exist "%SCRIPT_DIR%build" (
    echo Creating build directory...
    mkdir "%SCRIPT_DIR%build" || (
        echo ERROR: Failed to create build directory
        pause
        exit /b 1
    )
)

echo Entering build directory...
cd "%SCRIPT_DIR%build" || (
    echo ERROR: Failed to enter build directory
    pause
    exit /b 1
)

echo Running CMake configure...
cmake .. || (
    echo ERROR: CMake configuration failed
    pause
    exit /b 1
)

echo Building project...
cmake --build . || (
    echo ERROR: Build failed
    cd ..
    pause
    exit /b 1
)

echo.
echo Build successful
echo Built files are in: %SCRIPT_DIR%build
echo.

:: Find and run the executable
echo Running the program:
echo ======================================================
echo.
if exist "Debug\SCiPnet.exe" (
    Debug\SCiPnet.exe
) else if exist "SCiPnet.exe" (
    SCiPnet.exe
) else (
    echo Could not find executable. It might be in a different location.
    dir /s /b SCiPnet.exe
)
echo.
echo ======================================================
echo.

cd ..
pause
