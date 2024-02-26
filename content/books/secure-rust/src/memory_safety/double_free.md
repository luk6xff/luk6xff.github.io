# Buffer Overflow



### Example 1: Classic double free
* CPP
```cpp
#include <iostream>

void cause_double_free() {
    int* ptr = new int(10); // Allocate memory on the heap
    delete ptr; // Correctly free memory
    delete ptr; // Double free error: undefined behavior
}

int main() {
    cause_double_free();
    return 0;
}

```
* RUST
```rust,editable
fn cause_double_free() {
    let ptr = Box::new(10); // Allocate memory on the heap
    // Memory is automatically freed when `ptr` goes out of scope
}

fn main() {
    cause_double_free();
    println!("No double free error occurred.");
}
```



### Example 2: Double frre because of the manual memory management implementation issue
* CPP
```cpp
#include <iostream>
#include <algorithm> // For std::copy

class DynamicArray {
public:
    int* data;
    size_t size;

    DynamicArray(size_t size)
    : size(size)
    , data(new int[size]) {}

    ~DynamicArray() {
        delete[] data;
    }

    // Copy constructor for deep copy
    DynamicArray(const DynamicArray& other)
    : size(other.size)
    , data(new int[other.size]) {
        std::memcpy(data, other.data, size * sizeof(int));
    }

    // Incorrect copy assignment operator - shallow copy
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

    void fillWith(int value) {
        std::fill(data, data + size, value);
    }

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

void cause_double_free() {
    DynamicArray arr1(10);
    arr1.fillWith(11);

    DynamicArray arr2 = arr1; // Copy constructor - deep copy
    arr2.fillWith(22); // Modifies arr1 after it has been assigned to arr2
    DynamicArray arr3(5);
    arr3 = arr2; // Uses the copy assignment operator
    //%// Both arr1 and arr2 now share the same `data` pointer.
    arr3.fillWith(33); // Modifies arr1 after it has been assigned to arr2
    arr2.print(); // Expected to print values from arr2
    arr3.print(); // Expected to print values from arr3
}

int main() {
    cause_double_free(); // This will lead to a double free error when arr1 and arr2 are destructed.
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
    arr.fill_with(11);

    let arr_copy = arr; // Ownership is moved to arr_copy, arr is no longer valid

    // Trying to use `arr` here would result in a compile-time error
    // arr.fill_with(0); // Uncommenting this line will not compile

    // arr_copy is safely used
    arr_copy.print();
}
```
