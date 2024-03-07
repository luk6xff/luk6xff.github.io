cmake_minimum_required(VERSION 3.10) # Specify the minimum version of CMake

set(name format_string)

project(${name})

# Release build configuration
add_executable(${name}_release ${name}.cpp)
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -O3")

# Debug build configuration
add_executable(${name}_debug ${name}.cpp)
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -g -O0")
