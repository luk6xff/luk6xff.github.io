# Double Free



### Example 1: Classic double free problem
[GODBOLT](https://godbolt.org/z/8Wxnxhf34)
* CPP
```cpp
#include <iostream>

void cause_double_free() {
    int* ptr = new int(10); // Allocate memory on the heap
    delete ptr; // Correctly free memory
    *ptr = 11;
    std:: cout << "ptr = " << *ptr << std::endl;
    delete ptr; // Double free error: undefined behavior
    *ptr = 12;
    std:: cout << "ptr = " << *ptr << std::endl;
}

int main() {
    cause_double_free();
    return 0;
}
```

* RUST
```rust,editable
fn cause_double_free() {
    let mut ptr = Box::new(10); // Allocate memory on the heap
    *ptr = 11;
    println!("ptr = {}", *ptr);
    // Memory is automatically freed when `ptr` goes out of scope
}

pub fn main() {
    cause_double_free();
    println!("No double free error occurred.");
}
```



### Example 2: Double free because of the manual memory management implementation issue
[GODBOLT](https://godbolt.org/z/fW7jvjf8e)
* CPP
```cpp
#include <iostream>
#include <algorithm>
#include <cstring>

class DynamicArray {
public:
    DynamicArray(size_t size)
    : size(size)
    , data(new int[size]) {}

    ~DynamicArray() {
        std::cout << "DTOR called on data: " << std::hex << data << std::endl;
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

//private:
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



void cause_double_free() {
    DynamicArray arr1(10);
    arr1.fillWith(11);

    DynamicArray arr2 = arr1; // Copy constructor - deep copy
    arr2.fillWith(22); // Modifies arr1 after it has been assigned to arr2
    std::cout << "arr1: "; arr1.print(); // Expected to print values from arr1
    std::cout << "arr2: "; arr2.print(); // Expected to print values from arr2

    DynamicArray arr3(5);
    arr3 = arr2; // Copy assignment operator
    //%// Both arr1 and arr2 now share the same `data` pointer.
    arr3.fillWith(33); // Modifies arr1 after it has been assigned to arr2

    std::cout << "Adresses:" << std::hex << " arr1:" << arr1.data << " arr2:" << arr2.data << " arr3:" << arr3.data  <<  std::endl;
    std::cout << "arr1: "; arr1.print(); // Expected to print values from arr1
    std::cout << "arr2: "; arr2.print(); // Expected to print values from arr2
    std::cout << "arr3: "; arr3.print(); // Expected to print values from arr3
}

int main() {
    cause_double_free(); // This will lead to a double free error when arr2 and arr3 are destructed.
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
        println!("{:?}", self.data);
    }
}

pub fn main() {
    let mut arr1 = DynamicArray::new(10);
    arr1.fill_with(11);

    let arr2 = arr1; // Ownership is moved to arr2, arr1 is no longer valid

    // Trying to use `arr1` here would result in a compile-time error
    //arr1.fill_with(0); // Uncommenting this line will not compile

    // arr2 is safely used
    arr2.print();
}
```
