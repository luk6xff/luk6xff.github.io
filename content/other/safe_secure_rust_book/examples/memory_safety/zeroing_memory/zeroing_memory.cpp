#include <iostream>
#include <cstring>
#include <cstdint>
#include <functional>

struct SensitiveData {
    char password[32]; // Sensitive data

    SensitiveData(const char* pwd) {
        strncpy(password, pwd, sizeof(password) - 1);
        password[sizeof(password) - 1] = '\0';
    }

    ~SensitiveData() {
        std::cout << "Zeroing memory" << std::endl;
        memset(password, 0, sizeof(password));
        //%volatile char *p = password;
        //%for (size_t i = 0; i < sizeof(password); i++) {
        //%    *(p + i) = 0;
        //%}
    }
};

void process_password(const char* pwd) {
    SensitiveData data(pwd);
    // Simulate operations on the sensitive data
    std::cout << "Processing sensitive data..." << std::endl;
}

void do_other_work() {
    std::cout << "Doing other work..." << std::endl;
}

int main() {
    process_password("abcdefghijklmnopqrstuvwxyz123456");
    do_other_work();
    return 0;
}
