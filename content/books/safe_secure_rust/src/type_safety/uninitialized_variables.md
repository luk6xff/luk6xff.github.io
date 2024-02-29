# Uninitialized Variables

### Example 1
[GODBOLT](https://godbolt.org/z/K4Mn3fzGf)

* CPP
```cpp
#include <cstdio>

bool foo() {
    int var;

    if (var > 0) {
        return true;
    }
    return 0;
}

int main() {
    printf("%d\n", foo());
}
```

* RUST
```rust,editable
fn foo() -> isize {
    let var: isize;

    if var > 0 {
        return 1;
    }
    return 0;
}

pub fn main() {
    println!("{}\n", foo());
}
```

* [AR, Rule 9.1] The value of an object shouldn't be read if it hasn't been written
