#/bin/sh

# CPP
sudo apt install -y valgrind

mkdir -p build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Debug
#cmake .. -DCMAKE_BUILD_TYPE=Debug
make

valgrind --leak-check=full -s ./format_string_debug

# RUST
cargo run
valgrind --leak-check=full -s ../target/debug/format_string
