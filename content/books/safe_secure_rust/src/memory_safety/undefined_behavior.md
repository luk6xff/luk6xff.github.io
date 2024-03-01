# Undefined Behavior

### Example 1 - Writing to not allocated memmory
[GODBOLT](https://godbolt.org/z/c4sseTG8n)

* CPP
    - It would lead to undefined behavior because the algorithm attempts to write to memory locations that have not been allocated or are not owned by the dst vector.
```cpp
#include <iostream>
#include <algorithm>
#include <vector>
#include <cmath>

auto f(const std::vector<int>& src) -> std::vector<int> {
    std::vector<int> dst;
    //%dst.reserve(src.size()); // Reserve space to avoid reallocations
    //% std::transform(src.begin(), src.end(), std::back_inserter(dst), [](int i) {
    //%     return std::pow(i, 2);
    //% });
    std::transform(src.begin(), src.end(), dst.begin(), [](int i) {
        return std::pow(i, 2);
    });
    return dst;
}

int main() {
    std::vector<int> vec = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    auto res = f(vec);
    for (const auto& v : res) {
        std::cout << v << " ";
    }
    std::cout << std::endl;
    return 0;
}
```

* RUST
    - Rust's compiler and type system prevent the kind of mistake seen in the C++ example, but for educational purposes, let's start with an attempt that might resemble the misuse of std::transform with an uninitialized destination:
    - Rust does not allow uninitialized memory access or buffer overflow by design. The language's safety guarantees and compile-time checks ensure that operations on collections like vectors are performed within the bounds of allocated memory, preventing undefined behavior related to memory access.
```rust,editable
fn f(src: &Vec<i32>) -> Vec<i32> {
    let mut dst: Vec<i32>;
    #//let mut dst: Vec<i32> = Vec::with_capacity(src.len());
    src.iter()
        .map(|&x| x.pow(2))
        .for_each(|xx| dst.push(xx));
    dst
}

pub fn main() {
    let src = vec![1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    let res = f(src);
    println!("{:?}", res);
}
```
