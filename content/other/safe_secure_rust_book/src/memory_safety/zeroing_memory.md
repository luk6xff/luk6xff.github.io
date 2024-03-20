# Securely Erasing Sensitive Data from Memory
When developing applications that handle sensitive information—such as passwords, cryptographic keys, or personal data—it is crucial to ensure that this data is securely erased from memory once it is no longer needed. Simply overwriting variables or deallocating memory is often insufficient due to the risk of data remnants persisting in memory locations, which could potentially be accessed by unauthorized parties or through malicious exploits.

### The Challenge of Compiler Optimizations
One significant challenge in securely erasing sensitive data from memory is the impact of compiler optimizations. Modern compilers are designed to improve the efficiency and performance of code, which may include optimizing away seemingly redundant operations such as overwriting a memory region that is about to be deallocated. Consequently, attempts to zero out memory containing sensitive data can be inadvertently removed during the compilation process, leaving the data vulnerable.

### Example 1:
[GODBOLT](https://godbolt.org/z/fW7jvjf8e)

* RUST
```rust,editable
#// use std::ptr::write_volatile;
use zeroize::Zeroize;

static mut PTR: *const u8 = std::ptr::null();

fn print_ptr_memory_address(label: u8) {
    unsafe {
        println!("{label}) Pointer memory address: {:p}", PTR);
        println!("{label}) SensitiveDataMemory: {:x?}", core::slice::from_raw_parts(PTR, 32));
    }
}

struct SensitiveData {
    password: [u8; 32], // Sensitive data
}

impl SensitiveData {
    pub fn new(password: &[u8]) -> Self {
        let mut data = SensitiveData { password: [0; 32] };
        let len = password.len().min(data.password.len());
        data.password[..len].copy_from_slice(&password[..len]);
        data
    }
}

impl Drop for SensitiveData {
    fn drop(&mut self) {
        println!("Zeroing memory");
        #// unsafe {
        #//    write_volatile(&mut self.password, [0u8; 32]);
        #// }
        self.password.zeroize()
    }
}

fn process_password(pwd: &[u8]) {
    let data = SensitiveData::new(pwd);
    unsafe {
        PTR = data.password.as_ptr();
    }
    // Simulate operations on the sensitive data
    println!("Processing sensitive data...");
    print_ptr_memory_address(1);
}

fn do_other_work() {
    println!("Doing other work...");
    print_ptr_memory_address(3);
}

pub fn main() {
  process_password(b"abcdefghijklmnopqrstuvwxyz123456");
  print_ptr_memory_address(2);
  do_other_work();
}
```

* CPP
```cpp
#include <iostream>
#include <cstring>
#include <cstdint>
#include <cstdio>
#include <functional>

static uint8_t* ptr = nullptr;

void print_ptr_memory_address(uint8_t label) {
    printf("%d) Pointer memory address: %p\n", label, ptr);
    printf("%d) SensitiveDataMemory: [", label);
    for (size_t i = 0; i < 32; ++i) {
        printf("%02x ", ptr[i]);
    }
    printf("]\n");
}

struct SensitiveData {
    char password[32]; // Sensitive data

    SensitiveData(const char* pwd) {
        strncpy(password, pwd, sizeof(password) - 1);
        password[sizeof(password) - 1] = '\0';
    }

    ~SensitiveData() {
        std::cout << "Zeroing memory" << std::endl;
        memset(password, 0, sizeof(password));

        //% volatile char *p = password;
        //% for (size_t i = 0; i < sizeof(password); i++) {
        //%     *(p + i) = 0;
        //% }
    }
};

void process_password(const char* pwd) {
    SensitiveData data(pwd);
    ptr = reinterpret_cast<uint8_t*>(data.password);
    // Simulate operations on the sensitive data
    std::cout << "Processing sensitive data..." << std::endl;
    print_ptr_memory_address(1);

}

void do_other_work() {
    std::cout << "Doing other work..." << std::endl;
    print_ptr_memory_address(3);
}

int main() {
    process_password("abcdefghijklmnopqrstuvwxyz123456");
    print_ptr_memory_address(2);
    do_other_work();
    return 0;
}
```
