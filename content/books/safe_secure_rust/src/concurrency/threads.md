# Threads


### Example 1: Thread panics
[GODBOLT](https://godbolt.org/z/4qMv9T8h4)
* CPP
    - Unlike Rust, C++ does not have a built-in mechanism for recovering from a thread that has thrown an exception uncaught within that thread. Therefore, it's important to catch exceptions within any thread to ensure proper cleanup and to prevent the entire program from crashing.
```cpp
#include <iostream>
#include <iostream>
#include <thread>
#include <chrono>
#include <exception>

void thread_function() {
    for (int i = 1; i < 10; ++i) {
        std::cout << "Counting from the other thread: " << i << "!" << std::endl;
        std::this_thread::sleep_for(std::chrono::milliseconds(1));
        if (i == 5) {
            throw std::runtime_error("The other thread panicked!");
        }
    }
}

int main() {
    std::thread t([&]() {
        //%// try {
            thread_function();
        //%//} catch (const std::exception& e) {
        //%//    std::cerr << "Exception from the thread: " << e.what() << std::endl;
        //%//}
    });

    for (int i = 1; i < 10; ++i) {
        std::cout << "Counting from the main thread: " << i << "!" << std::endl;
        std::this_thread::sleep_for(std::chrono::milliseconds(1));
    }

    // Wait for the thread to complete
    t.join();

    return 0;
}
```

* RUST
    - Threads are all daemon threads, the main thread does not wait for them.
    - Thread panics are independent of each other
```rust,editable
use std::thread;
use std::time::Duration;

pub fn main() {

    thread::spawn(|| {
        for i in 1..10 {
            println!("Counting from the other thread: {i}!");
            thread::sleep(Duration::from_millis(1));
            if i == 5 {
                panic!("The other thread panicked!")
            }
        }
    });

    for i in 1..10 {
        println!("Counting from the main thread: {i}!");
        thread::sleep(Duration::from_millis(1));
    }
}
```


### Example 2: Data Race
[GODBOLT](https://godbolt.org/z/YMxxKTof7)
* CPP
    - In C++, concurrent access to the shared variable counter without synchronization leads to a data race, resulting in undefined behavior.
```cpp
#include <iostream>
#include <vector>
#include <thread>
#include <mutex>
#include <memory>

int main() {
    auto counter = 0;
    //%//auto counter = std::make_shared<int>(0); // Shared counter
    std::mutex mutex;

    std::vector<std::thread> handles;

    for (int i = 0; i < 2; ++i) {
        //%//auto counter_copy = counter;
        std::thread handle([&counter, &mutex]() {
            for (int j = 0; j < 1000000; ++j) {
                //%//std::lock_guard<std::mutex> lock(mutex); // Lock the mutex
                counter += 1;
            }
        });
        handles.push_back(std::move(handle)); // Store the thread handle
    }

    // Wait for all threads to complete
    for (auto& handle : handles) {
        handle.join();
    }

    // Safely access the counter one last time to print the final value
    std::lock_guard<std::mutex> lock(mutex);
    std::cout << "Final counter value: " << counter << std::endl;

    return 0;
}
```

* RUST
    - In Rust, Mutex (Mutual Exclusion) ensures that only one thread can access the data at any time, preventing data races.
```rust,editable
use std::sync::{Arc, Mutex};
use std::thread;

pub fn main() {
    #//let counter = Arc::new(Mutex::new(0)); // Mutex for safe concurrent access
    let counter = 0;
    let mut handles = vec![];

    for _ in 0..2 {
        #//let counter = Arc::clone(&counter);
        let handle = thread::spawn(move || {
            #//let mut num = counter.lock().unwrap(); // Lock the mutex
            for _ in 0..1000000 {
                #//*num += 1;
                counter += 1;
            }
        });
        handles.push(handle);
    }

    for handle in handles {
        handle.join().unwrap();
    }

    //println!("Final counter value: {}", *counter.lock().unwrap());
    println!("Final counter value: {}", counter);
}
```

























### Example 3: Deadlock
It demonstrates a simple deadlock, where each thread locks a mutex and then attempts to lock the other, but neither can proceed.
[GODBOLT](https://godbolt.org/z/354ch7z8f)

* CPP
```cpp
#include <iostream>
#include <mutex>
#include <thread>

std::mutex mutex1, mutex2;

void thread1() {
    std::lock_guard<std::mutex> lock1(mutex1);
    std::this_thread::sleep_for(std::chrono::milliseconds(1)); // Simulate work (and ensure deadlock)
    std::lock_guard<std::mutex> lock2(mutex2);
}

void thread2() {
    std::lock_guard<std::mutex> lock2(mutex2);
    std::this_thread::sleep_for(std::chrono::milliseconds(1));
    std::lock_guard<std::mutex> lock1(mutex1);
}

int main() {
    std::thread t1(thread1);
    std::thread t2(thread2);

    t1.join();
    t2.join();

    std::cout << "Finished without deadlock" << std::endl;

    return 0;
}
```

* RUST
```rust,editable
use std::sync::{Arc, Mutex};
use std::thread;

pub fn main() {
    let mutex1 = Arc::new(Mutex::new(0));
    let mutex2 = Arc::new(Mutex::new(0));

    let m1_clone = Arc::clone(&mutex1);
    let m2_clone = Arc::clone(&mutex2);

    let handle1 = thread::spawn(move || {
        let _lock1 = m1_clone.lock().unwrap();
        std::thread::sleep(std::time::Duration::from_millis(10));
        let _lock2 = m2_clone.lock().unwrap();
    });

    let handle2 = thread::spawn(move || {
        let _lock2 = mutex2.lock().unwrap();
        std::thread::sleep(std::time::Duration::from_millis(10));
        let _lock1 = mutex1.lock().unwrap();
    });

    handle1.join().unwrap();
    handle2.join().unwrap();
    println!("Finished without deadlock");
}
```
