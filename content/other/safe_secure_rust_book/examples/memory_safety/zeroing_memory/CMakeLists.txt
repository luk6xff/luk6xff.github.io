cmake_minimum_required(VERSION 3.10) # Specify the minimum version of CMake

project(zeroing_memory)

# Create an executable from the specified source file
add_executable(zeroing_memory zeroing_memory.cpp)

# Set the C++ compiler flags to use optimization level O3
# Note: CMAKE_CXX_FLAGS_RELEASE is used to ensure that O3 is applied only when building in release mode
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -O3")
