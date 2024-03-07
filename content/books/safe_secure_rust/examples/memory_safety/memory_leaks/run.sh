#/bin/sh

# CPP
sudo apt install -y valgrind

mkdir -p build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Debug
#cmake .. -DCMAKE_BUILD_TYPE=Debug
make

valgrind --leak-check=full -s ./memory_leaks_debug

# RUST
cargo run
valgrind --leak-check=full -s ../target/debug/memory_leaks
