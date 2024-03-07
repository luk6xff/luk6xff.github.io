# Types conversions


### Example 1:
[GODBOLT](https://godbolt.org/z/de5o4sj4f)
* CPP
```cpp
#include <iostream>

int main() {
    // Implicit conversion (no casting required)
    int num_int = 10;
    double num_double = num_int; // Implicit conversion from int to double

    // C-style casting
    double a = 5.5;
    int b = (int)a; // C-style cast: double to int

    // Static cast
    double c = 10.7;
    int d = static_cast<int>(c); // Static cast: double to int

    // Reinterpret cast
    int e = 10;
    char* ptr = reinterpret_cast<char*>(&e); // Reinterpret cast: int pointer to char pointer

    // Const cast
    const int f = 20;
    int* g = const_cast<int*>(&f); // Const cast: const int pointer to int pointer (use with caution)

    // Dynamic cast (used in polymorphic classes)
    class Base {
    public:
        virtual void print() {
            std::cout << "Base class" << std::endl;
        }
    };

    class Derived : public Base {
    public:
        void print() override {
            std::cout << "Derived class" << std::endl;
        }
    };

    Base* base_ptr = new Derived();
    Derived* derived_ptr = dynamic_cast<Derived*>(base_ptr); // Dynamic cast: Base pointer to Derived pointer

    // Output the results
    std::cout << "Implicit conversion: " << num_double << std::endl;
    std::cout << "C-style casting: " << b << std::endl;
    std::cout << "Static cast: " << d << std::endl;
    std::cout << "Reinterpret cast: " << *ptr << std::endl;
    std::cout << "Const cast: " << *g << std::endl;
    if (derived_ptr) {
        derived_ptr->print();
    } else {
        std::cout << "Dynamic cast failed" << std::endl;
    }

    return 0;
}

```

* RUST
```rust,editable
pub fn main() {
    // Implicit conversion (no casting required)
    let num_int: i32 = 10;
    let num_double: f64 = num_int as f64; // Implicit conversion from i32 to f64

    // C-style casting (not recommended in Rust)
    let a: f64 = 5.5;
    let b: i32 = a as i32; // C-style cast: f64 to i32

    // Static cast (not directly available in Rust)
    let c: f64 = 10.7;
    let d: i32 = c as i32; // Rust uses as keyword for static cast

    // Reinterpret cast
    let e: i32 = 10;
    let ptr: *const i32 = &e;
    let ptr_cast: *const u8 = ptr as *const u8; // Reinterpret cast: i32 pointer to u8 pointer

    // Const cast (not directly available in Rust)
    let f: i32 = 20;
    let g: *const i32 = &f;
    let g_mut: *mut i32 = g as *mut i32; // Const cast: const i32 pointer to mut i32 pointer

    // Dynamic cast (not directly available in Rust)
    trait Base {
        fn print(&self);
    }

    struct Derived;

    impl Base for Derived {
        fn print(&self) {
            println!("Derived class");
        }
    }

    let base_ref: &dyn Base = &Derived;

    // Output the results
    println!("Implicit conversion: {}", num_double);
    println!("C-style casting: {}", b);
    println!("Static cast: {}", d);
    // unsafe {
    //     println!("Reinterpret cast: {:?}", *ptr_cast);
    //     *g_mut = 30; // Safe because we own the memory and it's not const anymore
    //     println!("Const cast: {}", *g_mut);
    // }

    println!("{:?}", base_ref.print());
}

```
