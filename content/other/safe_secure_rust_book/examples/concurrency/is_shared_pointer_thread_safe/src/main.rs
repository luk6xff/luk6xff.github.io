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
        let counter_clone = Arc::clone(&counter);
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
