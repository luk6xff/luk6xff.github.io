### Example 1: Simple Memory Leak
- [GODBOLT](https://godbolt.org/z/beGf1Mn9a)
- [DEMO](https://github.com/luk6xff/luk6xff.github.io/tree/master/content/books/safe_secure_rust/src/memory_safety/memory_leaks)
* CPP
```cpp
#include <iostream>
#include <memory>

bool is_limit_reached(int speed_limit) {

    int current_speed = 0;

    for (int factor = 0; factor < 100; ++factor) {
        //%// std::unique_ptr<int> ptr = std::make_unique<int>(10); // Correct way to aloacte memory with automatic deallocation
        int* ptr = new int(2);
        std::cout << "Allocated memory at address: " << ptr << std::endl;
        current_speed += (factor + *ptr);
        //%// delete ptr; // Correct way to deallocate memory
    }

    int* ptr = new int(10);
    current_speed += *ptr;
    if (current_speed > speed_limit) {
        //%// delete ptr; // Correct way to deallocate memory
        return true;
    }
    return false;
}

int main() {
    if (is_limit_reached(120)) {
        std::cout << "Speed Limit exceeded." << std::endl;
    }
    return 0;
}
```


* RUST
```rust,editable
fn is_limit_reached(speed_limit: i32) -> bool {

    let mut current_speed: i32 = 0;

    for factor in 0..100 {
        let ptr = Box::new(2); // Dynamically allocate memory with automatic deallocation
        current_speed += factor + *ptr;
    }

    let ptr = Box::new(10); // Dynamically allocate memory with automatic deallocation
    current_speed += *ptr;
    if current_speed > speed_limit {
        return true;
    }
    return false;
    // Memory pointed to by `ptr` is automatically deallocated here
}

fn main() {
    if is_limit_reached(120) {
        println!("Speed Limit exceeded.");
    }
}
```
