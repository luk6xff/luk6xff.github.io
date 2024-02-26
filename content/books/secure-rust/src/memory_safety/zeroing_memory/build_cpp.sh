#/bin/sh

mkdir -p build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make

## gdb
# disassemble processPassword
# b *processPassword+140
# r
