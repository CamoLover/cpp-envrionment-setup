@echo off

if not exist build mkdir build
cd build
cmake ..
cmake --build .

if errorlevel 1 (
    echo Build failed
    pause
    exit /b 1
)

echo Build successful
pause
