@echo off
setlocal enabledelayedexpansion

:: Get the directory where the batch file is located
set "SCRIPT_DIR=%~dp0"
cd /d "%SCRIPT_DIR%"

echo Starting C++ Project Setup in: %SCRIPT_DIR%
echo.
pause

:: Check if running as administrator
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Please run this script as Administrator!
    echo Right-click the script and select "Run as administrator"
    echo.
    pause
    exit /b 1
)

:: Check if Chocolatey is installed
echo Checking for Chocolatey...
where choco >nul 2>&1
if %errorlevel% neq 0 (
    echo Installing Chocolatey...
    echo.
    powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" || (
        echo ERROR: Failed to install Chocolatey
        pause
        exit /b 1
    )
    :: Refresh environment variables
    call refreshenv
    echo Chocolatey installation complete
    echo.
    pause
) else (
    echo Chocolatey is already installed
    echo.
)

:: Check and install MinGW
echo Checking for G++...
where g++ >nul 2>&1
if %errorlevel% neq 0 (
    echo Installing MinGW...
    echo.
    choco install mingw -y || (
        echo ERROR: Failed to install MinGW
        pause
        exit /b 1
    )
    :: Refresh environment variables
    call refreshenv
    echo MinGW installation complete
    echo.
    pause
) else (
    echo G++ is already installed
    echo.
)

:: Check and install CMake
echo Checking for CMake...
where cmake >nul 2>&1
if %errorlevel% neq 0 (
    echo Installing CMake...
    echo.
    choco install cmake --installargs 'ADD_CMAKE_TO_PATH=System' -y || (
        echo ERROR: Failed to install CMake
        pause
        exit /b 1
    )
    :: Refresh environment variables
    call refreshenv
    echo CMake installation complete
    echo.
    pause
) else (
    echo CMake is already installed
    echo.
)

echo All requirements checked and installed
echo Current directory: %CD%
echo.
pause

:: Create project structure
echo Creating project structure...
echo.

:: Create directories with full paths
echo Creating directories...
mkdir "%SCRIPT_DIR%src" 2>nul || (
    echo ERROR: Failed to create src directory
    pause
    exit /b 1
)
mkdir "%SCRIPT_DIR%include" 2>nul || (
    echo ERROR: Failed to create include directory
    pause
    exit /b 1
)
mkdir "%SCRIPT_DIR%build" 2>nul || (
    echo ERROR: Failed to create build directory
    pause
    exit /b 1
)
mkdir "%SCRIPT_DIR%lib" 2>nul || (
    echo ERROR: Failed to create lib directory
    pause
    exit /b 1
)

:: Create main.cpp with full path
echo Creating main.cpp...
(
echo #include ^<iostream^>
echo.
echo int main^(^) {
echo     std::cout ^<^< "Hello, World!" ^<^< std::endl;
echo     return 0;
echo }
) > "%SCRIPT_DIR%src\main.cpp" || (
    echo ERROR: Failed to create main.cpp
    echo Current directory: %CD%
    pause
    exit /b 1
)

:: Create CMakeLists.txt with full path
echo Creating CMakeLists.txt...
(
echo cmake_minimum_required^(VERSION 3.10^)
echo.
echo project^(MyProject^)
echo.
echo set^(CMAKE_CXX_STANDARD 17^)
echo set^(CMAKE_CXX_STANDARD_REQUIRED ON^)
echo.
echo add_executable^(${PROJECT_NAME} src/main.cpp^)
echo.
echo target_include_directories^(${PROJECT_NAME} PRIVATE include^)
) > "%SCRIPT_DIR%CMakeLists.txt" || (
    echo ERROR: Failed to create CMakeLists.txt
    pause
    exit /b 1
)

:: Create a basic .gitignore with full path
echo Creating .gitignore...
(
echo build/
echo *.exe
echo *.o
echo .vscode/
) > "%SCRIPT_DIR%.gitignore" || (
    echo ERROR: Failed to create .gitignore
    pause
    exit /b 1
)

:: Create build script with full path
echo Creating build script...
(
echo @echo off
echo.
echo if not exist build mkdir build
echo cd build
echo cmake ..
echo cmake --build .
echo.
echo if errorlevel 1 ^(
echo     echo Build failed!
echo     pause
echo     exit /b 1
echo ^)
echo.
echo echo Build successful!
echo pause
) > "%SCRIPT_DIR%build.bat" || (
    echo ERROR: Failed to create build.bat
    pause
    exit /b 1
)

echo.
echo Project setup complete! Here's what was created in: %SCRIPT_DIR%
echo - src/main.cpp ^(with Hello World program^)
echo - include/ ^(for header files^)
echo - lib/ ^(for libraries^)
echo - build/ ^(for compiled files^)
echo - CMakeLists.txt ^(for CMake build system^)
echo - .gitignore ^(basic Git ignore rules^)
echo - build.bat ^(script to build the project^)
echo.
dir "%SCRIPT_DIR%"
echo.
echo To build your project:
echo 1. Run build.bat
echo 2. The executable will be created in the build directory
echo.
pause