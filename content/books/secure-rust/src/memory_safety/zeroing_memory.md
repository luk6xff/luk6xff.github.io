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
#include <string>
#include <functional>

struct PrivateData
{
  size_t hash;
  char password[100];
};

bool validatePassword(PrivateData& data)
{
  std::string s(data.pswd);
  std::hash<std::string> hash_fn;
  data.hash = hash_fn(s);
  // Cimpare with database
  return true;
}

void processPassword()
{
  PrivateData* data = new PrivateData();
  std::cin >> data->m_pswd;
  validatePassword(*data);
  memset(data, 0, sizeof(PrivateData));
  delete data;
}

int main()
{
  processPassword();
  return 0;
}

```
