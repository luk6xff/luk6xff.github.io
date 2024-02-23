#### Rustup (`rust_ecosystem/rustup.md`)

---

**Rustup** is the Rust toolchain installer. It manages Rust versions and associated tools, making it easy to switch between stable, beta, and nightly compilers and ensure that you have the latest updates.

**Installation:**

To install Rustup and the default Rust toolchain, you can run:

```sh
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

This command downloads a script and starts the installation process, which includes the Rust compiler (`rustc`), the Rust package manager (`cargo`), and the standard library.

**Managing Toolchains:**

To list installed toolchains:

```sh
rustup toolchain list
```

To install a specific version of the Rust toolchain:

```sh
rustup toolchain install stable
rustup toolchain install nightly
```

To switch the default toolchain:

```sh
rustup default nightly
```

**Updating Rust:**

To update all installed toolchains:

```sh
rustup update
```

**Cross-compilation:**

To add a target for cross-compilation:

```sh
rustup target add x86_64-unknown-linux-gnu
```

**Uninstallation:**

To uninstall Rust and Rustup:

```sh
rustup self uninstall
```
