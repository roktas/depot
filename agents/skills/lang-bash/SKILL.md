---
name: lang-bash
description: Use when working on Bash or POSIX shell scripts, shell-based automation, CLI wrappers, dotfiles, CI scripts, or projects where Bash style, safety, portability tradeoffs, or shell testing matter.
metadata:
  author: https://github.com/roktas
  version: "1.0.0"
---

# Bash Skills

## General

- Follow the conversation language, but keep code comments, variables, and file names in English.
- Skip basics unless asked; prefer simple Bash over clever Bash.

## Style

- **Indent** - 1 tab (8 spaces). Do NOT convert tabs to spaces.
- **Scope** - Use `local` for local vars, `readonly` for globals.
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
- **Comments** - Code should be self-documenting. If you need a comment to explain WHAT the code does, consider
  refactoring to make it clearer. Unacceptable comments:
  - Comments that repeat what code does
  - Commented-out code (delete it)
  - Obvious comments ("increment counter")
  - Comments instead of good naming
  - Comments about updates to old code (e.g. `# now supports xyz`)

## Patterns

- **Prelude**: Place the following block, including the blank lines, at the beginning of the file

  ```bash
  #!/usr/bin/env bash

  set -Eeuo pipefail; shopt -s nullglob; [[ -z ${TRACE:-} ]] || set -x; unset CDPATH; IFS=$' \n'

  ```

- **Error Handling**

  ```bash
  abort() {
  	warn "E: $*"
  	exit 1
  }

  warn() {
  	echo -e "$*" >&2
  }
  ```

- **Main function** - Use `main() { ... }` and call `main "$@"`.
- **Efficiency** - Use shell substitution (`${0##*/}`) over external tools (`basename`)
- **Silence** - If the command offers a quiet option for silent operation, use that option, ie. `grep -q`; otherwise,
  use the `&>/dev/null` shell redirection.
- **Arrays** - Use `mapfile` for output capture: `mapfile -t arr < <(CMD)`.
- **Temp Files** - Use `mktemp` + `trap`.

  ```bash
  local tempfile
  tempfile=$(mktemp) || exit
  trap 'err=$? && rm -f "'"$tempfile"'" || exit $err' EXIT HUP INT QUIT TERM
  ```

- **Temp Dirs**

  ```bash
  local tempdir
  tempdir=$(mktemp -d) || exit
  trap 'err=$? && rm -rf "'"$tempdir"'" || exit $err' EXIT HUP INT QUIT TERM
  ```

## Gotchas

- **Local** - `local x=$(...)` swallows exit codes. Define `local x` first, then assign.
- **Unbound** - With `set -u`, use `${var:-}` to avoid errors on unbound vars.
