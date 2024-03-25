# Uninitialized Variables

### Example 1
[AR, Rule 9.1] The value of an object shouldn't be read if it hasn't been written
[GODBOLT](https://godbolt.org/z/dbP1br3eP)

* CPP
```cpp
#include <cstdio>

bool foo() {
    int var;

    if (var > 0) {
        return true;
    }
    return false;
}

int main() {
    printf("%d\n", foo());
}
```

* RUST
```rust,editable
fn foo() -> bool {
    let var: isize;

    if var > 0 {
        return true;
    }
    return false;
}

pub fn main() {
    println!("{}\n", foo());
}
```
