#include <iostream>
#include <memory>

#include <iostream>
#include <memory>

bool is_limit_reached(int speed_limit) {

    int current_speed = 0;

    for (int factor = 0; factor < 100; ++factor) {
        //%// std::unique_ptr<int> ptr = std::make_unique<int>(10); // Correct way to aloacte memory with automatic deallocation
        int* ptr = new int(2);
        std::cout << "Allocated memory at address: " << ptr << std::endl;
        current_speed += (factor + *ptr);
        //%// delete ptr; // Correct way to deallocate memory
    }

    int* ptr = new int(10);
    current_speed += *ptr;
    if (current_speed > speed_limit) {
        //%// delete ptr; // Correct way to deallocate memory
        return true;
    }

    delete ptr;
    return false;
}

int main() {
    if (is_limit_reached(120)) {
        std::cout << "Speed Limit exceeded." << std::endl;
    }
    return 0;
}
