#include <iostream>
#include <memory>
#include <vector>
#include <thread>
#include <mutex>

class Counter {
public:
    void increment() {
        //%//std::lock_guard<std::mutex> guard(mutex); // Protect access to value
        ++value; // This operation is not thread-safe.
    }

    int getValue() const {
        //%//std::lock_guard<std::mutex> guard(mutex); // Protect access to value
        return value;
    }

private:
    //%//mutable std::mutex mutex; // mutable allows modification in const methods
    int value = 0;
};

void incrementCounter(std::shared_ptr<Counter> counter) {
    for (int i = 0; i < 10000; ++i) {
        counter->increment();
    }
}

int main() {
    constexpr auto num_of_threads = 10;
    auto counter = std::make_shared<Counter>();
    std::vector<std::thread> threads;

    // Create multiple threads that increment the shared counter.
    for (int i = 0; i < num_of_threads; ++i) {
        threads.emplace_back(incrementCounter, counter);
    }

    // Wait for all threads to complete.
    for (auto& thread : threads) {
        thread.join();
    }

    std::cout << "Expected value: " << num_of_threads * 10000 << std::endl;
    std::cout << "Actual value  : " << counter->getValue() << std::endl;

    return 0;
}
