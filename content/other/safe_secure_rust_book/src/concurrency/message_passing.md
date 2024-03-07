# Message passing to transfer data between threads

### Example 1:
[GODBOLT](https://godbolt.org/z/9jKdG1soq)
* CPP
    - C++ does not have a direct equivalent to Rust's channels in the standard library, but we can achieve similar message passing between threads using a combination of mutexes, condition variables, and a queue.
```cpp
#include <iostream>
#include <thread>
#include <vector>
#include <string>
#include <queue>
#include <mutex>
#include <condition_variable>
#include <chrono>

class SafeQueue {
public:
    void push(std::string value) {
        std::lock_guard<std::mutex> lock(m_mutex);
        m_queue.push(std::move(value));
        m_cond.notify_one(); // Notify one waiting thread
    }

    std::string pop() {
        std::unique_lock<std::mutex> lock(m_mutex);
        m_cond.wait(lock, [this] { return !m_queue.empty(); }); // Wait until the queue is not empty
        auto value = m_queue.front();
        m_queue.pop();
        return value;
    }

private:
    std::queue<std::string> m_queue;
    mutable std::mutex m_mutex;
    std::condition_variable m_cond;
};

int main() {
    SafeQueue queue;

    // Producer thread
    std::thread producer([&queue]() {
        std::vector<std::string> vals = {
            "111",
            "222",
            "333",
            "444",
        };

        for (auto& val : vals) {
            queue.push(val);
            std::this_thread::sleep_for(std::chrono::seconds(1));
        }
    });

    // Consumer thread
    std::thread consumer([&queue]() {
        for (int i = 0; i < 4; ++i) { // Expecting 4 messages
            auto received = queue.pop();
            std::cout << "Got: " << received << std::endl;
        }
    });

    producer.join();
    consumer.join();

    return 0;
}
```

* RUST
```rust,editable
use std::thread;
use std::sync::mpsc;
use std::time::Duration;

pub fn main() {
    let (producer, consumer) = mpsc::channel();

    thread::spawn(move || {
        let vals = vec![
            String::from("111"),
            String::from("222"),
            String::from("333"),
            String::from("444"),
        ];

        for val in vals {
            producer.send(val).unwrap();
            thread::sleep(Duration::from_secs(1));
        }
    });

    thread::spawn(move || {
        for received in consumer {
            println!("Got: {}", received);
        }
    }).join().unwrap(); // Wait for the consumer thread to finish processing
}
```
