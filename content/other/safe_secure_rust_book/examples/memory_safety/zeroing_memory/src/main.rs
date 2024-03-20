use std::ptr::write_volatile;
use zeroize::Zeroize;

static mut PTR: *const u8 = std::ptr::null();

struct SensitiveData {
    password: [u8; 32], // Sensitive data
}

impl SensitiveData {
    pub fn new(password: &[u8]) -> Self {
        let mut data = SensitiveData { password: [0; 32] };
        let len = password.len().min(data.password.len());
        data.password[..len].copy_from_slice(&password[..len]);
        data
    }
}

impl Drop for SensitiveData {
    fn drop(&mut self) {
        println!("Zeroing memory");
        // #unsafe {
        // #    write_volatile(&mut self.password, [0u8; 32]);
        // #}
        //self.password.zeroize()
    }
}

fn process_password(pwd: &[u8]) {
    let mut data = SensitiveData::new(pwd);
    unsafe {
        PTR = data.password.as_ptr();
    }
    // Simulate operations on the sensitive data
    println!("Processing sensitive data...");
    data.password[0] = '0' as u8;
    println!("{}", std::str::from_utf8(&data.password).unwrap());
    unsafe {
        println!("1) Pointer memory address: {:p}", PTR);
        println!("1) SensitiveDataMemory: {:x?}", core::slice::from_raw_parts(PTR, 32));
    }
}

fn do_other_work() {
    println!("Doing other work...");
    unsafe {
        println!("2) Pointer memory address: {:p}", PTR);
        println!("2) SensitiveDataMemory: {:x?}", core::slice::from_raw_parts(PTR, 32));
    }
}

pub fn main() {
  process_password(b"abcdefghijklmnopqrstuvwxyz123456");
  do_other_work();
}
