# Buffer Overflow



### Example 1: Buffer Overflow
* CPP - A classic buffer overflow using an array. This code compiles, but accessing arr[5] is undefined behavior,leading to a potential security vulnerability.
```cpp
#include <iostream>

int main() {
    int arr[5] = {1, 2, 3, 4, 5};
    // Accidental buffer overflow
    for (int i = 0; i <= 5; i++) {
        std::cout << arr[i] << std::endl;
    }
    return 0;
}
```
* RUST - This code will not compile, as the compiler checks array bounds at compile time and prevents out-of-bounds access.
```rust,editable
fn main() {
    let arr = [1, 2, 3, 4, 5];
    // Compile-time error for out-of-bounds access
    for i in 0..=5 {
        println!("{}", arr[i]);
    }
}
```


### Example 2: Buffer Overflow
* C
```c
#include <stdio.h>
#include <string.h>

int main() {
    char buf[10];.
    strcpy(buf, "This is way too long for the buffer");
    printf("%s\n", buf);
    return 0;
}
```
* RUST
```rust,editable
fn main() {
    let mut buf = [0u8; 10];
    let input = "This is way too long for the buffer".as_bytes();
    buf.copy_from_slice(&input[0..buf.len()]); // Truncates safely
    println!("{:?}", &buf);
}
```


### Example 3: Null Pointer Dereference
* CPP
```cpp
#include <stdio.h>

void process(int* ptr) {
    // Unsafe: dereferencing a null pointer leads to undefined behavior.
    printf("%d\n", *ptr);
}

int main() {
    int* ptr = NULL;
    process(ptr);
    return 0;
}
```
* RUST
```rust,editable
fn process(ptr: Option<&i32>) {
    match ptr {
        Some(val) => println!("{}", val),
        None => println!("Received a null pointer."),
    }
}

fn main() {
    let ptr: Option<&i32> = None;
    process(ptr);
}
```


### Example 4: Use After Free
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


### Example 5: Dangling Pointer LU_TODO!!!!!!!!
* CPP
```cpp
#include <stdio.h>
#include <stdlib.h>

int* dangling_pointer() {
    int value = 42;
    return &value; // Returning address of the local variable, which will be deallocated
}

int main() {
    int* ptr = dangling_pointer();
    printf("%d\n", *ptr); // Undefined behavior: accessing a deallocated stack frame
    return 0;
}
```
* RUST
```rust,editable
fn dangling_pointer() -> i32 {
    let value = 42;
    value // Rust allows returning the value directly, avoiding dangling pointers.
}

fn main() {
    let val = dangling_pointer();
    println!("{}", val); // Safe: `val` owns the data directly.
}
```
