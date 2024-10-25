cmake_minimum_required(VERSION 3.10)

project(MyProject)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Find the resource compiler (usually rc for Windows)
if(WIN32)
    set(RESOURCE_COMPILER "rc")
    set(RESOURCE_FILE "src/resource.rc")
endif()

# Add the resource file to the executable
add_executable(${PROJECT_NAME} 
    src/main.cpp
    src/Character.cpp
    ${RESOURCE_FILE}  # Include the resource file here
)

target_include_directories(${PROJECT_NAME} PRIVATE include)

# Optionally set the output directory for the executable
set_target_properties(${PROJECT_NAME} PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/
)
