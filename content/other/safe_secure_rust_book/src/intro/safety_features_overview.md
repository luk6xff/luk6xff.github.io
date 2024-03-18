# Rust Compiler Safety Features Overview

Rust's compiler is designed with safety as a primary goal, employing several key features to prevent common bugs and security vulnerabilities that plague systems programming. These features enforce strict compile-time checks, ensuring that only safe code gets executed unless explicitly marked otherwise. Below, we explore some of Rust's compiler safety features with examples.



## Ownership and Borrowing

Rust's unique approach to memory management is enforced at compile time through its ownership and borrowing system, which eliminates a wide array of bugs related to memory usage, such as dangling pointers, double frees, and memory leaks.

### Example: Ownership 1
[GODBOLT](https://godbolt.org/z/89PPW7oT6)
```rust,editable
fn main() {
    let a: String = String::from("Hello");
    let b = a; // a's ownership is moved to b
    println!("{}", b);
    // println!("{}", a); // This line would cause a compile-time error
}
```
```cpp
#include <iostream>
#include <string>

int main() {
    std::string a = "hello";
    std::string b = a;  // Duplicate the data in a.
    std::cout << b << std::endl;
    std::cout << a << std::endl;
    return 0;
}
```

### Example: Ownership 2
```rust,editable
fn greet(name: String) {
    println!("Hello {name}")
}

fn main() {
    let name = String::from("Tom");
    greet(name);
    // greet(name);
}
```
In this example, the ownership of the string `a` is moved to `b`. Attempting to use `a` after this point results in a compile-time error, preventing use-after-move bugs.


### Example: Borrowing 1
```rust,editable
fn calculate_length(s: &String) -> usize {
    s.len()
}

fn main() {
    let a = String::from("Hello");
    let len = calculate_length(&a); // a is borrowed
    println!("The length of '{}' is {}.", a, len); // a can still be used here
}
```
Here, `a` is borrowed by `calculate_length`, allowing `a` to be used afterward because it wasn't moved but merely borrowed.


### Example: Borrowing 2
```rust,editable
fn append_world(s: &mut String) {
    s.push_str(" world"); // s is now a mutable reference, allowing us to modify the original String
}

fn main() {
    let mut a = String::from("Hello");
    append_world(&mut a); // a is mutably borrowed
    println!("The new value of 'a' is {}.", a); // a can still be used here because the mutable borrow ends at the end of the `append_world` scope
}
```
Here, `a` is mutably borrowed by `append_world`, allowing `a` to be modified inside and to be used afterward.




## Lifetimes
In Rust, references have lifetimes that ensure they don't outlive the data they point to, thanks to the borrow checker. Lifetimes can be:

- **Implicit**, where Rust automatically figures out the lifespan of references for you.
- **Explicit**, used in complex scenarios, where you guide Rust with lifetime annotations (like `'a`) to resolve ambiguities.

The compiler uses these annotations to enforce safe reference usage, preventing errors related to invalid data access. Essentially, Rust's system manages reference validity for you, stepping in only when you need to clarify lifetimes in tricky situations.

### Example 0: Borrow Checker
```rust,editable
fn main() {
    let result;                     // ---------+-- 'a
    {                               //          |
        let tmp = 42;               // -+-- 'b  |
        result = &tmp;              //  |       |
    }                               // -+       |
    println!("result: {}", result); //          |
}                                   // ---------+
```
In this example, the variable `result` is intended to have a longer lifetime, labeled `'a`, extending over the entire `main` function. Inside a nested block, we create `tmp` with a shorter lifetime, `'b`. We attempt to assign a reference to `tmp` to `result`. However, `'b` is much shorter than `'a` because `tmp` goes out of scope once the block ends, but `result` is used outside of this block.

Rust checks lifetimes at compile time and identifies that `result` is supposed to live longer than `tmp`, based on their respective scopes. Since `result` is a reference to `tmp`, which has a shorter lifespan, Rust prevents this by design, to avoid dangling references. Essentially, Rust disallows the program because the data `result` points to (`tmp`) does not exist for the entirety of `result`'s lifetime. This ensures memory safety by preventing access to invalid or deallocated memory.

### Example 1:
```rust,editable
fn longest<'a>(x: &'a str, y: &'a str) -> &'a str {
    if x.len() > y.len() {
        x
    } else {
        y
    }
}

fn main() {
    let string1 = String::from("abcd");
    {
        let string2 = "xyz";

        let result = longest(string1.as_str(), string2);
        println!("The longest string is {}", result);
    }
}
```
This function signature tells Rust that the returned reference will live as long as the `shortest` of the two input references, ensuring the reference is valid for the duration of its use.

### Example 2:
```rust,editable
struct User<'a> {
    username: &'a str,
}

struct Tweet<'a> {
    content: &'a str,
    author: &'a User<'a>,
}

impl<'a> Tweet<'a> {
    fn is_tweet_by_user(&self, user: &'a User) -> bool {
        self.author.username == user.username
    }
}

fn main() {
    let user = User { username: "johndoe" };
    let tweet = Tweet {
        content: "Hello, world!",
        author: &user,
    };

    if tweet.is_tweet_by_user(&user) {
        println!("This tweet is by {}", user.username);
    } else {
        println!("This tweet is not by {}", user.username);
    }
}
```
This example demonstrates how explicit lifetime annotations guide the Rust compiler to enforce memory safety in scenarios where relationships between data (like tweets and their authors) are managed through references.
I have created a `User` and a `Tweet` structs, then use the method `is_tweet_by_user` to check if the tweet was authored by the user. This entire flow is safe thanks to Rust's lifetimes, ensuring the references in Tweet and User are valid when accessed.


## Match Control Flow

The `match` control flow construct forces handling of all possible cases when used with enums, reducing the chances of bugs from unhandled cases.

### Example: Match with Enums

```rust
enum Command {
    Start(String), // Contains a message
    Stop,
    Restart { delay_secs: u32 }, // Contains named fields
}

fn execute_command(command: Command) {
    match command {
        Command::Start(message) => println!("Starting: {}", message),
        Command::Stop => println!("Stopping"),
        Command::Restart { delay_secs } => println!("Restarting in {} seconds", delay_secs),
        _ => println!("Unknown Command!"),
    }
}

fn main() {
    let start_command = Command::Start(String::from("Hackathon 2024"));
    execute_command(start_command);

    let stop_command = Command::Stop;
    execute_command(stop_command);

    let restart_command = Command::Restart { delay_secs: 5 };
    execute_command(restart_command);
}
```



## Safe Concurrency

Rust's ownership and type system ensure safe concurrency, preventing data races at compile time.

### Example: Safe Concurrency

```rust,editable
use std::sync::{Arc, atomic::{AtomicUsize, Ordering}};
use std::thread;

fn main() {
    let counter = Arc::new(AtomicUsize::new(0));
    let mut handles = vec![];

    for _ in 0..10 {
        let counter_clone = Arc::clone(&counter);
        let handle = thread::spawn(move || {
            // Safely increment the counter
            counter_clone.fetch_add(1, Ordering::Relaxed);
        });
        handles.push(handle);
    }

    for handle in handles {
        handle.join().unwrap();
    }

    println!("Counter: {}", counter.load(Ordering::Relaxed));
}
```
This example uses `Arc` (Atomic Reference Counting) to safely share and access data across threads.



## Conclusion

Rust's compiler safety features are central to its promise of safe systems programming, effectively addressing many of the pitfalls common in other languages. Through ownership, lifetimes, match statements, and safe concurrency, Rust empowers developers to write more reliable and secure code by default, catching potential errors early in the development cycle. These features, backed by a thorough compile-time checking system, make Rust an appealing choice for projects where safety and performance are paramount.
