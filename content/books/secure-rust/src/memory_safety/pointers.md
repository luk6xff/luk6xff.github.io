### Example 1: Dangling Pointer
* CPP
```cpp
#include <iostream>

int main() {
    int* a = nullptr;
    {
        int b = 5;
        a = &b;
    }
    // At this point, b goes out of scope, but the memory allocated to it does not
    std::cout << "a: " << *a << std::endl;

    return 0;
}
```


```rust,editable
fn main() {
    let a;
    {
        let b = 5;
        a = &b;
    }
    println!("a: {}", r);
}
```


### Example 2: Null Pointer Dereference
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
        None => println!("Received a null pointer (None value)."),
    }
}

fn main() {
    let ptr: Option<&i32> = None;
    process(ptr);
}
```



### Example 3: Dangling Pointer
* CPP
```cpp
#include <cstdio>
#include <cstdlib>

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
    value
}

fn main() {
    let val = dangling_pointer();
    println!("{}", val); // Safe: `val` owns the data directly.
}
```
