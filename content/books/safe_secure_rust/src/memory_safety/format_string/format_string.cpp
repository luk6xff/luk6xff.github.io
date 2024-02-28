// https://ctf101.org/binary-exploitation/what-is-a-format-string-vulnerability/
// https://ir0nstone.gitbook.io/notes/types/stack/format-string
// https://lockpin010.medium.com/uncontrolled-format-string-ctf-dec7a9aea747

#define MAX_PASSWD_LENGTH 128

#include <cstdio>
#include <cstring>
#include <cstdlib>

// Read from Database
bool read_passwd_from_db(char* buffer, int length) {
    if (buffer == NULL || length <= 0 || length > MAX_PASSWD_LENGTH) {
        return false;
    }
    // Simulate reading from database ...
    snprintf(buffer, length, "admin123");
    return false;
}

// Securely compare two strings in constant time
int secure_strcmp(const char *str1, const char *str2, size_t len) {
    int result = 0;
    for (size_t i = 0; i < len; ++i) {
        result |= str1[i] ^ str2[i];
    }
    return result;
}

// Securely zeroize sensitive data in memory
void secure_zeroize(void *ptr, size_t len) {
    volatile unsigned char *p = (unsigned char *)ptr;
    while (len--) {
        *p++ = 0;
    }
}

int main() {
    char password[MAX_PASSWD_LENGTH];
    char entered_username[MAX_PASSWD_LENGTH];
    char entered_password[MAX_PASSWD_LENGTH];

    printf("Enter username: ");
    fgets(entered_username, sizeof(entered_username), stdin);
    printf("Hello dear user: %c...\n", entered_username);

    printf("Enter password: ");
    fgets(entered_password, sizeof(entered_password), stdin);
    entered_password[strcspn(entered_password, "\n")] = '\0'; // Remove newline character
    // Simulate reading from database ...
    (void)read_passwd_from_db(password, sizeof(password));

    // Securely compare passwords
    if (strlen(password) == strlen(entered_password) &&
        secure_strcmp(password, entered_password, strlen(password)) == 0) {
        printf("Password matched, Authenticated succesfully!\n");

        // Zeroize entered_password after use
        secure_zeroize(entered_password, sizeof(entered_password));
    } else {
        printf("Password mismatch!\n");
    }

    // Zeroize password after use
    secure_zeroize(password, sizeof(password));

    return 0;
}
