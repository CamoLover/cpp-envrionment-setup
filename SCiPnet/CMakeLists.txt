cmake_minimum_required(VERSION 3.10)

project(SCiPnet)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Find the resource compiler (usually rc for Windows)
if(WIN32)
    set(RESOURCE_COMPILER "rc")
    set(RESOURCE_FILE "src/resource.rc")
endif()

add_executable(${PROJECT_NAME} 
    src/main.cpp
    ${RESOURCE_FILE}
)

target_include_directories(${PROJECT_NAME} PRIVATE include)

# Optionally set the output directory for the executable
set_target_properties(${PROJECT_NAME} PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/
)
