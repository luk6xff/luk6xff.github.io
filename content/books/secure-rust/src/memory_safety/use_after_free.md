### Example 1: Use After Free
* CPP - This code compiles but leads to undefined behavior by accessing memory that has been freed.
```cpp
#include <iostream>

int main() {
    int *ptr = new int(10);
    delete ptr;
    // Undefined behavior: use after free
    std::cout << *ptr << std::endl;
    return 0;
}
```
* RUST
```rust,editable
fn main() {
    let ptr = Box::new(10);
    // Memory is automatically cleaned up when `ptr` goes out of scope
    // Attempting to use `ptr` after this point would result in a compile-time error
    println!("{}", ptr);
    // Rust's ownership system prevents "use after free" by design
}
```
