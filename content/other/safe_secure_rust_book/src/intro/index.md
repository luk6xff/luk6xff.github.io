# What is this book about?


## Understanding the Secure and Safety Concepts:

**Safety in Coding** (preventing harm to humans by the system):
- Validating inputs to ensure reliability.
- Managing errors effectively.
- Ensuring data is stored and transmitted securely, for instance, using CRC (Cyclic Redundancy Check) and implementing an alive counter.
- Steering clear of potentially hazardous coding practices.
    - **Refer to Coding Guidelines**

**Security in Coding** (protecting the system against malicious human activities):
- Rigorous validation of inputs.
- Robust error management.
- Implementing strong authentication and authorization mechanisms.
- Securing the storage and transmission of data, for example, through CMAC (Cipher-based Message Authentication Code).
- Preventing memory leaks and buffer overflows.
- Avoiding coding practices that pose risks.
    - **Refer to Coding Guidelines**

**Important Note:** While there's an intersection between Safe and Secure Coding practices, they are distinct concepts. Achieving excellence in software for dependable systems necessitates an integration of both approaches.


## Rust as a Safe and Secure System Language

Rust is designed with a strong emphasis on safety and security, addressing many common issues found in systems programming, such as memory errors and concurrency bugs. Its ownership model, borrowing rules, and type system work together to ensure memory safety and thread safety without sacrificing performance.


## What This Book Won't Teach You

While this book is dedicated to exploring the safety and security features of Rust, there are a few things it intentionally doesn't cover:

- **Language Superiority:** The goal of this book is not to declare Rust as superior to C/C++ or any other programming language. Each language has its domain of applicability, strengths, and weaknesses. Rust offers solutions to certain problems, particularly around memory safety and concurrency, but it's not the universal answer to all programming challenges.

- **Rust as the Only Solution:** I acknowledge that many languages, including C and C++, continue to be used effectively in systems programming and other domains. This book focuses on how Rust addresses certain problems, not on diminishing the value of other languages or tools.

- **Comprehensive Language Features:** While I cover many of Rust's safety and security features, this book is not a comprehensive guide to all Rust features. The focus is on aspects that contribute to safe and secure coding practices.

By understanding both the capabilities and limitations of Rust, developers can make informed decisions about when and how to use the language for their projects. Rust is a powerful tool in the software development toolkit, especially for systems programming, but like any tool, its effectiveness depends on how it is used.
