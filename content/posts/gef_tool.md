+++
title="GEF - A better GDB"
date=2022-10-18

[taxonomies]
categories = ["tools","cybersecurity"]
tags = ["tools","cybersecurity"]
+++


## A Quick Guide to Using GEF for Debugging

Debugging is like being a detective for software, where you hunt for clues to fix problems in code. GEF makes this detective work easier and more effective, especially when you're dealing with tricky bugs or trying to understand how a program really works. Let's break down how GEF can help you and how to get started with it.

## What is GEF?

GEF is a tool that adds extra powers to GDB, the GNU Debugger, which is a tool many developers use to find bugs in their programs. GEF makes GDB more user-friendly and powerful by adding new features, such as better visuals, more information about your program's status, and tools to check the security of your software.

## Why Should You Use GEF?

GEF makes your life easier when you're debugging:

- **Clearer Information**: It shows you what's going on in your program more clearly, making it easier to understand problems.
- **Better Control**: You get more ways to stop and inspect your program exactly where and when you need to.
- **Find Bugs Faster**: GEF has special features to help spot common mistakes that can lead to bugs.

## Getting Started with GEF

### Setting Up

First, you need GDB installed. Then, to add GEF, you run a simple command in your terminal:

```bash
bash -c "$(curl -fsSL http://gef.blah.cat/sh)"
```

This command gets GEF set up with your GDB, and you're ready to go!

### Using GEF

To start debugging a program with GEF, you open your terminal and type:

```bash
gdb -q ./your_program
```

This command starts GDB like usual, but you'll notice GEF's improvements right away.

### Helpful Features

- **`context`**: This shows a snapshot of what's happening in your program, like what the computer is currently working on and what data it's handling.
- **`heap`**: If your program uses dynamic memory (allocating memory during runtime), this command helps you see how that memory is being used or misused.
- **`pattern create` / `pattern search`**: These commands help you figure out how data is laid out in memory, which is super useful for finding certain types of bugs.
- **`checksec`**: This command checks the security properties of your executable, providing insights into potential vulnerabilities, such as stack canaries or NX bits.
- **`gef config / gef save`**: Customize and save your GEF environment to streamline your debugging sessions, tailoring the tool to your needs.
- **`dereference`**: Offers a more intuitive view of pointers and memory addresses, making it easier to navigate through complex structures.
- **`registers`**: Get a quick overview of the current state of CPU registers, which is crucial for low-level debugging


### Debugging with GEF: A Quick Example

Imagine you have a program that's not working right, and you suspect it's due to a bug where the program is trying to access memory it shouldn't. Here's how you might use GEF to find that bug:

1. **Start GEF with your program**: `gdb -q ./buggy_program`
2. **Set a breakpoint**: This is like telling GEF, "Pause here; I want to check something." You can do this with the command `break main` if you want to stop right when the main function starts.
3. **Run the program**: Just type `run` and hit enter. The program will start and then pause where you set the breakpoint.
4. **Step through the code**: Use the `next` command to go through your program one line at a time. Watch the `context` information GEF gives you to see what the program is doing.
5. **Inspect memory**: If you think the bug is happening because the program is accessing memory it shouldn't, you can use commands like `x/gx`, `heap chunks`, and `search-pattern` to explore and manipulate memory at runtime, helping uncover issues like memory leaks or corruption.
6. **Scripting**: Automate repetitive analysis tasks or implement custom logic for complex debugging scenarios using Python scripts.

Through this process, GEF gives you a clearer view of what's happening inside your program, helping you spot and fix the bug.

## Real world example
Let's try to use `gef` in action:
I have a following code simulating buffer overflow issue:
```cpp
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

    char buffer[128];
    std::cin >> buffer;
    buffer[sizeof(buffer) - 1] = '\0';
    store_credentials_into_db(buffer, sizeof(buffer));
}

int main() {
    process_credentials();
    return 0;
}

```
Debugging the provided C++ code with GEF (GDB Enhanced Features) will allow you to understand the execution flow, examine variables, and potentially identify vulnerabilities or logical errors. Below are steps on how to debug this C++ program using GEF, focusing on key points like setting breakpoints, stepping through the code, and inspecting the memory and variables.

