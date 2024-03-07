#/bin/sh

# CPP
mkdir -p build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Debug
make
./is_shared_pointer_thread_safe_debug


# # RUST
# cargo run
# valgrind --leak-check=full -s ../target/debug/main
