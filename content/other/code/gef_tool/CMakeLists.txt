cmake_minimum_required(VERSION 3.10) # Specify the minimum version of CMake

set(name "credentials_demo")

project(${name})

# Debug build configuration
add_executable(${name} ${name}.cpp)
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -g -O0 -fno-stack-protector -no-pie -fno-PIE -z execstack")

# add_executable(${name} ${name}.c)
# set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -g -O0 -fno-stack-protector -no-pie -fno-PIE -z execstack")
