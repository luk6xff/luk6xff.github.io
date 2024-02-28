### Example 1: Dangling Pointer
[GODBOLT](https://godbolt.org/z/bbW69EG8x)
* CPP
```cpp
#include <iostream>

int main() {
    int* a = nullptr;
    {
        int b = 5;
        a = &b;
    }
    int c = 10;
    // At this point, b goes out of scope, but the memory allocated to it does not
    std::cout << "a: " << *a << std::endl;

    return 0;
}
```

* RUST
```rust,editable
pub fn main() {
    let a: Box<i32>;
    {
        let b = Box::new(5);
        a = b; // Move the ownership of the Box<i32> from 'b' to 'a'
    } // 'b' goes out of scope here, but its value is safely stored in 'a'

    let _c = 10;
    // At this point, 'b' has gone out of scope, but its value is safely stored in 'a'
    println!("a: {}", a);
}


#// pub fn main() {
#//     let a: *const i32;
#//     {
#//         let b = 5;
#//         a = &b as *const i32; // Assign the address of 'b' to 'a'
#//     } // 'b' goes out of scope here, but the memory allocated to it does not

#//     let c = 10;
#//     // At this point, 'b' has gone out of scope, so 'a' is a dangling pointer
#//     unsafe {
#//         println!("a: {}", *a); // Unsafe: accessing potentially invalid memory
#//     }
#// }
```


### Example 2: Null Pointer Dereference
[GODBOLT](https://godbolt.org/z/5EMEsGar8)
* CPP
```cpp
#include <cstdio>

void process(int* ptr) {
    // Unsafe: dereferencing a null pointer leads to undefined behavior.
    printf("Data:%d\n", *ptr);
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
        Some(val) => println!("Data:{}", val),
        None => println!("Received a null pointer (None value)."),
    }
}

fn main() {
    let ptr: Option<&i32> = None;
    process(ptr);
}
```



### Example 3: Dangling Pointer
[GODBOLT](https://godbolt.org/z/4efPc787P)
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
    printf("Data: %d\n", *ptr); // Undefined behavior: accessing a deallocated stack frame
    return 0;
}
```
* RUST
```rust,editable
fn dangling_pointer() -> Box<i32> {
    let value = Box::new(42);
    value
}

pub fn main() {
    let val = dangling_pointer();
    println!("Data:{}", *val); // Safe: `val` owns the data directly.
}
```
