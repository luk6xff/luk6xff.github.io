use zeroize::Zeroize;

static mut PTR: *const u8 = std::ptr::null();

fn print_ptr_memory_address(label: u8) {
    unsafe {
        println!("{label}) Pointer memory address: {:p}", PTR);
        println!("{label}) SensitiveDataMemory: {:x?}", core::slice::from_raw_parts(PTR, 32));
    }
}

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
        self.password.zeroize()
    }
}

fn process_password(pwd: &[u8]) {
    let data = SensitiveData::new(pwd);
    unsafe {
        PTR = data.password.as_ptr();
    }
    // Simulate operations on the sensitive data
    println!("Processing sensitive data...");
    print_ptr_memory_address(1);
}

fn do_other_work() {
    println!("Doing other work...");
    print_ptr_memory_address(3);
}

pub fn main() {
  process_password(b"abcdefghijklmnopqrstuvwxyz123456");
  print_ptr_memory_address(2);
  do_other_work();
}
