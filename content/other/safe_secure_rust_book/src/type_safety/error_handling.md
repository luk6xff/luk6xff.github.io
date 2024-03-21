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
* CPP - In C++, exceptions provide a way to react to exceptional circumstances (like runtime errors) in programs by transferring control to special functions called handlers.
```cpp
#include <iostream>
#include <stdexcept>

void riskyFunction() {
    bool errorOccurred = true; // Simulate an error
    if (errorOccurred) {
        throw std::runtime_error("Failed to execute risky operation");
    }
}

int main() {
    try {
        riskyFunction();
    } catch (const std::runtime_error& err) {
        std::cout << "Caught an error: " << err.what() << std::endl;
    }
    return 0;
}
```

* RUST - Rust uses the `Result` type for error handling, which can either be `Ok`, indicating success, or `Err`, indicating an error.
```rust,editable
fn risky_operation() -> Result<(), &'static str> {
    let error_occurred = true; // Simulate an error
    if error_occurred {
        return Err("Failed to execute risky operation");
    }
    Ok(())
}

fn main() {
    match risky_operation() {
        Ok(_) => println!("Operation succeeded."),
        Err(e) => println!("Caught an error: {}", e),
    }
}
```

### Example 2: Exception Handling for File I/O
[GODBOLT](https://godbolt.org/z/dTEss91jK)
* CPP
```cpp
#include <iostream>
#include <fstream>
#include <stdexcept>

void readFile(const std::string& filePath) {
    std::ifstream file(filePath);
    if (!file) {
        throw std::runtime_error("Unable to open file");
    }
    std::cout << "File opened successfully" << std::endl;
    // Read file contents...
}

int main() {
    try {
        readFile("example.txt");
    } catch (const std::runtime_error& err) {
        std::cout << "Caught an error: " << err.what() << std::endl;
    }
    return 0;
}
```
There is a similar mechanism to rust `Result` available since C++23: [std::unexpected](https://en.cppreference.com/w/cpp/utility/expected).

* RUST
```rust,editable
use std::fs::File;
use std::io::{self, Read};

fn read_file(file_path: &str) -> Result<String, io::Error> {
    let mut file = File::open(file_path)?;
    let mut contents = String::new();
    file.read_to_string(&mut contents)?;
    Ok(contents)
}

fn main() {
    match read_file("example.txt") {
        Ok(contents) => println!("File contents: {}", contents),
        Err(e) => println!("Caught an error: {}", e),
    }
}
```


### Example 3: Result
* RUST
```rust,editable
#[derive(Debug)]
enum CopyError {
    LengthMismatch { src_len: usize, dst_len: usize },
}

fn safe_copy_from_slice(dst: &mut [u8], src: &[u8]) -> Result<(), CopyError> {
    if dst.len() != src.len() {
        Err(CopyError::LengthMismatch {
            src_len: src.len(),
            dst_len: dst.len()
        })
    } else {
        dst.copy_from_slice(src);
        Ok(())
    }
}

fn main() {
    let input = "This is way too long for the buffer".as_bytes();
    let mut buf = [0u8; 10];

    match safe_copy_from_slice(&mut buf, &input[0..buf.len()]) {
        Ok(()) => println!("Copy successful: {:?}", &buf),
        Err(CopyError::LengthMismatch { src_len, dst_len }) => {
            println!("Failed to copy: source length ({}) does not match destination length ({}).", src_len, dst_len);
        }
    }
}
```


### Example 4: Option
The Option type in Rust and its equivalent pattern in C++ are used to represent the possibility of absence of a value
* CPP
```cpp
#include <iostream>
#include <optional>

std::optional<double> divide(double numerator, double denominator) {
    if (denominator == 0.0) {
        return std::nullopt;
    } else {
        return numerator / denominator;
    }
}

int main() {
    auto result = divide(10.0, 2.0);
    if (result.has_value()) {
        std::cout << "Result: " << result.value() << std::endl;
    } else {
        std::cout << "Cannot divide by zero" << std::endl;
    }
}
```
* RUST
```rust,editable
fn divide(numerator: f64, denominator: f64) -> Option<f64> {
    if denominator == 0.0 {
        None
    } else {
        Some(numerator / denominator)
    }
}

fn main() {
    let result = divide(10.0, 2.0);
    match result {
        Some(value) => println!("Result: {}", value),
        None => println!("Cannot divide by zero"),
    }
}
```


### Example 5: Option - Fetching a Config Value
* CPP
```cpp
#include <iostream>
#include <optional>
#include <string>

std::optional<std::string> get_config_value(const std::string& key) {
    if (key == "timeout") {
        return "100";
    } else {
        return std::nullopt;
    }
}

int main() {
    auto timeout = get_config_value("timeout");
    if (timeout.has_value()) {
        std::cout << "Timeout is set to " << timeout.value() << std::endl;
    } else {
        std::cout << "Timeout not specified" << std::endl;
    }
}
```
* RUST
```rust,editable
fn get_config_value(key: &str) -> Option<String> {
    match key {
        "timeout" => Some("100".to_string()),
        _ => None,
    }
}

fn main() {
    let timeout = get_config_value("timeout");
    match timeout {
        Some(value) => println!("Timeout is set to {}", value),
        None => println!("Timeout not specified"),
    }
}
```
