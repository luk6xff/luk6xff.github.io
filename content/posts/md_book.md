+++
title="mdBook"
date=2023-12-13

[taxonomies]
categories = ["rust"]
tags = ["rust"]
+++


# How to create a presentation using mdBook
Creating an mdBook for your presentation involves organizing the content into Markdown files structured in a way that mdBook can compile into a book format.

## A book format
I'll provide you with a basic setup and some content following the outline I previously shared. For a full `mdBook`, you would typically set up a directory structure like this:
```sh
presentation/
├── book.toml
└── src
    ├── chapter_1.md
    ├── chapter_2.md
    ├── chapter_3.md
    ├── chapter_4.md
    ├── chapter_5.md
    ├── chapter_6.md
    ├── SUMMARY.md
    └── conclusion.md
```

### Step1: book.toml
This file contains metadata about your book. For simplicity, here's a basic example:
```toml
[book]
title = "Your mdBook name"
authors = ["Your Name"]
language = "en"

[build]
build-dir = "book"
```

### Step 2: SUMMARY.md
This file outlines the structure of your book. It links all chapters together.
```md
# Summary

- [Intro](./chapter_1.md)
- [How to program in C](./chapter_2.md)
- [How to program in C++](./chapter_3.md)
- [How to program in Java](./chapter_4.md)
- [How to program in Rust](./chapter_5.md)
- [How to program in Python](./chapter_6.md)
- [Conclusion](./conclusion.md)
```

### Step 3: Chapter Files
Each chapter file (chapter_1.md, chapter_2.md, etc.) will contain the markdown content for that section of the presentation. Here's an example for the first chapter:
```md
# Intro

Hey It's my book written in `markdown`.

## Background and Motivation

I was very motivated to create markdown stuff.

## Conclussion

All is fine in my **book**.

```
Continue creating Markdown files for each chapter following the outline, filling in the content as necessary.

### Step 4: Compile the mdBook
After setting up your mdBook structure and writing your content, you can compile it into a book format using the mdBook tool. If you haven't already, you'll need to install mdBook:
```sh
cargo install mdbook
```
Then, navigate to your book directory and run:
```sh
mdbook build
```
This command compiles your Markdown files into a static website that you can host or view locally.

### Step 5: Final Step: Viewing Your Book
After building, you can view your book by opening the index.html file in the book directory with a web browser, or you can serve it locally with:
```sh
mdbook serve
```
This command starts a local web server. You can view your book by visiting http://localhost:3000 in your web browser.

## Summary
This setup gives you a solid foundation to create a comprehensive mdBook for your presentation :)
