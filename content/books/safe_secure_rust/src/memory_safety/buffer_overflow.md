# Buffer Overflow



### Example 1
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


### Example 2 - strncpy overflow
[GODBOLT](https://godbolt.org/z/3x8arhnad)

* CPP
```cpp
#include <iostream>
#include <cstring>
#include <array>

int main() {
    std::array<char, 10> buf;
    const char* input = "This is way too long for the buffer";

    strncpy(buf.data(), source, strlen(source));
    std::cout << buf.data() << std::endl;

    return 0;
}

```
* RUST
```rust,editable
fn main() {
    let mut buf = [0u8; 10];
    let input = "This is way too long for the buffer".as_bytes();

    buf.copy_from_slice(&input[..input.len()]);
    println!("{:?}", &buf);
}
```



### Example 3 - Buffer overflow- undefined behavior
[GODBOLT](https://godbolt.org/z/bPYveYdTz)

* CPP
```cpp
#include <iostream>
#include <cstring>
#include <array>

constexpr size_t k_bufSize = 5;
const std::array<char, k_bufSize> buf = {'A', 'B', 'C', 'D', 'E'};

bool exists_in_buffer(char v)
{
    // return true in one of the first 4 iterations or UB due to out-of-bounds access
    for (auto i = 0; i <= k_bufSize; ++i) {
        if (buf[i] == v)
            return true;
    }

    return false;
}

int main() {
    std::cout << exists_in_buffer('\0') << std::endl;
    return 0;
}
```

* RUST
```rust,editable
const K_BUF_SIZE: usize = 5;
const BUF: [char; K_BUF_SIZE] = ['A', 'B', 'C', 'D', 'E'];

fn exists_in_buffer(v: char) -> bool {
    // Iterate over each element in the buffer
    for i in 0..K_BUF_SIZE+1 {
        if BUF[i] == v {
            return true;
        }
    }
    false
}

pub fn main() {
    println!("{}", exists_in_buffer('\0'));
}
```
* This is an example of Rust’s memory safety principles in action. In many low-level languages, this kind of check is not done, and when you provide an incorrect index, invalid memory can be accessed. Rust protects you against this kind of error by immediately exiting instead of allowing the memory access and continuing.
