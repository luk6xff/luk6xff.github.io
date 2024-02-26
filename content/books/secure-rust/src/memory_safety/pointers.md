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
        None => println!("Received a null pointer (None value)."),
    }
}

fn main() {
    let ptr: Option<&i32> = None;
    process(ptr);
}
```



### Example 2: Dangling Pointer
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


### Example 3: Dangling pointers
* CPP
```cpp
#include <iostream>
#include <cstring>

class DynamicArray {
public:

    DynamicArray(size_t size) : size(size), data(new int[size]) {}

    // Destructor to prevent memory leaks
    ~DynamicArray() {
        std:: cout << "DTOR called"
        delete[] data;
    }

    // Copy constructor for deep copy
    DynamicArray(const DynamicArray& other)
    : size(other.size)
    , data(new int[other.size]) {
        std::memcpy(data, other.data, size * sizeof(int));
    }

    DynamicArray& operator=(const DynamicArray& other) {
        if (this != &other) {
            //%// First problem: Previous data is not deleted, leading to a memory leak
            //%// delete[] data;
            size = other.size;
            data = other.data; // Problem: This leads to sharing the same data pointer
            //%// Second problem: Previous data is not deleted, leading to a memory leak
            //%// data = new int[other.size];
            std::memcpy(data, other.data, size * sizeof(int));
        }
        return *this;
    }

    // Example function that might lead to issues without proper management
    void fillWith(int value) {
        for (size_t i = 0; i < size; ++i) {
            data[i] = value;
        }
    }

    // Method to print the contents of the vector
    void print() const {
        for (int i = 0; i < size; ++i) {
            std::cout << data[i] << " ";
        }
        std::cout << "\n";
    }

private:
    int* data;
    size_t size;
};


//%// class DynamicArray {
//%// public:
//%//     std::vector<int> data;

//%//     // Constructor initializes the vector to a specific size with a default value
//%//     DynamicArray(size_t size, int initialValue = 0) : data(size, initialValue) {}

//%//     // Method to fill the vector with a specific value
//%//     void fillWith(int value) {
//%//         std::fill(data.begin(), data.end(), value);
//%//     }

//%//     // Method to print the contents of the vector
//%//     void print() const {
//%//         for (int item : data) {
//%//             std::cout << item << " ";
//%//         }
//%//         std::cout << "\n";
//%//     }
//%// };



int main() {
    DynamicArray arr1(5);
    arr1.fillWith(1);

    DynamicArray arr2(5);
    arr2 = arr1; // Uses the copy assignment operator
    arr1.fillWith(99); // Modifies arr1 after it has been assigned to arr2
    arr1.fillWith(33); // Modifies arr1 after it has been assigned to arr2
    arr2.print(); // Expected to print values from arr2


    return 0;
}
```

* RUST
```rust,editable
struct DynamicArray {
    data: Vec<i32>,
}

impl DynamicArray {
    fn new(size: usize) -> Self {
        DynamicArray {
            data: vec![0; size],
        }
    }

    fn fill_with(&mut self, value: i32) {
        for item in &mut self.data {
            *item = value;
        }
    }

    fn print(&self) {
        for value in self.data.iter() {
            println!("{}", value);
        }
    }
}

fn main() {
    let mut arr = DynamicArray::new(10);
    arr.fill_with(42);

    let arr_copy = arr; // Ownership is moved to arr_copy, arr is no longer valid

    // Trying to use `arr` here would result in a compile-time error
    // arr.fill_with(0); // Uncommenting this line will not compile

    // arr_copy is safely used
    arr_copy.print();
}
```
