# Buffer Overflow


### Example 1:
[GODBOLT](https://godbolt.org/z/T4jMaPzns)

* CPP - A classic buffer overflow using an array. This code compiles, but accessing arr[10] is undefined behavior,leading to a potential security vulnerability.
```cpp
#include <iostream>

int main() {
    int arr[5] = {1, 2, 3, 4, 5};
    // Accidental buffer overflow
    arr[10] = 10;
    std::cout << arr[10] << std::endl;
    return 0;
}
```
* RUST - This code will not compile, as the compiler checks array bounds at compile time and prevents out-of-bounds access.
```rust,editable
fn main() {
    let mut arr = [1, 2, 3, 4, 5];
    // Compile-time error for out-of-bounds access
    arr[10] = 10;
    println!("{}", arr[10]);
}
```


### Example 2:
[GODBOLT](https://godbolt.org/z/q93soerhh)

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
* RUST - Attempting to access `arr[5]` results in a runtime error because the index 5 is out-of-bounds for an array of length 5.
Rust's safety mechanisms detect this at runtime and cause the program to panic, preventing it from continuing with invalid memory access.
```rust,editable
fn main() {
    let arr = [1, 2, 3, 4, 5];
    // Causes the program to panic for out-of-bounds access
    for i in 0..=5 {
        println!("{}", arr[i]);
    }
}
```

### Example 3: strncpy overflow
[GODBOLT](https://godbolt.org/z/13zGoPsqK)

* CPP
```cpp
#include <iostream>
#include <cstring>
#include <array>

int main() {
    std::array<char, 10> buf;
    const char* input = "This is way too long for the buffer";

    strncpy(buf.data(), input, strlen(input));
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
# //https://doc.rust-lang.org/src/core/slice/mod.rs.html#3648-3650
```



### Example 4: Buffer overflow- undefined behavior
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
This is an example of Rust’s memory safety principles in action. In many low-level languages, this kind of check is not done, and when you provide an incorrect index, invalid memory can be accessed. Rust protects you against this kind of error by immediately exiting instead of allowing the memory access and continuing.


### Example 5: std::io
[GODBOLT](https://godbolt.org/z/ns394fEjs)
* CPP
```cpp
#include <iostream>

int main() {
    char buffer[10];
    std::cin >> buffer;
    std::cout << "Input: " << buffer << std::endl;
    return 0;
}
```
* RUST
```rust,editable
use std::io::{self, Read};

fn main() -> io::Result<()> {
    let mut buffer = [0; 10];
    let n = io::stdin().read(&mut buffer)?;
    println!("Input: {}", String::from_utf8_lossy(&buffer[..n]));
    Ok(())
}

#//fn main() -> io::Result<()> {
   #//let mut input = String::new();
   #//io::stdin().read_line(&mut input)?;
   #//// Trim the newline from the end of the input
   #//let input = input.trim_end();
   #//println!("Input: {}", input);
   #//Ok(())
#//}
```
Rust's standard library is designed to prevent from buffer overflow here by ensuring that read only reads up to the buffer's capacity.


### Example 6: DLT deamon buffer overflow issue
The use of `fscanf(handle, "%s", str1)` without specifying a limit for the number of characters to read into `str1` and `apid/ctid` arrays poses a risk of buffer overflow. If the file contains a string longer than the buffer size `(DLT_COMMON_BUFFER_LENGTH and DLT_ID_SIZE)`, it will overflow, leading to undefined behavior, which can be exploited.

* CPP
```cpp
DltReturnValue dlt_filter_load(DltFilter *filter, const char *filename, int verbose)
{
    if ((filter == NULL) || (filename == NULL))
        return DLT_RETURN_WRONG_PARAMETER;
    FILE *handle;
    char str1[DLT_COMMON_BUFFER_LENGTH];
    char apid[DLT_ID_SIZE], ctid[DLT_ID_SIZE];
    PRINT_FUNCTION_VERBOSE(verbose);
    handle = fopen(filename, "r");
    if (handle == NULL) {
        dlt_vlog(LOG_WARNING, "Filter file %s cannot be opened!\n", filename);
        return DLT_RETURN_ERROR;
    }
    /* Reset filters */
    filter->counter = 0;
    while (!feof(handle)) {
        str1[0] = 0;

        if (fscanf(handle, "%s", str1) != 1)
            break;

        if (str1[0] == 0)
            break;
        printf(" %s", str1);
        if (strcmp(str1, "----") == 0)
            dlt_set_id(apid, "");
        else
            dlt_set_id(apid, str1);

        str1[0] = 0;

        if (fscanf(handle, "%s", str1) != 1)
            break;

        if (str1[0] == 0)
            break;
        printf(" %s\r\n", str1);
        if (strcmp(str1, "----") == 0)
            dlt_set_id(ctid, "");
        else
            dlt_set_id(ctid, str1);
        if (filter->counter < DLT_FILTER_MAX) {
            dlt_filter_add(filter, apid, ctid, verbose);
        }
        else {
            dlt_vlog(LOG_WARNING,
                     "Maximum number (%d) of allowed filters reached, ignoring rest of filters!\n",
                     DLT_FILTER_MAX);
        }
    }
    fclose(handle);
    return DLT_RETURN_OK;
}
```
