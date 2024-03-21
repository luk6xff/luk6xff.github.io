fn main() {

    println!("cargo::rerun-if-changed=src/library.c");
    println!("cargo::rerun-if-changed=src/library.h");
    println!("cargo::rerun-if-changed=build.rs");

    cc::Build::new()
        .file("src/library.c")
        .compile("library");
    // OR
    // let out_dir = env::var("OUT_DIR").unwrap();
    // Command::new("gcc").args(&["src/library.c", "-c", "-fPIC", "-o"])
    //                    .arg(&format!("{}/library.o", out_dir))
    //                    .status().unwrap();
    // Command::new("ar").args(&["crus", "liblibrary.a", "library.o"])
    //                   .current_dir(&Path::new(&out_dir))
    //                   .status().unwrap();
    println!("cargo:rustc-link-search=native=src");
    println!("cargo:rustc-link-lib=static=library");

    // libcrypt: https://manpages.debian.org/testing/libcrypt-dev/crypt.3.en.html
    pkg_config::Config::new().probe("libcrypt").unwrap();
    println!("cargo:rustc-link-lib=crypt");
}
