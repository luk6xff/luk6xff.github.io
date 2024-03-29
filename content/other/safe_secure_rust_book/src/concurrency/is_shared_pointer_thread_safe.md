# Is std::shared_pointer thread safe ?

### Example 1:
- [GODBOLT](https://godbolt.org/z/se3d5Mf6b)
- [DEMO](https://github.com/luk6xff/luk6xff.github.io/tree/master/content/other/safe_secure_rust_book/examples/concurrency/is_shared_pointer_thread_safe)
* CPP
    - Thread Safety of std::shared_ptr: The std::shared_ptr named counter is passed safely to multiple threads, demonstrating the thread-safe nature of creating and destroying std::shared_ptr copies. The reference count is managed correctly, ensuring the Counter object's lifetime is managed safely across threads.
    - Lack of Thread Safety in Object Access: The Counter::increment method is called concurrently by multiple threads without synchronization. Since incrementing the value member variable is not an atomic operation, this leads to a race condition, and the final value of counter is likely to be less than the expected 100,000 due to missed increments.
```cpp
#include <iostream>
#include <memory>
#include <vector>
#include <thread>
#include <mutex>

class Counter {
public:
    void increment() {
        //%//std::lock_guard<std::mutex> guard(mutex); // Protect access to value
        ++value; // This operation is not thread-safe.
    }

    int getValue() const {
        //%//std::lock_guard<std::mutex> guard(mutex); // Protect access to value
        return value;
    }

private:
    //%//mutable std::mutex mutex; // mutable allows modification in const methods
    int value = 0;
};

void incrementCounter(std::shared_ptr<Counter> counter) {
    for (int i = 0; i < 10000; ++i) {
        counter->increment();
    }
}

int main() {
    constexpr auto num_of_threads = 10;
    auto counter = std::make_shared<Counter>();
    std::vector<std::thread> threads;

    // Create multiple threads that increment the shared counter.
    for (int i = 0; i < num_of_threads; ++i) {
        threads.emplace_back(incrementCounter, counter);
    }

    // Wait for all threads to complete.
    for (auto& thread : threads) {
        thread.join();
    }

    std::cout << "Expected value: " << num_of_threads * 10000 << std::endl;
    std::cout << "Actual value  : " << counter->getValue() << std::endl;

    return 0;
}
```

* RUST
    - This Rust implementation ensures thread safety through the use of Mutex for data access synchronization and Arc for shared ownership among threads, similar to the thread safety mechanisms used in the provided C++ example.
```rust,editable
// Common
use std::sync::{Arc, Mutex};
use std::thread;



// 1)
struct Counter {
    value: i32,
}

impl Counter {
    fn new() -> Self {
        Counter {
            value: 0,
        }
    }

    fn increment(&mut self) {
        self.value += 1;
    }

    fn get_value(&self) -> i32 {
        self.value
    }
}

pub fn main() {
    const num_of_threads: usize = 10;
    let counter = Arc::new(Mutex::new(Counter::new()));
    let mut threads = vec![];

    for _ in 0..num_of_threads {
        let mut counter_clone = Arc::clone(&counter);
        let handle = thread::spawn(move || {
            for _ in 0..10000 {
                counter_clone.lock().unwrap().increment();
            }
        });
        threads.push(handle);
    }

    for handle in threads {
        handle.join().unwrap();
    }

    println!("Expected value: {}", num_of_threads * 10000);
    println!("Actual Value:   {}", counter.lock().unwrap().get_value());
}



// 2)
// struct Counter {
//     value: Mutex<i32>,
// }

// impl Counter {
//     fn new() -> Self {
//         Counter {
//             value: Mutex::new(0),
//         }
//     }

//     fn increment(&self) {
//         let mut value = self.value.lock().unwrap();
//         *value += 1;
//     }

//     fn get_value(&self) -> i32 {
//         let value = self.value.lock().unwrap();
//         *value
//     }
// }

// fn main() {
//     const num_of_threads: usize = 10;
//     let counter = Arc::new(Counter::new());
//     let mut threads = vec![];

//     for _ in 0..10 {
//         let counter_clone = Arc::clone(&counter);
//         let handle = thread::spawn(move || {
//             for _ in 0..10000 {
//                 counter_clone.increment();
//             }
//         });
//         threads.push(handle);
//     }

//     for handle in threads {
//         handle.join().unwrap();
//     }

//     println!("Expected value: {}", num_of_threads * 10000);
//     println!("Actual Value:   {}", counter.get_value());
// }




// 3) This will NOT compile
// /*
//  * Explanation of the Compilation Error in this code:
//  * - The error in code here occurs because we are trying to mutate data inside an `Arc`
//  *   without using a synchronization primitive like `Mutex`. `Arc` does not implement
//  *   `DerefMut`, which means we cannot obtain a mutable reference to its contents directly.
//  *   Rust's ownership rules ensure that data can either have multiple owners (`Arc`) or be
//  *   mutable, but not both simultaneously without explicit synchronization mechanisms like `Mutex`.
//  *
//  * - The `increment` method requires mutable access to the `Counter` (`&mut self`), which
//  *   is not allowed through an `Arc` because `Arc` is designed for shared ownership of immutable
//  *   data. When we try to call `increment` through an `Arc`, Rust enforces its safety guarantees
//  *   and prevents we from potentially causing data races or other undefined behavior.
//  *
//  * -  MORE: https://fongyoong.github.io/easy_rust/Chapter_59.html
//  */

// struct Counter {
//     value: i32,
// }

// impl Counter {
//     fn new() -> Self {
//         Counter {
//             value: 0,
//         }
//     }

//     fn increment(&mut self) {
//         self.value += 1;
//     }

//     fn get_value(&self) -> i32 {
//         self.value
//     }
// }

// pub fn main() {
//     const num_of_threads: usize = 10;
//     let counter = Arc::new(Counter::new());
//     let mut threads = vec![];

//     for _ in 0..num_of_threads {
//         let counter_clone = Arc::clone(&counter);
//         let handle = thread::spawn(move || {
//             for _ in 0..10000 {
//                 counter_clone.increment();
//             }
//         });
//         threads.push(handle);
//     }

//     for handle in threads {
//         handle.join().unwrap();
//     }

//     println!("Expected value: {}", num_of_threads * 10000);
//     println!("Actual Value:   {}", counter.get_value());
// }
```