#### Step 1: Compile the Program with Debugging Information

First, compile the C++ program (full example available:[HERE](https://github.com/luk6xff/luk6xff.github.io/tree/master/content/other/code/gef_tool)): with debugging information enabled (`-g`) and disable optimizations (`-O0`) to ensure that you can inspect the source code as is during debugging.

```bash
cd gef_tool && ./build.sh
```

#### Step 2: Start and analyze GEF with the Program

- Open a terminal and start GEF with your compiled program:
```bash
gdb -q ./build/credentials_demo
```
- Check the binary security flags by `checksec`:
```sh
checksec
    Canary                        : ✘
    NX                            : ✘
    PIE                           : ✘
    Fortify                       : ✘
    RelRO                         : Partial
elf-info
    Magic                 : 7f 45 4c 46
    Class                 : 0x2 - ELF_64_BITS
    Endianness            : 0x1 - LITTLE_ENDIAN
    Version               : 0x1
    OS ABI                : 0x0 - SYSTEMV
    ABI Version           : 0x0
    Type                  : 0x3 - ET_DYN
    Machine               : 0x3e - X86_64
    Program Header Table  : 0x0000000000000040
    Section Header Table  : 0x0000000000011150
    Header Table          : 0x0000000000000040
    ELF Version           : 0x1
    Header size           : 64 (0x40)
    Entry point           : 0x0000000000001220
    ...
```

#### Step 3: Set Breakpoints

Set breakpoints at key functions to inspect their behavior. For instance, you might want to break at `process_credentials` to observe how input is handled and at `admin_panel` to see if it's possible to reach that function.

```sh
(gef) b *(&process_credentials)
(gef) b *(&admin_panel)
```

#### Step 4: Run the Program

Start the program within GEF by typing `r` or `run`. The program will start and stop at the first breakpoint.
```sh
r
```

### Step 5: Find the `ret` address of the `process_credentials` function
When brakpoint is reached, print the address of the stack pointer which contain the return address of `process_credentials` function. It will be used to overrite it with `admin_panel` address.
```sh
(gef) i r $rsp
    rsp            0x7fffffffd838      0x7fffffffd838
```

#### Step 6: Step Through the Code

Use the `next` or `n` command to step through the code line by line. If you want to step into functions (like `store_credentials_into_db`), use `step` or `s` instead.

#### Step 6: Inspect Variables and Memory

As you reach the `std::cin` call, you can inspect the contents of `buffer` and other variables:
- If you want to dereference all the stack entries inside a function context (on a 64bit architecture): `p ($rbp - $rsp)/8`
- Find the memory address of the `buffer` array: `p &buffer[0]`= 0x7fffffffd7b0
- To examine the content of `buffer`: `x/128c buffer`

#### Step 7: Continue Execution

After inspecting the variables at the first breakpoint, continue execution to see if the second breakpoint (`admin_panel`) is hit.

```sh
(gef) continue
```

#### Step 8: Experiment with Inputs

If you're analyzing the program for vulnerabilities, you might try inputs that could potentially overflow `buffer` or otherwise manipulate the program's flow. Run

#### Step 9: Utilize GEF Commands for Deeper Analysis

GEF provides commands that are particularly useful for security analysis:
- `pattern create` and `pattern search` to test for buffer overflows.
- `heap bins` to inspect the heap state if dynamic memory allocation is used elsewhere in the program.

#### Step 10: Quit GEF

Once you're done debugging, you can quit GEF with the `quit` command.

### More commands
All the available GEF commands available [here](https://hugsy.github.io/gef-extras/commands/assemble/).

### Bonus
I've also developed an exploit for the provided code using insights from gef. You can locate it [here](https://github.com/luk6xff/luk6xff.github.io/tree/master/content/other/code/gef_tool/exploit_cpp.py). Please remember to customize the addresses, specifically process_credentials_ret_addr and buffer_addr, to match those on your system."

## Conclusion
GEF is like a supercharged version of GDB that makes debugging less of a headache. It's packed with features that give you a clearer view of your program and help you find and fix bugs more efficiently. Whether you're a new developer or have been coding for years, GEF is a valuable tool to add to your software debugging toolkit.

Happy hacking!
