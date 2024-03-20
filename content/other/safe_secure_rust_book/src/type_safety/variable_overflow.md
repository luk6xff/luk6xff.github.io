# Variable Overflow

### Example 1:
[GODBOLT](https://godbolt.org/z/T14Gx5vcj)
* CPP
```cpp
#include <iostream>
#include <cstdint>

int main() {
    uint8_t a = 200;
    uint8_t b = 100;
    uint8_t c = a + b;

    std::cout << "c: " << static_cast<int>(c) << std::endl;

    return 0;
}
```

* RUST
```rust,editable
pub fn main() {
    let a: u8 = 200;
    let b: u8 = 100;
    // Default addition, which will panic in debug mode due to overflow
    // In release mode, this will wrap around according to Rust's overflow semantics
    let c: u8 = a + b;
    println!("c: (default_add):{}", c);

    let c = a.wrapping_add(b); // Replaces the overflow line with safe wrapping behavior
    println!("c (wrapping_add): {}", c);

    // Checked addition - returns an Option, None if there's overflow
    match a.checked_add(b) {
        Some(value) => println!("c (checked_add): {}", value),
        None => println!("c (checked_add): Overflow detected"),
    }

    // Saturating addition - saturates at the numeric bounds instead of overflowing
    let c_saturating = a.saturating_add(b);
    println!("c (saturating_add): {}", c_saturating);
}
```
