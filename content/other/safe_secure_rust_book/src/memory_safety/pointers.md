# Problems with pointers
Pointers are a powerful feature in programming languages like C and C++, providing the flexibility to directly manipulate memory addresses. They are essential for a range of programming tasks, from creating efficient data structures to interfacing with hardware and operating systems. However, their power comes with significant complexity and potential pitfalls. Improper use of pointers can lead to memory leaks, dangling pointers, null pointer dereferences, and undefined behavior, making programs unstable, insecure, and prone to crashes.


### Example 1: Dangling Pointer
[GODBOLT](https://godbolt.org/z/bbW69EG8x)
* C
```c
#include "stdio.h"

int main() {
    int* a = nullptr;
    {
        int b = 5;
        a = &b;
    }
    int c = 10;
    // At this point, b goes out of scope, but the memory allocated to it does not
    printf("a: %d\n", *a);

    return 0;
}
```

* CPP
```c
#include <iostream>
#include <memory>

int main() {
    std::unique_ptr<int> a;
    {
        auto b = std::make_unique<int>(5);
        a = std::move(b);  // Move the ownership of the unique_ptr<int> from 'b' to 'a'
    } // 'b' goes out of scope here, but its value is safely stored in 'a'

    int _c = 10;
    // At this point, 'b' has gone out of scope, but its value is safely stored in 'a'
    std::cout << *a << std::endl;

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
* C
```c
#include "stdio.h"

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

* CPP
```cpp
#include <iostream>
#include <memory>
#include <optional>

void process1(std::unique_ptr<int> ptr) {
    std::cout << "ptr = " << *ptr << std::endl;
}

void process2(std::optional<int> ptr) {
    std::cout << "ptr = " << *ptr << std::endl;
}

int main() {
    std::optional<int> a;
    process2(a);  // will explicitly "work" with default constructed value (in this case 0)

    std::unique_ptr<int> b;
    process1(std::move(b)); // will panic.

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
* C
```c
#include "stdio.h"
#include "stdlib.h"

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

* CPP
```cpp
#include <iostream>
#include <memory>

std::unique_ptr<int> dangling_pointer() {
    return std::make_unique<int>(42);
}

int main() {
    auto val = dangling_pointer();
    std::cout << "Data: " << *val << std::endl;  // Safe: `val` owns the data directly.
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

### Example 4: `std::unique_ptr`
[GODBOLT](https://godbolt.org/z/facc59MoM)
* CPP
```cpp
#include <iostream>
#include <memory>

void process(std::unique_ptr<int> ptr) {
    std::cout << "1) Data: " << *ptr << std::endl;
}

int main() {
    auto ptr = std::make_unique<int>(10);
    process(std::move(ptr)); // Ownership is transferred to process()

    // ptr is now moved; accessing *ptr would result in undefined behavior
    std::cout << "2) Data: " << *ptr << std::endl;

    return 0;
}
```
This example demonstrates `std::unique_ptr` for managing dynamic memory and transferring ownership. When `ptr` is passed to `process`, its ownership is moved, preventing `ptr` from being accidentally used after the transfer, which would lead to undefined behavior.

* RUST
```rust,editable
fn process(ptr: Box<i32>) {
    println!("1) Data: {}", ptr);
}

fn main() {
    let ptr = Box::new(10);
    process(ptr); // Ownership is moved to process()

    // Rust's compiler will prevent us from using ptr here since its ownership has been moved
    // Compile-time error: value borrowed here after move
    println!("2) Data: {}", ptr);
}
```
Rust naturally avoids these issues through its ownership system. Once a value's ownership is moved, the original variable cannot be used, preventing dangling pointers or undefined behavior. This is enforced at compile time, making Rust programs safer by design.


### Example 5: `std::shared_ptr`
[GODBOLT](https://godbolt.org/z/dKEax8x4o)
* CPP
```cpp
#include <iostream>
#include <memory>

void process(std::shared_ptr<int> ptr) {
    std::cout << "Data: " << *ptr << " (count: " << ptr.use_count() << ")" << std::endl;
}

int main() {
    auto ptr = std::make_shared<int>(10);
    process(ptr); // Shared ownership allows ptr to be used after being passed

    std::cout << "Main still owns ptr with data: " << *ptr << " (count: " << ptr.use_count() << ")" << std::endl;

    return 0;
}
```
This example illustrates the use of `std::shared_ptr` for shared ownership scenarios. The reference count mechanism ensures that the memory is only freed when the last owner goes out of scope, avoiding premature deallocation.

* RUST
```rust,editable
use std::rc::Rc;

fn process(ptr: Rc<i32>) {
    println!("Data: {} (count: {})", ptr, Rc::strong_count(&ptr));
}

fn main() {
    let ptr = Rc::new(10);
    process(ptr.clone()); // The Rc type allows for shared ownership through reference counting

    println!("Main still owns ptr with data: {} (count: {})", ptr, Rc::strong_count(&ptr));
}
```
Rust's `Rc<T>` type provides shared ownership with reference counting, similar to `std::shared_ptr`. It ensures that the memory is deallocated only when the last reference goes out of scope. Rust further prevents data races by ensuring `Rc<T>` is only used in single-threaded scenarios, with `Arc<T>` available for multi-threaded contexts.



### Example 6: Moving `std::shared_ptr`

[GODBOLT](https://godbolt.org/z/nMxcTx5ns)
* CPP
```cpp
#include <iostream>
#include <memory>

void process(std::shared_ptr<int> ptr) {
    std::cout << "Data: " << *ptr << " (count: " << ptr.use_count() << ")" << std::endl;
}

int main() {
    auto ptr = std::make_shared<int>(10);
    process(ptr); // Shared ownership allows ptr to be used after being passed

    std::cout << "Main still owns ptr with data: " << *ptr << " (count: " << ptr.use_count() << ")" << std::endl;

    std::shared_ptr<int> moved = std::move(ptr);
    std::cout << "Moved use count: " << *moved << " (count: " << moved.use_count() << ")" << std::endl;
    std::cout << "Original after move: "<< *ptr << " " << ptr.use_count() << std::endl; // ptr is now nullptr, UB

    return 0;
}
```
This example demonstrates moving a `std::shared_ptr` in C++. Moving transfers ownership of the managed object to another `std::shared_ptr`, effectively nullifying the original pointer without altering the reference count. This operation is useful for avoiding unnecessary atomic operations associated with incrementing and decrementing the reference count, improving performance in certain scenarios.

* RUST
```rust,editable
use std::rc::Rc;

fn process(ptr: Rc<i32>) {
    println!("Data: {} (count: {})", *ptr, Rc::strong_count(&ptr));
}

pub fn main() {
    let ptr = Rc::new(10);
    process(Rc::clone(&ptr)); // Simulates shared ownership by increasing the reference count

    println!("Main still owns ptr with data: {} (count: {})", *ptr, Rc::strong_count(&ptr));

    // Note: Direct move in Rust transfers ownership and makes the original variable inaccessible
    let moved = ptr.clone();

    println!("Moved use count: {} (count: {})", *moved, Rc::strong_count(&moved));
    // Note: This will NOT compile, ptr is not longer accessible
    //println!("Original after move: {} (count: {})", *ptr, Rc::strong_count(&ptr));
}
```
In Rust, the concept of moving a `Rc<T>` doesn't directly translate from C++ because Rust's ownership model ensures safety by preventing access to moved values. Cloning an `Rc<T>` increases the reference count, simulating shared ownership similar to `std::shared_ptr`. However, Rust's compile-time checks prevent the use of moved values, avoiding the risk of null pointer dereferences and undefined behavior, showcasing Rust's approach to memory safety.
