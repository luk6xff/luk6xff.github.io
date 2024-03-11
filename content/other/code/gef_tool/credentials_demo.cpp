#include <iostream>
#include <string>
#include <cstring>
#include <limits>

void admin_panel() {
    std::cout << "<<< Setting up Admin Panel >>>" << std::endl;
    std::system("/bin/bash");
}

void store_credentials_into_db(const char* buf, size_t buf_len) {
    if (buf == nullptr || buf_len == 0) {
        return;
    }
    // Store data ...
}

bool process_credentials() {
    std::cout << ">";
    std::flush(std::cout);

    char buffer[128];
    std::string input;
    if (std::getline(std::cin, input)) {
        std::strncpy(buffer, input.c_str(), input.size());
        buffer[sizeof(buffer) - 1] = '\0';
        store_credentials_into_db(buffer, sizeof(buffer));
    }
    return 0;
}

int main(int argc, char** argv) {
    process_credentials();
    // Do more here ...
    return 0;
}
