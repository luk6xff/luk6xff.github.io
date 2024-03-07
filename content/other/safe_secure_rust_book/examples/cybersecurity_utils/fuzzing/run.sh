#!/bin/bash

# Format code
echo ">>>>>>>>>>> Formatting code..."
cargo fmt

# Lint code
echo ">>>>>>>>>>> Linting code..."
cargo clippy -- -D warnings

# Run app
echo ">>>>>>>>>>> Running app..."
cargo run -- run.sh

# Run tests
echo ">>>>>>>>>>> Running tests..."
cargo test

# Run fuzzers
echo ">>>>>>>>>>> Running fuzzing..."

# cargo-fuzz
echo "Running fuzzing with carg-fuzz (libFuzzer - https://llvm.org/docs/LibFuzzer.html)..."
# Set up rust nightly version
rustup default nightly
# Run fuzzing (Note: This will run indefinitely until stopped or a crash is found)
echo "Starting fuzzing..."
timeout 30s cargo fuzz run fuzz_wc_tool
# Set back to stable version
rustup default stable

# cargo-afl
# echo "Running fuzzing with cargo-afl (AFL++ - https://github.com/AFLplusplus/AFLplusplus)..."
# cd wc-tool-fuzz-afl-target
# cargo afl build
# export AFL_I_DONT_CARE_ABOUT_MISSING_CRASHES=1
# export AFL_SKIP_CPUFREQ=1
# # Create some input data
# mkdir -p in
# dd if=/dev/urandom of=in/random_bytes_file bs=10k count=1
# # Run fuzzing (Note: This will run indefinitely until stopped or a crash is found)
# echo "Starting fuzzing..."
# timeout 30s cargo afl fuzz -i in -o out ../target/debug/wc-tool-fuzz-afl-target
