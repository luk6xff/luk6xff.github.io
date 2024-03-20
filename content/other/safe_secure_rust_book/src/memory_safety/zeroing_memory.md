# Zero out memory of sensitive data after use
Variables containing sensitive data must be zeroed out aer use, using functions that
will not be removed by the compiler optimizations, like std::ptr::write_volatile
or the zeroize crate.

### Example 1:
[GODBOLT](https://godbolt.org/z/fW7jvjf8e)

* RUST
```rust,editable
use std::ptr::write_volatile;
use zeroize::Zeroize;

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
        // #unsafe {
        // #    write_volatile(&mut self.password, [0u8; 32]);
        // #}
        self.password.zeroize()
    }
}

fn process_password(pwd: &[u8]) {
    let data = SensitiveData::new(pwd);
    // Simulate operations on the sensitive data
    println!("Processing sensitive data");
}

pub fn main() {
  process_password(b"supersecret")
}
```

* CPP
```cpp
#include <iostream>
#include <cstring>
#include <cstdint>
#include <functional>

struct SensitiveData {
    char password[32]; // Sensitive data

    SensitiveData(const char* pwd) {
        strncpy(password, pwd, sizeof(password) - 1);
        password[sizeof(password) - 1] = '\0';
    }

    ~SensitiveData() {
        std::cout << "Zeroing memory" << std::endl;
        memset(password, 0, sizeof(password));
        //%volatile char *p = password;
        //%for (size_t i = 0; i < sizeof(password); i++) {
        //%    *(p + i) = 0;
        //%}
    }
};

void process_password(const char* pwd) {
    SensitiveData data(pwd);
    // Simulate operations on the sensitive data
    std::cout << "Processing sensitive data" << std::endl;
}

int main() {
    process_password("supersecret");
    return 0;
}
```
