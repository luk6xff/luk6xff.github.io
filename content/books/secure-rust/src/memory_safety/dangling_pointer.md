### Example 1: Null Pointer Dereference
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



### Example 2: Dangling Pointer LU_TODO!!!!!!!!
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
