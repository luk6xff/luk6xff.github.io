# Usage of rust's unsafe keyword

Rust's `unsafe` keyword permits operations that could potentially lead to undefined behavior, such as dereferencing raw pointers or calling functions written in another language. The beauty of Rust lies in its ability to encapsulate these unsafe operations within safe interfaces, providing the best of both worlds: the control and performance of low-level programming with the safety guarantees of high-level languages.


### Example 0: Raw pointers
Raw pointers (*) and references (&T) in Rust serve similar purposes, but references are inherently safe due to Rust's borrow checker ensuring they always point to valid data. In contrast, dereferencing raw pointers requires an unsafe block, acknowledging potential risks of accessing potentially invalid data.
```rust,editable
fn main() {
    let num = 42;
    let raw_pointer: *const u32 = &num;

    unsafe {
        println!("*raw_pointer = {}", *raw_pointer);
    }
}
```


### Example 1: Calling an Unsafe C Function from Rust
[DEMO](https://github.com/luk6xff/luk6xff.github.io/tree/master/content/other/safe_secure_rust_book/examples/unsafe/ffi_example)

Suppose you have a C library with the following function:
```c
// In a file `library.c`
#include <stdio.h>

void print_hello_from_c() {
    printf("Hello from C!\n");
}
```

You can call this function from Rust, safely encapsulating the unsafe foreign function interface (FFI) call:

```rust
// Assuming you have linked the C library appropriately
extern "C" {
    fn print_hello_from_c();
}

fn safe_print_hello() {
    unsafe {
        print_hello_from_c(); // Unsafe FFI call
    }
}

fn main() {
    safe_print_hello(); // Safe to call
}
```
This example demonstrates how Rust can interact with C code. The unsafe block is necessary because calling foreign code can't be checked by Rust's safety guarantees, but wrapping it in a safe function allows you to control where and how these interactions occur.


### Example 2: Calling an Unsafe System Library (libcrypt) C Function from Rust
[DEMO](https://github.com/luk6xff/luk6xff.github.io/tree/master/content/other/safe_secure_rust_book/examples/unsafe/ffi_example)

```rust
extern "C" {
    pub fn crypt(phrase: *const c_char, setting: *const c_char) -> *mut c_char;
}

fn safe_crypt(input: &str, salt: &str) -> String {
    let c_input = std::ffi::CString::new(input).expect("CString::new failed for input");
    let c_salt = std::ffi::CString::new(salt).expect("CString::new failed for salt");

    let result_ptr = unsafe { crypt(c_input.as_ptr(), c_salt.as_ptr()) };

    assert!(!result_ptr.is_null(), "crypt returned a null pointer");

    let result_cstr = unsafe { std::ffi::CStr::from_ptr(result_ptr) };
    result_cstr.to_string_lossy().into_owned()
}

fn main() {
    let input = "hello world";
    let salt = "somesalt"; // Example for SHA-512 based on Linux's glibc
    let encrypted = safe_crypt(input, salt);
    println!("Encrypted: {}", encrypted);
}
```


### Example 3: Safe Wrapper for a Raw Pointer

Raw pointers (`*const T` and `*mut T`) are often used in Rust for low-level memory manipulation, but they are inherently unsafe to dereference. Here's an example of a simple safe wrapper around a raw pointer:

```rust,editable
struct SafePtr<T> {
    ptr: *mut T,
}

impl<T> SafePtr<T> {
    fn new(t: &mut T) -> Self {
        SafePtr { ptr: t as *mut T }
    }

    fn read(&self) -> &T {
        unsafe { &*self.ptr }
    }

    fn write(&mut self, value: T) {
        unsafe { *self.ptr = value; }
    }
}

fn main() {
    let mut num = 10;
    let mut safe_ptr = SafePtr::new(&mut num);

    println!("Before: {}", safe_ptr.read());
    safe_ptr.write(20);
    println!("After: {}", safe_ptr.read());
}
```

In this example, `SafePtr` is a wrapper that provides a safe API to read from and write to a location in memory. The unsafe operations are contained within the implementation of `SafePtr`, making the public interface safe to use.



### Example 4: Interfacing with Unsafe Code for Performance

Sometimes, for performance reasons, you might choose to use unsafe code to avoid the overhead of certain safety checks. Here's an example that manipulates a vector in an unsafe manner to avoid bounds checks:

```rust,editable
fn sum_elements(slice: &[i32]) -> i32 {
    let mut sum = 0;
    unsafe {
        for i in 0..slice.len() {
            sum += *slice.get_unchecked(i); // Unsafe to avoid bounds checking
        }
    }
    sum
}

fn main() {
    let nums = vec![1, 2, 3, 4, 5];
    println!("Sum: {}", sum_elements(&nums));
}
```
`get_unchecked` is an unsafe method because it does not perform bounds checking. If used incorrectly, it could lead to undefined behavior. However, by carefully controlling its use within a safe function, we can leverage its performance benefits while minimizing risk.

These examples illustrate Rust's approach to combining low-level control with high-level safety. By requiring unsafe operations to be explicitly marked and encouraging their encapsulation within safe abstractions, Rust helps prevent many common programming errors related to memory safety and concurrency, fostering the development of robust, efficient software.



### Example 5: Inline Assembly
[GODBOLT](https://godbolt.org/z/n7sGh6eba)
Rust's asm! macro allows embedding custom assembly code directly within Rust programs. This is mainly used for performance-critical tasks or when accessing low-level hardware features, such as in kernel development, where Rust's abstractions may not suffice.
```rust,editable
use std::arch::asm;

fn main() {
    let msg = "Hello, world!\n";
    let len = msg.len();
    let fd = 1; // File descriptor 1 for stdout

    unsafe {
        asm!(
            "syscall",
            in("rax") 1,         // syscall number for write
            in("rdi") fd,        // first argument: file descriptor
            in("rsi") msg.as_ptr(), // second argument: pointer to message
            in("rdx") len,       // third argument: message length
            options(nostack)
        );
    }
}
```
