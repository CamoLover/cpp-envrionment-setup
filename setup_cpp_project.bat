@echo off
setlocal enabledelayedexpansion

color b

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
)
echo Chocolatey is ready
echo.

:: Check for existing MinGW installation
echo Checking for existing MinGW installation...
where g++ >nul 2>&1
if %errorlevel% equ 0 (
    echo Found existing G++ installation:
    g++ --version
    echo.
    echo MinGW is already installed and ready
) else (
    :: Check common MinGW installation paths
    if exist "C:\MinGW\bin\g++.exe" (
        echo Found MinGW in C:\MinGW
        set "MINGW_PATH=C:\MinGW\bin"
        set "PATH=%MINGW_PATH%;%PATH%"
    ) else if exist "C:\Program Files\mingw-w64\x86_64-8.1.0-posix-seh-rt_v6-rev0\mingw64\bin\g++.exe" (
        echo Found MinGW in Program Files
        set "MINGW_PATH=C:\Program Files\mingw-w64\x86_64-8.1.0-posix-seh-rt_v6-rev0\mingw64\bin"
        set "PATH=%MINGW_PATH%;%PATH%"
    ) else (
        echo No existing MinGW installation found
        echo Installing MinGW...
        choco install mingw --force -y || (
            echo ERROR: Failed to install MinGW
            pause
            exit /b 1
        )
        :: Refresh environment variables
        call refreshenv
        
        :: Add MinGW to PATH
        set "MINGW_PATH=C:\ProgramData\chocolatey\lib\mingw\tools\install\mingw64\bin"
        echo Adding MinGW to PATH: %MINGW_PATH%
        set "PATH=%MINGW_PATH%;%PATH%"
    )
)

:: Verify G++ installation
echo Verifying G++ installation...

@REM Uncomment this if problem during installation
@REM where g++ >nul 2>&1
@REM if %errorlevel% neq 0 (
@REM     echo ERROR: G++ not found in PATH
@REM     echo Current PATH: %PATH%
@REM     pause
@REM     exit /b 1
@REM )

g++ --version || (
    echo ERROR: G++ not working properly
    pause
    exit /b 1
)
echo G++ is ready
echo.

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
)
cmake --version
echo CMake is ready
echo.

:: Ask the user whether to install Visual Studio Code
set "INSTALL_VSCODE="
:ASK_VSCODE
echo Do you want to install Visual Studio Code? (Y/N)
set /p INSTALL_VSCODE="Enter your choice: "
if /I "%INSTALL_VSCODE%"=="Y" (
    echo Checking for existing Visual Studio Code installation...
    where code >nul 2>&1
    if %errorlevel% equ 0 (
        echo Visual Studio Code is already installed.
    ) else (
        echo Installing Visual Studio Code...
        echo.
        powershell -NoProfile -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'https://update.code.visualstudio.com/latest/win32-x64-user/stable' -OutFile vscode-installer.exe" || (
            echo ERROR: Failed to download Visual Studio Code installer
            pause
            exit /b 1
        )
        start /wait vscode-installer.exe /silent || (
            echo ERROR: Failed to install Visual Studio Code
            pause
            exit /b 1
        )
        del vscode-installer.exe
        echo Visual Studio Code is ready
    )
) else if /I "%INSTALL_VSCODE%"=="N" (
    echo Skipping Visual Studio Code installation.
) else (
    echo Invalid choice! Please enter Y or N.
    goto ASK_VSCODE
)

echo.

echo All requirements checked and installed
echo Current directory: %CD%
echo.
pause

:: Create project structure
echo Creating project structure...
echo.

:: Create directories
mkdir "%SCRIPT_DIR%src" 2>nul
mkdir "%SCRIPT_DIR%include" 2>nul
mkdir "%SCRIPT_DIR%build" 2>nul
mkdir "%SCRIPT_DIR%lib" 2>nul

:: Create main.cpp
echo Creating main.cpp...
(
echo #include ^<iostream^>
echo.
echo int main^(^) {
echo     std::cout ^<^< "Hello, World" ^<^< std::endl;
echo     return 0;
echo }
) > "%SCRIPT_DIR%src\main.cpp"

:: Create CMakeLists.txt with explicit compiler settings
echo Creating CMakeLists.txt...
(
echo cmake_minimum_required^(VERSION 3.10^)
echo.
echo project^(MyProject^)
echo.
echo set^(CMAKE_CXX_STANDARD 17^)
echo set^(CMAKE_CXX_STANDARD_REQUIRED ON^)
echo.
echo # Ensure MinGW is used
echo set^(CMAKE_C_COMPILER "gcc"^)
echo set^(CMAKE_CXX_COMPILER "g++"^)
echo.
echo add_executable^(${PROJECT_NAME} src/main.cpp^)
echo.
echo target_include_directories^(${PROJECT_NAME} PRIVATE include^)
) > "%SCRIPT_DIR%CMakeLists.txt"

:: Create .gitignore
echo Creating .gitignore...
(
echo build/
echo *.exe
echo *.o
echo .vscode/
) > "%SCRIPT_DIR%.gitignore"

:: Create build.bat
echo Creating build.bat...
(
echo @echo off
echo setlocal enabledelayedexpansion
echo.
echo color b
echo.
echo :: Get the directory where the batch file is located
echo set "SCRIPT_DIR=%%~dp0"
echo cd /d "%%SCRIPT_DIR%%"
echo.
echo echo Building project in: %%CD%% 
echo echo.
echo.
echo :: Extract project name from CMakeLists.txt
echo for /f "tokens=2 delims=^(^)" %%%%a in ^('findstr /R "^project" "CMakeLists.txt"'^) do ^(
echo     set "PROJECT_NAME=%%%%a"
echo ^)
echo.
echo set "PROJECT_NAME=%%PROJECT_NAME: =%%"
echo.
echo echo Project name is: %%PROJECT_NAME%% 
echo echo.
echo.
echo if not exist "build" mkdir "build"
echo cd build
echo.
echo echo Running CMake configure...
echo cmake -G "MinGW Makefiles" ..
echo if errorlevel 1 ^(
echo     echo ERROR: CMake configuration failed
echo     cd .. 
echo     pause
echo     exit /b 1
echo ^)
echo.
echo echo Building project...
echo cmake --build .
echo if errorlevel 1 ^(
echo     echo ERROR: Build failed
echo     cd .. 
echo     pause
echo     exit /b 1
echo ^)
echo.
echo echo Build successful^^!
echo echo.
echo.
echo :: Run the executable
echo if exist "%%PROJECT_NAME%%.exe" ^(
echo     echo Running the program:
echo     echo =====================
echo     %%PROJECT_NAME%%.exe
echo     echo =====================
echo ^) else ^(
echo     echo Executable not found
echo ^)
echo.
echo cd ..
echo pause
) > "%SCRIPT_DIR%build.bat"

:: Initial build
echo.
echo Performing initial build...
echo.

cd build

echo Running CMake...
cmake -G "MinGW Makefiles" ..
if errorlevel 1 (
    echo ERROR: CMake configuration failed
    cd .. 
    pause
    exit /b 1
)

echo Building project...
cmake --build .
if errorlevel 1 (
    echo ERROR: Build failed
    cd .. 
    pause
    exit /b 1
)

cd ..

echo.
echo Setup complete! You can now:
echo 1. Open the project in Visual Studio Code
echo 2. Use build.bat to rebuild the project
echo 3. Edit the source files in the src directory
echo.

pause
