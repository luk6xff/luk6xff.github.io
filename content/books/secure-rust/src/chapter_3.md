# Type Safety and Error Handling



### Example 1: Exception Handling
* CPP - C++ uses exceptions for error handling, which can lead to performance overhead and unexpected control flow.
```cpp
#include <iostream>
#include <stdexcept>

void might_go_wrong() {
    throw std::runtime_error("Something went wrong");
}

int main() {
    try {
        might_go_wrong();
    } catch (const std::runtime_error& e) {
        std::cout << e.what() << std::endl;
    }
}
```
* RUST - `Result` and `Option`
```rust,editable
fn might_go_wrong() -> Result<(), String> {
    Err(String::from("Something went wrong"))
}

fn main() {
    match might_go_wrong() {
        Ok(_) => println!("It worked!"),
        Err(e) => println!("Error: {}", e),
    }
}
```