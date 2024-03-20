#include <iostream>
#include <cstring>
#include <cstdint>
#include <cstdio>
#include <functional>

static uint8_t* ptr = nullptr;

void print_ptr_memory_address(uint8_t label) {
    printf("%d) Pointer memory address: %p\n", label, ptr);
    printf("%d) SensitiveDataMemory: [", label);
    for (size_t i = 0; i < 32; ++i) {
        printf("%02x ", ptr[i]);
    }
    printf("]\n");
}


struct SensitiveData {
    char password[32]; // Sensitive data

    SensitiveData(const char* pwd) {
        strncpy(password, pwd, sizeof(password) - 1);
        password[sizeof(password) - 1] = '\0';
    }

    ~SensitiveData() {
        std::cout << "Zeroing memory" << std::endl;
        memset(password, 0, sizeof(password));

        //% volatile char *p = password;
        //% for (size_t i = 0; i < sizeof(password); i++) {
        //%     *(p + i) = 0;
        //% }
    }
};

void process_password(const char* pwd) {
    SensitiveData data(pwd);
    ptr = reinterpret_cast<uint8_t*>(data.password);
    // Simulate operations on the sensitive data
    std::cout << "Processing sensitive data..." << std::endl;
    print_ptr_memory_address(1);

}

void do_other_work() {
    std::cout << "Doing other work..." << std::endl;
    print_ptr_memory_address(3);
}

int main() {
    process_password("abcdefghijklmnopqrstuvwxyz123456");
    print_ptr_memory_address(2);
    do_other_work();
    return 0;
}
