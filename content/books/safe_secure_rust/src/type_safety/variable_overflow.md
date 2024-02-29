# Variable Overflow

### Example 1: Simple overflow
[GODBOLT](https://godbolt.org/z/bbW69EG8x)
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
    let c: u8 = a + b;
    println!("c: {}", c);
}
```
