// Define a module for the stack buffer overflow example
#[cfg(feature = "asan")]
mod asan_example {
    pub fn main() {
        let buf = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
        let _v = unsafe { *buf.as_ptr().offset(11) };
    }
}

// Define a module for the race condition example
#[cfg(feature = "thread")]
mod thread_example {
    static mut MY_VERY_SAFE_GLOBAL: u32 = 0;

    pub fn main() {
        let t = std::thread::spawn(|| unsafe {
            MY_VERY_SAFE_GLOBAL += 1;
        });
        unsafe {
            MY_VERY_SAFE_GLOBAL += 1;
        }

        t.join().unwrap();
    }
}

fn main() {
    #[cfg(feature = "asan")]
    asan_example::main();

    #[cfg(feature = "thread")]
    thread_example::main();
}
