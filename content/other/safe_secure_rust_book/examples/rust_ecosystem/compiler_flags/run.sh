#!/bin/sh

# Exit script on first error
set -e

# Check for subcommand
if [ "$#" -ne 1 ]; then
    echo "Usage: ./run.sh [asan|thread]"
    exit 1
fi

SUBCOMMAND=$1

# Set up rust nightly version
rustup default nightly
rustup component add rust-src --toolchain nightly-x86_64-unknown-linux-gnu

case $SUBCOMMAND in
    asan)
        echo "Building and running app with AddressSanitizer..."
        export RUSTFLAGS=-Zsanitizer=address RUSTDOCFLAGS=-Zsanitizer=address
        cargo run --features asan -Zbuild-std --target x86_64-unknown-linux-gnu
        ;;
    thread)
        echo "Building and running app with ThreadSanitizer..."
        export RUSTFLAGS=-Zsanitizer=thread RUSTDOCFLAGS=-Zsanitizer=thread
        cargo run --features thread -Zbuild-std --target x86_64-unknown-linux-gnu
        ;;
    *)
        echo "Invalid subcommand: $SUBCOMMAND"
        echo "Usage: ./run.sh [asan|thread]"
        ;;
esac

# Set back to stable version
rustup default stable
