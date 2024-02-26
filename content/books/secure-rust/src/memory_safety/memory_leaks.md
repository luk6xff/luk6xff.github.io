### Example 1: Simple Memory leak
`https://godbolt.org/z/P9qYe1zKf`
* CPP
```cpp
#include <iostream>
#include <memory>

bool is_limit_reached(int speed_limit) {
    int* ptr = new int(10);
    //%// std::unique_ptr<int> ptr = std::make_unique<int>(10); // Correct way to aloacte memory with automatic deallocation
    // Do something with ptr ...
    if (speed_limit > 100) {
        //%// delete ptr; // Correct way to deallocate memory
        return true;
    }
    return false;
    //%// delete ptr; // Correct way to deallocate memory
}

int main() {
    if (is_limit_reached(150)) {
        std::cout << "Speed Limit exceeded." << std::endl;
    }
    return 0;
}
```


* RUST
```rust,editable
fn is_limit_reached(speed_limit: i32) -> bool {
    let ptr = Box::new(10); // Dynamically allocate memory with automatic deallocation
    // Do something with ptr ...

    if speed_limit > 100 {
        return true;
    }
    return false;
    // Memory pointed to by `ptr` is automatically deallocated here
}

fn main() {
    if is_limit_reached(150) {
        println!("Speed Limit exceeded.");
    }
}
```
