---
name: bash
description: Use when editing, writing, or debugging Bash or POSIX shell scripts, shell-based automation, CLI wrappers, dotfiles, CI scripts, or when Bash style, safety, portability, or shell testing matter. Use when writing Bash code inside Markdown fenced code blocks. Always load this skill before writing or modifying any Bash code, even if the task seems straightforward — the skill catches subtle pitfalls that are easy to overlook.
metadata:
  author: https://github.com/roktas
  version: "1.0.0"
---

# Bash

## Style

- **Indent** - 1 tab (8 spaces). Do NOT convert tabs to spaces.
- **Scope** - Use `local` for local vars, `readonly` for globals.
- **Local order** - In functions, declare locals assigned from positional arguments first, in positional order. Then leave
  one blank line and declare the function's other local variables alphabetically.
- **Conditions** - Always use `[[ ... ]]`. Use `&&`/`||` instead of `-a`/`-o`.
- **Quotes** - Quote only necessary elements (e.g., `"$HOME"/path/to/file`).
- **Ops** - Use `$(...)` for capture, `=` for string equality.
- **Case** - No indent for case patterns, 1 tab for body.

  ```bash
  case $var
  # pattern
  a)
  	# body
  	...
  	;;
  esac
  ```

- **Alphabetize** arrays, dicts, assignments, and functions if order is irrelevant.
- **Script layout** - In standalone scripts, group content in this order:
  1. Prelude
  2. Helpers
  3. Commands
  4. Main

  Do not add a heading for the prelude. The prelude contains only the shebang, the standard prelude, global
  variables if any, and then core functions such as `abort` and `warn`, alphabetized.

  Add the other section headings in this exact shape, with 120 hyphens:

  ```bash
  # ------------------------------------------------------------------------------------------------------------------------
  # Helpers
  # ------------------------------------------------------------------------------------------------------------------------

  ```

  Keep functions alphabetized inside each section.
- **Command functions** - In scripts that expose top-level commands, name command entrypoint functions with the
  `command.` prefix, such as `command.start()` or `command.doctor()`.
- **Main section** - Put non-command functions used directly by `main`, such as `usage`, `dispatch`, or `help`, in the
  `Main` section alphabetically. The `main` function itself is always the last function in the `Main` section regardless
  of alphabetical order.

## Patterns

- **POSIX sh contexts**: If the target interpreter is `sh`, `/bin/sh`, POSIX shell, or a remote heredoc that will be
  read by `sh`, do not use the Bash prelude or Bash-only style rules. The Bash prelude below is only for scripts that
  actually run under Bash. For POSIX `sh`, use a small compatible prelude such as:

  ```sh
  set -eu
  unset CDPATH
  ```

  Do not add `set -o pipefail`, `set -E`, `[[ ... ]]`, arrays, `local`, `source`, `function name { ...; }`, process
  substitution, here-strings, brace expansion, `mapfile`, `readarray`, `$'...'` strings, or Bash redirections such as
  `&>/dev/null`. Use POSIX forms instead: `[ ... ]`, `case`, `. file`, `name() { ...; }`, explicit loops, temp files,
  here-documents, `printf`, and `>/dev/null 2>&1`. Check POSIX-targeted snippets with `shellcheck -s sh` when practical.

- **Prelude**: Place the following block, including the blank lines, at the beginning of the file

  ```bash
  #!/usr/bin/env bash

  set -Eeuo pipefail
  [[ -z ${TRACE:-} ]] || set -x
  unset CDPATH

  ```

- **Nullglob**: When a script uses glob patterns that may match nothing, add `shopt -s nullglob` to
  the prelude after the standard options:

  ```bash
  shopt -s nullglob
  ```

  Without this, an unmatched glob such as `*.txt` produces the literal string `*.txt`:

  ```bash
  # When no .txt files exist, this iterates over the single string "*.txt"
  for f in *.txt; do
  	...
  done
  ```

- **Error Handling**

```bash
abort() {
	local message=$1
	local status=${2:-1}

	warn "E: $message"
	exit "$status"
}

warn() {
	printf '%s\n' "$*" >&2
}
```

- **Main function** - Use `main() { ... }` and call `main "$@"`.
- **Efficiency** - Use shell substitution (`${0##*/}`) over external tools (`basename`)
- **Silence** - If the command offers a quiet option for silent operation, use that option, ie. `grep -q`; otherwise,
  use the `&>/dev/null` shell redirection.
- **Version** - For Bash scripts, require Bash 4 or newer. If the target has only macOS system Bash 3.2, warn the user
  before relying on Bash 4+ behavior; do not silently add compatibility code or change the interpreter.
- **Arrays** - Use `mapfile` for output capture: `mapfile -t arr < <(CMD)`. This follows the Bash 4+ requirement above.
- **Temp Files** - Use `mktemp` and scope traps to `main` or a subshell. Keep the cleanup body on one line, preserve the
  original exit status, and separate `EXIT` cleanup from signal handling.

```bash
work() (
	local tempfile

	tempfile=$(mktemp) || exit
	trap 'status=$?; rm -f -- "$tempfile" || :; exit "$status"' EXIT
	trap 'exit 129' HUP
	trap 'exit 130' INT
	trap 'exit 131' QUIT
	trap 'exit 143' TERM

	# Work with "$tempfile".
)
```

- **Temp Dirs** - Apply the same scoped, one-line trap pattern.

```bash
work() (
	local tempdir

	tempdir=$(mktemp -d) || exit
	trap 'status=$?; rm -rf -- "$tempdir" || :; exit "$status"' EXIT
	trap 'exit 129' HUP
	trap 'exit 130' INT
	trap 'exit 131' QUIT
	trap 'exit 143' TERM

	# Work inside "$tempdir".
)
```

## Gotchas

- **Local** - `local x=$(...)` swallows exit codes. Define `local x` first, then assign.
- **Unbound** - With `set -u`, use `${var:-}` to avoid errors on unbound vars.
- **Locale** - Sorting, character classes (`[a-z]`), and number formatting depend on locale. Add
  `export LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8` to the prelude in locale-dependent scripts for predictable
  behavior.
