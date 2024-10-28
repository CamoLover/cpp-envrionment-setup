@echo off
setlocal enabledelayedexpansion

color a
:: Get the directory where the batch file is located
set "SCRIPT_DIR=%~dp0"
cd /d "%SCRIPT_DIR%"

echo Building project in: %SCRIPT_DIR%
echo.

:: Extract the project name from CMakeLists.txt
set "PROJECT_NAME="
for /f "usebackq tokens=2 delims=()" %%A in (`findstr /ri "^project(" "%SCRIPT_DIR%CMakeLists.txt"`) do (
    set "PROJECT_NAME=%%A"
)

:: Trim any spaces that might be captured around the project name
set "PROJECT_NAME=%PROJECT_NAME: =%"

if not defined PROJECT_NAME (
    echo ERROR: Could not determine project name from CMakeLists.txt
    pause
    exit /b 1
)

echo Project name is: %PROJECT_NAME%
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
if exist "Debug\%PROJECT_NAME%.exe" (
    Debug\%PROJECT_NAME%.exe
) else if exist "%PROJECT_NAME%.exe" (
    %PROJECT_NAME%.exe
) else (
    echo Could not find executable. It might be in a different location.
    dir /s /b %PROJECT_NAME%.exe
)
echo.
echo ======================================================
echo.

cd ..
pause
