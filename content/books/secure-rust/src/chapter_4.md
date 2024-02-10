# Concurrency Without Data Races





### Example 1: Thread Safety
* CPP - In C++, std::mutex and RAII patterns (like std::lock_guard) help manage thread safety, but the developer must explicitly use them to protect shared data.
```cpp
#include <iostream>
#include <thread>
#include <mutex>
#include <vector>

std::mutex mtx; // mutex for critical section

void print_block(int n, char c) {
    mtx.lock();
    for (int i = 0; i < n; ++i) { std::cout << c; }
    std::cout << '\n';
    mtx.unlock();
}

int main() {
    std::vector<std::thread> threads;
    for (int i = 0; i < 5; ++i) {
        threads.push_back(std::thread(print_block, 50, '*'));
    }
    for (auto& th : threads) th.join();
}
```
* RUST - Compile-Time Thread Safety
```rust,editable
use std::sync::{Mutex, Arc};
use std::thread;

fn main() {
    let counter = Arc::new(Mutex::new(0));
    let mut handles = vec![];

    for _ in 0..5 {
        let counter = Arc::clone(&counter);
        let handle = thread::spawn(move || {
            let mut num = counter.lock().unwrap();
            *num += 1;
        });
        handles.push(handle);
    }

    for handle in handles {
        handle.join().unwrap();
    }
}
```