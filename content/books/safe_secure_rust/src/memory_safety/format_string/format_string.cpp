#include <cstdio>

https://ctf101.org/binary-exploitation/what-is-a-format-string-vulnerability/
https://ir0nstone.gitbook.io/notes/types/stack/format-string
https://lockpin010.medium.com/uncontrolled-format-string-ctf-dec7a9aea747

// Read from Database
int auth = 0;

int main() {
    char passwd[128];

    puts("Provide password: ");
    fgets(passwd, sizeof(passwd), stdin);

    printf("Your password:%x", passwd);
    //printf("Auth is %i\n", auth);

    if(auth == 10) {
        puts("Authenticated!");
    }
}
