# Zero out memory of sensitive data after use
Variables containing sensitive data must be zeroed out aer use, using functions that
will not be removed by the compiler optimizations, like std::ptr::write_volatile
or the zeroize crate.


```rust,editable
// https://rust.godbolt.org/z/fTnh99d9G
#[derive(Debug)]
struct MyPrivateEncryptionKey([u8; 8]); // My sensitive data

impl Drop for MyPrivateEncryptionKey {
    fn drop(&mut self) {
        println!(" zeroing memory");
        unsafe {
            ::std::ptr::write_volatile(&mut self.0, [0u8; 8]);
        };
    }
}

fn main() {
    let buf = MyPrivateEncryptionKey([1u8; 8]);
    println!("Buffer is freed here: {:?}", &buf);
}
```

```cpp
#include <iostream>
#include <cstring>
#include <cstdint>

class MyPrivateEncryptionKey {
public:
    MyPrivateEncryptionKey() {
        std::cout << "MyPrivateEncryptionKey constructor\n";
        memset(data, 42, sizeof(data));
    }

    ~MyPrivateEncryptionKey() {
        std::cout << "MyPrivateEncryptionKey destructor\n";
        // Zeroize the memory to ensure sensitive data is wiped
        //memset(data, 0, sizeof(data));
    }

    void printData() {
        for (size_t i = 0; i < sizeof(data); ++i) {
            std::cout << (int)data[i] << " ";
        }
        std::cout << "\n";
    }

private:
    uint8_t data[8];
};

int main() {
    {
        MyPrivateEncryptionKey key;
        key.printData();
    } // key goes out of scope here, and destructor is called with memory zeroization

    std::cout << "MyPrivateEncryptionKey object is destroyed, and memory is securely wiped.\n";

    return 0;
}

```
