## Rust's Tiered Error Handling: A Technical Overview

In Rust, error handling is designed to be both **explicit** and **flexible**. It uses a tiered approach based on the severity and recoverability of errors, offering different mechanisms for each level:

**1. Option:**

* **Purpose:** Represents a value that may or may not be present.
* **Use cases:** Ideal for situations where a value might be missing due to user input, network issues, or optional data structures.
* **Example:** Checking if a file exists using `fs::metadata(path).ok()`.

**2. Result:**

* **Purpose:** Represents either a successful outcome (Ok) or an error (Err).
* **Use cases:** Handling recoverable errors like I/O operations, parsing, or database interactions.
* **Example:** Reading data from a file using `fs::read_to_string(path).expect("Failed to read file")`.

**3. Panic:**

* **Purpose:** Signals an unrecoverable error that requires program termination.
* **Use cases:** Internal logic errors, resource exhaustion, or unexpected system failures.
* **Example:** Panicking with `panic!("Invalid data format")` when encountering corrupted data.

**4. Program termination:**

* **Purpose:** Occurs due to catastrophic events like memory exhaustion or segmentation faults.
* **Use cases:** Unforeseen circumstances beyond the program's control.
* **Example:** Out-of-memory error leading to program termination.

**Benefits:**

* **Clarity:** Explicit error handling improves code readability and maintainability.
* **Safety:** Catching errors early prevents them from propagating and causing further issues.
* **Flexibility:** Developers can choose the appropriate mechanism based on the error's severity and recoverability.
* **Performance:** Rust's error handling is designed to be efficient and have minimal runtime overhead.

**Additional points:**

* Rust's ownership system and type system also play a crucial role in preventing and handling errors.
* The `match` expression and the `?` operator provide convenient ways to work with `Result` values.
* For custom error types, you can define your own `enum` variants and implement the `Error` trait.


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



### Example 2: Option
-> RUST
```rust,editable
fn divide(numerator: f64, denominator: f64) -> Option<f64> {
    if denominator == 0.0 {
        None
    } else {
        Some(numerator / denominator)
    }
}
```
