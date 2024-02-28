### Example 1: Simple Memory Leak
- [GODBOLT](https://godbolt.org/z/beGf1Mn9a)
- [DEMO](https://github.com/luk6xff/luk6xff.github.io/tree/master/content/books/safe_secure_rust/src/memory_safety/format_string)
* C
```cpp
#include <cstdio>

// Read from Database
int auth = 0;

int main() {
    char passwd[100];

    puts("passwd: ");
    fgets(passwd, sizeof(passwd), stdin);

    printf(passwd);
    //printf("Auth is %i\n", auth);

    if(auth == 10) {
        puts("Authenticated!");
    }
}
```
