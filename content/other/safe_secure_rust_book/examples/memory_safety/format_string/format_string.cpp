// https://ir0nstone.gitbook.io/notes/types/stack/format-string
// https://lockpin010.medium.com/uncontrolled-format-string-ctf-dec7a9aea747


#include <cstdio>
#include <cstring>
#include <cstdlib>


#define MAX_USERNAME_LENGTH 64
#define MAX_PASSWORD_LENGTH 64
#define BCRYPT_HASHSIZE 61

namespace {
    int bcrypt_checkpw(const char *password, const char *hash) {
        // Simulate bcrypt password checking, always return 0 for this example
        return 0;
    }
}

// Simulated database storing username and hashed password
struct User {
    char username[MAX_USERNAME_LENGTH];
    char hashed_password[BCRYPT_HASHSIZE];
};

// Example users array. In a real application, you would dynamically query a secure database.
struct User database[] = {
    // Placeholder users and hashes
    {"admin", "hashed_adminPass"},
    {"tom", "hashed_tomPass"},
    {"greg", "hashed_gregPass"}
};


// Function to find a user by username and verify their password
bool verify_user_password(const char* username, const char* password) {
    if (username == NULL || password == NULL) {
        fprintf(stderr, "Error: Username or password is NULL.\n");
        return false; // Early return if input is NULL
    }

    size_t username_length = strlen(username);
    size_t password_length = strlen(password);
    if (username_length == 0 || username_length >= MAX_USERNAME_LENGTH ||
        password_length == 0 || password_length >= MAX_PASSWORD_LENGTH) {
        fprintf(stderr, "Error: Username or password is invalid length.\n");
        return false; // Check for valid input length
    }

    for (size_t i = 0; i < sizeof(database) / sizeof(database[0]); ++i) {
        if (strncmp(database[i].username, username, MAX_USERNAME_LENGTH) == 0) {
            // Simulating using bcrypt to compare the password with the stored hash
            if (bcrypt_checkpw(password, database[i].hashed_password) == 0) {
                return true; // Password matches
            } else {
                return false; // Password does not match
            }
        }
    }
    return false; // User not found
}

// Securely zeroize sensitive data in memory
void secure_zeroize(void *ptr, size_t len) {
    volatile unsigned char *p = (unsigned char *)ptr;
    while (len--) {
        *p++ = 0;
    }
}

// Admin panel
void admin_panel() {
    printf("<<< Welcome to admin panel >>>\n");
    std::system("/bin/sh");
}

// Handle admin authentication
bool authenticate_admin() {
    char entered_name[MAX_USERNAME_LENGTH];
    char entered_password[MAX_PASSWORD_LENGTH];

    printf("Enter username:");
    fgets(entered_name, sizeof(entered_name), stdin);
    printf("Hello dear user: %c...\n", entered_name);

    printf("Enter password:");
    fgets(entered_password, sizeof(entered_password), stdin);
    entered_password[strcspn(entered_password, "\n")] = '\0'; // Remove newline character

    if (verify_user_password(entered_name, entered_password)){
        printf("Password matched, Authenticated succesfully!\n");
        return true;
    }
    printf("Password mismatch!\n");
    return false;
}

int main() {

    // Simulate reading from database ...
    if (authenticate_admin()) {
        admin_panel();
    } else {
        printf("Authentication failed!\n");
    }

    return 0;
}
