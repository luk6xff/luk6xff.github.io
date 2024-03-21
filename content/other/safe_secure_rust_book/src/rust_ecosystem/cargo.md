# Cargo

---
- [DEMO](https://github.com/luk6xff/luk6xff.github.io/tree/master/content/other/safe_secure_rust_book/examples/rust_ecosystem/cargo)\

**Cargo** is Rust's build system and package manager. It handles downloading libraries, compiling packages, and more.

**Creating a New Project:**

To create a new Rust project:

```sh
cargo new my_project
cd my_project
```

This creates a new directory called `my_project` with a `Cargo.toml` file (describing the project and its dependencies) and a `src` directory.

**Building Your Project:**

To compile your project:

```sh
cargo build
```

To compile and run your project:

```sh
cargo run
```

**Adding Dependencies:**

To add a dependency, edit your `Cargo.toml` file and include the library under `[dependencies]`. For example, to add the `serde` library:

```toml
[dependencies]
serde = "1.0"
```

After adding a dependency, run `cargo build`, and Cargo will download and compile the new dependency.

**Updating Dependencies:**

To update your project's dependencies:

```sh
cargo update
```

**Testing:**

To run tests defined in your project:

```sh
cargo test
```

**Documentation:**

To build and view documentation for your project's dependencies:

```sh
cargo doc --open
```

**Publishing a Crate:**

To publish a crate to [crates.io](https://crates.io/):

```sh
cargo publish
```

(Note: You'll need to create an account on crates.io and obtain an API token first.)

---
**Testing with Cargo:**

`cargo test` runs all unit tests, integration tests, and documentation tests in your Rust project. Rust makes it easy to write tests by annotating functions with `#[test]`, and `cargo test` automatically finds and executes these tests.

```sh
cargo test
```

This command compiles your code in test mode and runs the specified tests. To run a subset of tests, you can specify their name as an argument:

```sh
cargo test test_name
```

**Linting with Clippy:**

`cargo clippy` is a helpful linting tool that catches common mistakes and suggests improvements to make your Rust code more idiomatic. Clippy extends the compiler's linting capabilities and provides a vast collection of lint checks.

First, you might need to install `clippy` if you haven't already:

```sh
rustup component add clippy
```

Then, to run `clippy` on your project:

```sh
cargo clippy
```

**Automatically Fixing Issues with Cargo Fix:**

`cargo fix` automatically applies fixes to your code for warnings or errors identified by the Rust compiler. This tool is incredibly useful for automatically resolving certain types of compiler warnings and for easing the transition when upgrading to a new Rust edition.

To run `cargo fix`:
cargo
```sh
cargo fix
```

**Formatting Code with Rustfmt:**

`cargo fmt` uses Rustfmt to format your Rust code according to style guidelines. This tool ensures that your code is not only stylistically consistent but also adheres to the community-recommended style practices.

First, ensure `rustfmt` is installed:

```sh
rustup component add rustfmt
```

Then, to format your project:

```sh
cargo fmt
```

This command will automatically format all `.rs` files in your project according to the Rust style guide.

**Summary:**

Together, these Cargo commands enhance your Rust development workflow by ensuring that your code is clean, idiomatic, and well-tested. By integrating these tools into your daily development practices, you can improve the quality and maintainability of your Rust projects.

---
