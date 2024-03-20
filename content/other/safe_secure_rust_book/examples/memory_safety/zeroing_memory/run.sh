#/bin/sh
## gdb
# disassemble process_password
# b *process_password+140
# r


# CPP
rm -rf build
mkdir -p build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make


# RUST
cargo run
# gdb target/debug/zeroing_memory
# r  (First run to get the address of process_password)
#
# 1) -------------------
# info files
# >>> (Search for .text section)
# set logging on
# disassemble 0x000055555555a060, 0x0000555555598c36
# >>> Search for process_password ret instruction in gdb.txt
# OR
# 2) -------------------
# info functions .*process_password
# disassemble zeroing_memory::process_password
#
# b *(&zeroing_memory::process_password+1220)
# b *(&zeroing_memory::do_other_work)
# r
# p data
# p &data
# >>> Store the `data` address: 0x7ffff7ffe1d0
# x/30x &data
# c
# x/30x 0x7ffff7ffe1d0
