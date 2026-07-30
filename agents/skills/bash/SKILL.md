---
name: bash
description: Use when editing, writing, or debugging Bash or POSIX shell scripts, shell-based automation, CLI wrappers, dotfiles, CI scripts, or when Bash style, safety, portability, or shell testing matter. Use when writing Bash code inside Markdown fenced code blocks. Always load this skill before writing or modifying any Bash code, even if the task seems straightforward — the skill catches subtle pitfalls that are easy to overlook.
metadata:
  author: https://github.com/roktas
  version: "1.0.0"
---

# Bash

## General

- Follow the conversation language, but keep code comments, variables, and file names in English.
- Skip basics unless asked; prefer simple Bash over clever Bash.
- Inspect repository instructions, the shebang, callers, and existing tests before choosing syntax. Preserve the target
  interpreter; do not turn a POSIX `sh` script into Bash merely to use a preferred Bash construct.
- Follow an established project formatter and style when they conflict with this skill's defaults.
- Prefer short contextual command and file names. Do not include backend or implementation details in names unless they
  disambiguate real siblings or are part of an established interface.

## Workflow

1. Classify the target as Bash or POSIX `sh` before editing. When a snippet has no explicit interpreter, choose the
   narrowest shell that supports its required behavior and state a consequential assumption.
2. Inspect how arguments, environment variables, standard streams, exit statuses, and signals form the script's public
   contract.
3. Make the smallest coherent change and preserve unrelated user edits.
4. Check syntax with the target shell, run `shellcheck -s bash` or `shellcheck -s sh` when available, then run the
   narrowest direct executable test. Review every suppression rather than disabling a class of warnings broadly.

## Style

- **Indent** - 1 tab (8 spaces). Do NOT convert tabs to spaces.
- **Scope** - Use `local` for local vars, `readonly` for globals.
- **Local order** - In functions, declare locals assigned from positional arguments first, in positional order. Then leave
  one blank line and declare the function's other local variables alphabetically.
- **Conditions** - In Bash, use `[[ ... ]]` and `&&`/`||` instead of `-a`/`-o`. In POSIX `sh`, use `[ ... ]` or `case`.
- **Quotes** - Quote parameter expansions and command substitutions by default. Leave an expansion unquoted only when
  word splitting or glob expansion is intentional and safe. Prefer `"$HOME/path/to/file"` and always use `"$@"` when
  forwarding arguments.
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
- **Comments** - Code should be self-documenting. If you need a comment to explain WHAT the code does, consider
  refactoring to make it clearer. Unacceptable comments:
  - Comments that repeat what code does
  - Commented-out code (delete it)
  - Obvious comments ("increment counter")
  - Comments instead of good naming
  - Comments about updates to old code (e.g. `# now supports xyz`)

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
  	warn "E: $*"
  	exit 1
  }

  warn() {
	printf '%s\n' "$*" >&2
  }
  ```

- **Main function** - Use `main() { ... }` and call `main "$@"`.
- **Efficiency** - Use shell substitution (`${0##*/}`) over external tools (`basename`)
- **Silence** - If the command offers a quiet option for silent operation, use it, such as `grep -q`; otherwise redirect
  explicitly with `>/dev/null 2>&1`.
- **Arrays** - In Bash, use `mapfile` for line-oriented output capture when the producer's exit status is not part of the
  contract: `mapfile -t arr < <(CMD)`. Process substitution does not propagate `CMD` failure through `mapfile`; use a
  temporary file or another explicit status check when failure matters.
- **Temporary paths** - Create private temporary files or directories with `mktemp`, quote the resolved path, constrain
  every cleanup to that exact path, and preserve the original status. Install cleanup before work that can fail. For a
  script-level temporary directory:

  ```bash
	tempdir=$(mktemp -d) || exit 1
	readonly tempdir
	trap 'status=$?; rm -rf -- "$tempdir" || :; exit "$status"' EXIT
  ```

  If the path is local to a function, clean it before that function returns or capture its value in the trap; an `EXIT`
  trap cannot safely read a local variable after its scope ends. Add signal traps only when the script needs behavior
  beyond the shell's ordinary exit handling.

## Gotchas

- **Local** - `local x=$(...)` swallows exit codes. Define `local x` first, then assign.
- **Unbound** - With `set -u`, use `${var:-}` to avoid errors on unbound vars.
- **Locale** - Sorting, character classes, case conversion, and number formatting depend on locale. Set a locale only
  when the operation requires fixed semantics: use `LC_ALL=C` for bytewise behavior, or first verify that the chosen
  UTF-8 locale exists. Do not assume `en_US.UTF-8` is installed.
