#!/bin/bash

# Format code
echo "Formatting code..."
cargo fmt

# Lint code
echo "Linting code..."
cargo clippy -- -D warnings

# Run app
echo "Running app..."
cargo run -- run.sh

# Run tests
echo "Running tests..."
cargo test

# Set up rust nightly version
rustup default nightly
# Run fuzzing (Note: This will run indefinitely until stopped or a crash is found)
echo "Starting fuzzing..."
cargo fuzz run fuzz_target_1
cargo fuzz run fuzz_wc

# Set back to stable version
rustup default stable
