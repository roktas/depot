---
name: c
description: Use when working on C source, headers, build integration, native libraries, memory management bugs, Linux or Unix systems code, C style review, or C-oriented tests and tooling.
metadata:
  author: https://github.com/roktas
  version: "1.0.0"
---

# C

## General

- Follow the conversation language, but keep code comments, variables, and file names in English.
- Skip basics unless asked; prefer simple C over clever C.
- Inspect the build system, configured language standard, compiler flags, formatter, static analysis, tests, and public
  headers before editing. Project conventions and an existing formatter override the defaults below.
- Preserve ABI, ownership, allocation, threading, error, and platform contracts unless the task explicitly changes
  them. Do not infer a newer C standard merely from the compiler installed on the current machine.
- Prefer short contextual file and command names. Do not include backend or implementation details in names unless they
  disambiguate real siblings or are part of an established interface.

## Workflow

1. Trace inputs, outputs, ownership, lifetime, error paths, and caller-visible behavior before changing code.
2. Add or verify a failing or characterizing test before a behavioral fix when practical.
3. Make the smallest coherent change; keep declarations and interfaces compatible with the project's supported
   compilers and platforms.
4. Run the narrowest project build and tests, then broaden when touched code is shared. Use the project's warning and
   sanitizer configurations when available; do not introduce repository-wide `-Werror` merely for local validation.
5. Review integer bounds, allocation failures, partial initialization, cleanup, aliasing, and undefined behavior in
   every changed path.

## Style

- **Default** - When the repository has no established style, use the structural conventions of
  [Linux kernel coding style](https://docs.kernel.org/process/coding-style.html).
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
- **Ordering** - Alphabetize declarations, enum members, table entries, or helper functions only when order is
  semantically irrelevant and the surrounding code uses that convention.
- **Comments** - Code should be self-documenting. If you need a comment to explain WHAT the code does, consider
  refactoring to make it clearer. Unacceptable comments:
  - Comments that repeat what code does
  - Commented-out code (delete it)
  - Obvious comments ("increment counter")
  - Comments instead of good naming
  - Comments about updates to old code (e.g. `/* now supports xyz */`)
