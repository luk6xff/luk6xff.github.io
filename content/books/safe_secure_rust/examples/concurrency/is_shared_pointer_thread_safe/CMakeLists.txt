cmake_minimum_required(VERSION 3.10) # Specify the minimum version of CMake

set(name is_shared_pointer_thread_safe)

project(${name})

# Release build configuration
add_executable(${name}_release main.cpp)
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -O3")

# Debug build configuration
add_executable(${name}_debug main.cpp)
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -g -O0")
