#include <iostream>
#include <cstring>
#include <cstdint>
#include <string>
#include <functional>

struct PrivateData
{
  size_t hash;
  char password[100];
};

bool validatePassword(PrivateData& data)
{
  std::string s(data.password);
  std::hash<std::string> hash_fn;
  data.hash = hash_fn(s);
  // Compare with database ...
  return true;
}

void processPassword()
{
  PrivateData* data = new PrivateData();
  std::cin >> data->password;
  validatePassword(*data);
  memset(data, 0, sizeof(PrivateData));
  delete data;
}

int main()
{
  processPassword();
  return 0;
}
