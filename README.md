# C++ Projects Collection

This repository contains a collection of C++ projects along with automated setup and build scripts for Windows environments.

[![](https://visitcount.itsvg.in/api?id=CPPsetup&label=Repo%20View&color=6&icon=5&pretty=true)](https://visitcount.itsvg.in)

## Projects Overview

### 1. Number Guessing Game
An interactive game where:
- Computer picks a random number between 0 and 100
- Player makes guesses
- Computer provides "higher" or "lower" hints
- Game tracks the number of guesses until correct

### 32. Mystery Island
A text-based adventure game where players navigate through an interactive story.

## Setup Instructions

1. **Initial Setup**
   - Clone this repository
   - Right-click `setup_cpp_project.bat` and select "Run as administrator"
   - The script will:
     - Install necessary dependencies
     - Generate required configuration files
     - Set up the C++ development environment

2. **Building and Running Projects**
   - Execute `build.bat` to:
     - Compile all projects
     - Run the selected program automatically

## Project Structure
```
cpp-projects/
├── setup_cpp_project.bat    # Environment setup script
├── test/
│   ├── test/         
│   │   └── main.cpp         # Hello World program
│   └── build.bat            # Build and execution script
├── NumberGuessing/     
│   │   └── main.cpp         # Number Guessing game program
│   └── build.bat            # Build and execution script
└── MysteryIsland/      
│   │   └── main.cpp         # Mysteryisland program
│   └── build.bat            # Build and execution script
```

## Requirements
- Windows operating system
- Administrator privileges (for initial setup)

## Building Individual Projects
Each project can be built separately by navigating to its directory and running there:
```batch
build.bat
```

## Contributing
Feel free to contribute to any of the projects:
1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

