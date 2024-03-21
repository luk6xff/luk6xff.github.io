use std::os::raw::{c_char};

// 1) Print "Hello from C" using FFI
extern "C" {
    fn print_hello_from_c();
}

fn safe_print_hello() {
    unsafe {
        print_hello_from_c(); // Unsafe FFI call
    }
}

// 2) Libcrypt - “hash” a string using FFI
extern "C" {
    pub fn crypt(phrase: *const c_char, setting: *const c_char) -> *mut c_char;
}

fn safe_crypt(input: &str, salt: &str) -> String {
    let c_input = std::ffi::CString::new(input).expect("CString::new failed for input");
    let c_salt = std::ffi::CString::new(salt).expect("CString::new failed for salt");

    let result_ptr = unsafe { crypt(c_input.as_ptr(), c_salt.as_ptr()) };

    assert!(!result_ptr.is_null(), "crypt returned a null pointer");

    let result_cstr = unsafe { std::ffi::CStr::from_ptr(result_ptr) };
    result_cstr.to_string_lossy().into_owned()
}

fn main() {
    // 1)
    safe_print_hello(); // Safe to call
    // 2)
    let input = "hello world";
    let salt = "somesalt"; // Example for SHA-512 based on Linux's glibc
    let encrypted = safe_crypt(input, salt);
    println!("Encrypted: {}", encrypted);
}
