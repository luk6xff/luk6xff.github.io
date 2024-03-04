# Rust Ecosystem Security Features


## Dependency Auditing
The Rust compiler, combined with Cargo, Rust's package manager, provides tools for auditing dependencies for known vulnerabilities. This is crucial for maintaining the security of Rust applications, given the extensive use of external crates.
The cargo audit command checks your Cargo.lock file against the [RustSec Advisory Database](https://rustsec.org/advisories/) to find vulnerable package versions, helping you keep dependencies up-to-date and secure.
```sh
# Install
cargo add cargo-audit
cargo install cargo-audit --features=fix
# Run
cargo audit
cargo audit fix
```
- DEMO: Run `run.sh audit`

## Compiler
Rust utilizes compiler and operating system security features such as:
* Stack canaries
* Address Space Layout Randomization (ASLR)
* Data Execution Prevention (DEP) to make exploiting buffer overflows more difficult.
