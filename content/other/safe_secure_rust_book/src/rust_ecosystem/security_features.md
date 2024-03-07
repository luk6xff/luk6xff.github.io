# Rust Ecosystem Security Features


## Dependency Auditing
The Rust compiler, combined with Cargo, Rust's package manager, provides tools for auditing dependencies for known vulnerabilities. This is crucial for maintaining the security of Rust applications, given the extensive use of external crates.

#### cargo audit
- DEMO: Run `run.sh audit` in [DEMO](https://github.com/luk6xff/luk6xff.github.io/tree/master/content/other/safe_secure_rust_book/examples/rust_ecosystem/cargo)
The `cargo audit` command checks your Cargo.lock file against the [RustSec Advisory Database](https://rustsec.org/advisories/) to find vulnerable package versions, helping you keep dependencies up-to-date and secure.
```sh
# Install
cargo install cargo-audit --features=fix
# Run
cargo audit
cargo audit fix
```

#### cargo auditable
- DEMO: Run `run.sh auditable` in [DEMO](https://github.com/luk6xff/luk6xff.github.io/tree/master/content/other/safe_secure_rust_book/examples/rust_ecosystem/cargo)
`cargo auditable` - is a Rust tool that enhances security by embedding dependency information directly into compiled binaries. This allows for auditing Rust binaries for known vulnerabilities without needing the original source code or Cargo.lock file. By including auditable as a dependency in your Cargo.toml, the compilation process automatically incorporates a summary of all project dependencies into the resulting binary. This works by embedding data about the dependency tree in JSON format into a dedicated linker section of the compiled executable (`.dep-v0`). Linux, Windows and Mac OS are officially supported.
```sh
# Install
cargo install cargo-auditable
# Build your project with dependency lists embedded in the binaries
cargo auditable build --release
# Scan the binary for vulnerabilities
cargo audit bin target/release/car_project

# Check for the `dep-v0` section
readelf -S target/release/car_project
readelf -p .dep-v0 target/release/car_project
# Decompress zlib section content
objdump -s -j .dep-v0 target/release/car_project | grep '^ ' | cut -c7-42 | xxd -r -p | python3 -c "import sys, zlib; sys.stdout.buffer.write(zlib.decompress(sys.stdin.buffer.read()))"
```


## Compiler

### Sanitizers
- DEMO: Run `run.sh` in [DEMO](https://github.com/luk6xff/luk6xff.github.io/tree/master/content/other/safe_secure_rust_book/examples/rust_ecosystem/compiler_flags)
Rust compiler supports use of one of following sanitizers:

- **AddressSanitizer**: A memory error detector. It can detect the following types of bugs:
    - Out of bound accesses to heap, stack and globals
    - Use after free
    - Use after return (runtime flag ASAN_OPTIONS=detect_stack_use_after_return=1)
    - Use after scope
    - Double-free, invalid free
    - Memory leaks

- **ControlFlowIntegrity (CFI)**: LLVM's Control Flow Integrity provides forward-edge control flow protection, preventing unauthorized code paths from being executed.

- **HWAddressSanitizer**: Similar to AddressSanitizer, this tool uses partial hardware assistance for detecting memory errors. It's particularly useful for catching complex memory corruption bugs with minimal overhead.

- **KernelControlFlowIntegrity (KCFI)**: An extension of LLVM's Control Flow Integrity aimed at operating system kernels, providing robust forward-edge control flow protection at the kernel level.

- **LeakSanitizer**: A runtime memory leak detector that helps identify and report memory leaks in applications, facilitating easier memory management debugging.

- **MemorySanitizer**: Specialized in detecting uninitialized memory reads, this tool helps prevent undefined behaviors arising from the use of uninitialized memory.

- **MemTagSanitizer**: Leveraging the Armv8.5-A Memory Tagging Extension, this tool offers fast and efficient detection of memory errors, enhancing application security with hardware support.

- **SafeStack**: Implements backward-edge control flow protection by segregating the application's stack into safe and unsafe regions, thus protecting against stack-based attacks.

- **ShadowCallStack**: Provides backward-edge control flow protection on aarch64 architectures by maintaining a separate, secure call stack, further mitigating the risk of return-oriented programming (ROP) attacks.

- **ThreadSanitizer**: A data race detector that quickly identifies threading issues in applications, promoting safer concurrent programming practices.

To enable a `sanitizer` compile with the following flags:
```sh
-Zsanitizer=address
-Zsanitizer=cfi
-Zsanitizer=hwaddress
-Zsanitizer=leak
-Zsanitizer=memory
-Zsanitizer=memtag
-Zsanitizer=shadow-call-stack
-Zsanitizer=thread.
# Add also:
--target
-Zbuild-std
```

* ASAN example:
```sh
export RUSTFLAGS=-Zsanitizer=address RUSTDOCFLAGS=-Zsanitizer=address
cargo run -Zbuild-std --target x86_64-unknown-linux-gnu
```

* ASAN example:
```sh
export RUSTFLAGS=-Zsanitizer=address RUSTDOCFLAGS=-Zsanitizer=address
cargo run -Zbuild-std --target x86_64-unknown-linux-gnu
```


### Rust Compiler exploit mitigations
The Rust programming language offers memory and thread safety through features like ownership, references, borrowing, and slices. However, Unsafe Rust introduces constructs such as unsafe blocks, functions, methods, traits, and types, which bypass Rust's safety guarantees.

Certain parts of the Rust standard library are built on top of unsafe code, potentially leading to memory corruption vulnerabilities. Moreover, Rust encourages creating safe abstractions over unsafe code, which may give a false sense of security if the unsafe code isn't thoroughly reviewed and tested.

Unsafe Rust introduces features that lack memory and thread safety guarantees, making programs or libraries susceptible to memory corruption (CWE-119) and concurrency issues (CWE-557). To address this, Rust compiler needs to support exploit mitigations similar to those found in modern C and C++ compilers. This part details these exploit mitigations and their application in Rust.







