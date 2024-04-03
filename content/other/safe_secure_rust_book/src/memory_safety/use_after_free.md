## Use After Free types of bugs
"Use after Free" (UAF) is a memory corruption issue where a program tries to access memory that has already been freed. This typically happens due to programming errors when referencing memory that was deallocated. It can lead to crashes, data corruption, or even security vulnerabilities. Detection is challenging, and mitigation involves proper memory management practices and programming language features that enforce memory safety, such as Rust's ownership system.

### Example 1: Use After Free
[GODBOLT](https://godbolt.org/z/KG3Whh9dW)
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


### Example 2: Memory bounds, dangling pointer or even use after free
[GODBOLT](https://godbolt.org/z/dvGP1f6aa)
* CPP
```cpp
#include <iostream>
#include <vector>
#include <optional>
#include <exception>

// Function to modify the vector by adding a new value
void modify(std::vector<int>& vec, int value) {
    vec.push_back(value);
}


// Function to safely get a value from the vector by index, returns std::optional
std::optional<int> get(const std::vector<int>& vec, size_t index) {
    if (index < vec.size()) { // You need to write THIS
        return vec[index];
    } else {
        return std::nullopt;
    }
}


int unsafe_get(const std::vector<int>& vec, size_t index) {
    return vec[index];
}

int safe_get(const std::vector<int>& vec, size_t index) {
    return vec.at(index);
}

int main() {
    std::vector<int> data = {1, 2, 3};

    //%//// 4) Get an internal data reference
    //%// auto &x = data[0];
    //%// //auto *x = &data[0];
    //%// std::cout << "x(1) = " << x << ", &data[0] = " << &data[0] << std::endl;
    //%//// `modify (vec.push_back)` will might cause the backing storage of `data` to be reallocated. Dangling pointer and use after free issue, Does this compile in CPP ?
    //%// data.push_back(4);

    // 1) Modifying the vector
    modify(data, 10);
    std::cout << "Modified data: ";
    for (auto& n : data) {
        std::cout << n << " ";
    }
    std::cout << "\n";

    // 2) Attempt to get a value from the vector by index
    const size_t index = 42;
    auto result = get(data, index);
    if (result.has_value()) {
        std::cout << "Valid data returned: " << result.value() << std::endl;
    } else {
        std::cout << "No data exists for index: " << index << std::endl;
    }

    // 3) Use automatic bounds checked access employing exceptions
    try {
        safe_get(data, index);
    }
    catch (std::out_of_range &e) {
        std::cout << "No data exists for index: " << index << std::endl;
    }

    // 4) Will this fail ?
    std::cout << unsafe_get(data, index) << std::endl;

    //%//// 5) Modify the reference
    //%// x = 11;
    //%// std::cout << "x(2) = " << x << ", &data[0] = " << &data[0] << std::endl;
    //%// std::cout << "Modified data once again: ";
    //%// for (auto& n : data) {
    //%//     std::cout << n << " ";
    //%// }
    //%// std::cout << "\n";

    return 0;
}
```

* RUST
```rust,editable
fn modify(vec: &mut Vec<i32>, value: i32) -> () {
    vec.push(value);
    ()
}

fn get(vec: &Vec<i32>,index: usize) -> Option<&i32> {
    vec.get(index)
}

fn not_best_get(vec: &Vec<i32>,index: usize) -> i32 {
    vec[index]
}


fn main() {

    let mut data = vec![1, 2, 3];

    #//// 4) Get an internal reference
    #//let x = &data[0];
    #//// This does not compile in rust
    #//data.push(4);

    // 1) Modifying the vector
    modify(&mut data, 10);
    println!("{:?}", data);
    // 2) Attempt to get a value from the vector by index
    let index: usize = 42;
    match get(&data, index) {
        Some(x) => {
            println!("Valid data returned: {}", x);
        },
        None => {
            println!("No data exists for index:{}", index);
        }
    }

    // 3) Will this fail ?
    //println!("{}", not_best_get(&data, index));

    #//// 4) Modify the reference
    #//x = 11;
    #//println!("{}", x);
    #//println!("{:?}", data);
}
```
