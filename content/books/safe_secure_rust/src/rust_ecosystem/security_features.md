# Rust Ecosystem Security Features


## Dependency Auditing
The Rust compiler, combined with Cargo, Rust's package manager, provides tools for auditing dependencies for known vulnerabilities. This is crucial for maintaining the security of Rust applications, given the extensive use of external crates.

#### cargo audit
- DEMO: Run `run.sh audit`
The `cargo audit` command checks your Cargo.lock file against the [RustSec Advisory Database](https://rustsec.org/advisories/) to find vulnerable package versions, helping you keep dependencies up-to-date and secure.
```sh
# Install
cargo install cargo-audit --features=fix
# Run
cargo audit
cargo audit fix
```

#### cargo auditable
- DEMO: Run `run.sh auditable`
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
# Decompress zlib content
objdump -s -j .dep-v0 target/release/car_project | grep '^ ' | cut -c7-42 | xxd -r -p | python3 -c "import sys, zlib; sys.stdout.buffer.write(zlib.decompress(sys.stdin.buffer.read()))"

```




## Compiler
Rust utilizes compiler and operating system security features such as:
* Stack canaries
* Address Space Layout Randomization (ASLR)
* Data Execution Prevention (DEP) to make exploiting buffer overflows more difficult.
