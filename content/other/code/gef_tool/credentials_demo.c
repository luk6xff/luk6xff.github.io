#include <stdio.h>

void process_credentials() {
    char buffer[40];

    puts("Overflow me");
    gets(buffer);
}

int main() {
    process_credentials();
    return 0;
}

void admin_panel() {
    puts(">>>>>>Exploited!!!!!");
    system("/bin/sh");
}
