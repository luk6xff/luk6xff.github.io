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
    for (int i = 0; i < n; ++i) {
        std::cout << c;
    }
    std::cout << '\n';
    mtx.unlock();
}

int main() {
    std::vector<std::thread> threads;
    for (int i = 0; i < 5; ++i) {
        threads.push_back(std::thread(print_block, 10, '*'+i));
    }
    for (auto& th : threads) {
        th.join();
    }
}
```

* RUST - Compile-Time Thread Safety
```rust,editable
use std::sync::{Mutex, Arc};
use std::thread;

fn print_block(n: u32, c: char, mtx: Arc<Mutex<()>>) {
    let _guard = mtx.lock().unwrap(); // Lock the mutex

    for _ in 0..n {
        print!("{}", c);
    }
    println!();
} // Mutex is automatically released when _guard goes out of scope

fn main() {
    let mtx = Arc::new(Mutex::new(())); // Create a Mutex

    let mut threads = vec![];
    for i in 0..5 {
        let c = (b'*' + i) as char; // Calculate the character based on ASCII value
        let mtx_clone = Arc::clone(&mtx); // Create a clone of the Mutex for each thread
        threads.push(thread::spawn(move || {
            print_block(10, c, mtx_clone); // Pass the cloned Mutex to the thread
        }));
    }

    for th in threads {
        th.join().unwrap();
    }
}
```
