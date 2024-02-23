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


### Example 2
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





