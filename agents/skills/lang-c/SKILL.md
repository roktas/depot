---
name: lang-c
description: Use when working on C source, headers, build integration, native libraries, memory management bugs, Linux or Unix systems code, C style review, or C-oriented tests and tooling.
metadata:
  author: https://github.com/roktas
  version: "1.0.0"
---

# C Skills

## General

- Follow the conversation language, but keep code comments, variables, and file names in English.
- Skip basics unless asked; prefer simple C over clever C.

## Style

- **Linux Kernel Coding Style** - Follow [Linux kernel coding style](https://docs.kernel.org/process/coding-style.html).
- **Indent** - 1 tab (8 spaces). Do NOT convert tabs to spaces.
- **Braces** - Use 1TBS (One True Brace Style).
- **Functions** - Opening brace **must** be on the next line (first column).

  ```c
  void function(void)
  {
  	/* body */
  }
  ```

- **Switch** - Patterns aligned with `switch`, body indented 1 tab.

  ```c
  switch (var) {
  case A:
  	/* body */
  	...
  	break;
  }
  ```
- **Alphabetize** arrays, dicts, assignments, and methods if order is irrelevant.
- **Align** consecutive assignments around the `=` operator.

  ```c
  /* Aligned & Alphabetical */
  int bar                = 5;
  int i                  = 3;
  int long_variable_name = 8;
  ```

- **Comments** - Code should be self-documenting. If you need a comment to explain WHAT the code does, consider
  refactoring to make it clearer. Unacceptable comments:
  - Comments that repeat what code does
  - Commented-out code (delete it)
  - Obvious comments ("increment counter")
  - Comments instead of good naming
  - Comments about updates to old code (e.g. `/* now supports xyz */`)
