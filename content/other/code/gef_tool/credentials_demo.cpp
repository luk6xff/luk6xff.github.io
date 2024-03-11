#include <iostream>
#include <string>
#include <cstring>
#include <limits>

void admin_panel() {
    std::cout << "<<< Setting up Admin Panel >>>" << std::endl;
    std::system("/bin/sh");
}

void store_credentials_into_db(const char* buf, size_t buf_len) {
    if (buf == nullptr || buf_len == 0) {
        return;
    }
    // Store data ...
}

void process_credentials() {
    std::cout << ">";
    std::flush(std::cout);

    // 1)
    char buffer[128];
    std::cin >> buffer;
    buffer[sizeof(buffer) - 1] = '\0';
    store_credentials_into_db(buffer, sizeof(buffer));

    // 2)
    // char buffer[128];
    // std::string input;
    // std::cin >> input;
    // std::strncpy(buffer, input.c_str(), input.size());
    // if (input.size() > 0) {
    //     std::strncpy(buffer, input.c_str(), input.size());
    //     buffer[sizeof(buffer) - 1] = '\0';
    //     store_credentials_into_db(buffer, sizeof(buffer));
    // }
}

int main() {
    process_credentials();
    return 0;
}
