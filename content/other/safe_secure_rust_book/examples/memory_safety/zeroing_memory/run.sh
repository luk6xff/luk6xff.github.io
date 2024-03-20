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
./zeroing_memory
# gdb build/zeroing_memory
# r  (First run to get the address of process_password)
# b *(&print_ptr_memory_address)
# >>> Get buffer address from the stack
# gef➤  x/30x $rsp-88
#       0x7fffffffd570: 0x64636261

# RUST
cd ..
cargo run
# gdb target/debug/zeroing_memory
# r  (First run to get the address of process_password)
#
# 1) -------------------
# info files
# >>> (Search for .text section)
# set logging on
# disassemble 0x000055555555a060, 0x0000555555597f96
# >>> Search for print_ptr_memory_address function in gdb.txt
# OR
# 2) -------------------
# info functions .*process_password
# disassemble zeroing_memory::process_password
#
# b *(&zeroing_memory::print_ptr_memory_address)
# r
# p data
# p &data
# >>> Store the `data` address: 0x00007fffffffd3f0
# x/30x &data
# c
# x/30x 00x00007fffffffd3f0
