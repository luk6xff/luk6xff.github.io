#/bin/sh
set -x

cd ffi_example

rm -rf target

cargo build
cargo run
