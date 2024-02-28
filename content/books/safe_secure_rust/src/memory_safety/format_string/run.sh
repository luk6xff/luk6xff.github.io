#/bin/sh

# CPP
rm -rf build
mkdir -p build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Debug
#cmake .. -DCMAKE_BUILD_TYPE=Release
make

# VALGRIND
#sudo apt install -y valgrind
#valgrind --leak-check=full -s ./format_string_debug

# GDB
#https://github.com/hugsy/gef-legacy/blob/master/docs/commands.md
# gdb -q format_string_debug
# #---
# disassemble main
# b *main +46
# r


# PWNTOOLS
#source venv/bin/activate
#python -m pip install --upgrade pwntools

# # RUST
# cargo run
# valgrind --leak-check=full -s ../target/debug/format_string
