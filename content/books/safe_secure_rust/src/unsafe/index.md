# Safe Abstraction of Unsafe Code

## Introduction

Writing safe abstractions over unsafe code is a common pattern in systems programming, where performance and control over low-level details are critical. Both C++ and Rust allow programmers to write such code, but they approach safety, unsafety, and abstraction differently. C++ offers a lot of freedom with implicit trust in the programmer, while Rust provides a more structured approach, making unsafe operations explicit and encapsulating them within safe abstractions.
Rust is designed to be safe by default, it acknowledges that unsafe operations are sometimes necessary for low-level systems programming. Rust requires that such operations be explicitly marked with the `unsafe keyword`, isolating unsafe code and making it easier to review and audit.

## C++: Managing Safety Manually

In C++, safety often relies on the programmer's discipline and conventions. The language offers mechanisms like RAII (Resource Acquisition Is Initialization) to manage resources safely but leaves it to the programmer to use these mechanisms consistently.

### Example: Manual Memory Management

```cpp
#include <iostream>

class SafeIntArray {
private:
    int* array;
    size_t size;

public:
    SafeIntArray(size_t size): size(size), array(new int[size]) {}

    ~SafeIntArray() {
        delete[] array;
    }

    int& operator[](size_t index) {
        // Bounds check for safety
        if (index >= size) throw std::out_of_range("Index out of range");
        return array[index];
    }
};

int main() {
    SafeIntArray arr(10);
    arr[0] = 42; // Safe access
    std::cout << arr[0] << std::endl;

    // arr[10] = 3; // This would throw an exception, preventing undefined behavior
    return 0;
}
```

This C++ class `SafeIntArray` is a simple example of providing a safe interface to unsafe raw pointer operations. It manually manages memory with `new` and `delete`, encapsulating unsafe array access within a class that checks bounds.

## Rust: Explicit Unsafe with Safe Abstractions

Rust requires any unsafe operation to be explicitly marked with the `unsafe` keyword. This makes it clear which parts of the codebase could potentially lead to undefined behavior, encouraging the encapsulation of unsafe blocks within safe interfaces.

### Example: Safe Abstraction Over Unsafe Code

```rust, editable
struct SafeIntArray {
    array: Vec<i32>,
}

impl SafeIntArray {
    fn new(size: usize) -> Self {
        SafeIntArray { array: vec![0; size] }
    }

    fn set(&mut self, index: usize, value: i32) {
        // Safe due to Rust's ownership and borrowing rules
        if index >= self.array.len() {
            panic!("Index out of range");
        }
        // Unsafe block encapsulated within a safe function
        unsafe {
            *self.array.as_mut_ptr().add(index) = value;
        }
    }

    fn get(&self, index: usize) -> i32 {
        if index >= self.array.len() {
            panic!("Index out of range");
        }
        // Unsafe block encapsulated within a safe function
        unsafe {
            *self.array.as_ptr().add(index)
        }
    }
}

fn main() {
    let mut arr = SafeIntArray::new(10);
    arr.set(0, 42); // Safe API
    println!("{}", arr.get(0));

    // arr.set(10, 3); // This would panic at runtime, preventing undefined behavior
}
```

In this Rust example, `SafeIntArray` provides a safe interface to an underlying vector. Rust's vector provides safety guarantees, but for demonstration, we've used unsafe operations to manipulate memory directly, simulating what might be necessary for interfacing with low-level system components or optimizing critical paths.

## Conclusion

Both C++ and Rust offer mechanisms to write high-performance, low-level code safely. C++ trusts the programmer to manage safety, while Rust enforces safety at the language level, requiring any escape from these guarantees to be explicit. This explicitness in Rust aids in creating clear boundaries between safe and unsafe code, making it easier to maintain and audit for safety while still allowing for the performance benefits of low-level programming.
