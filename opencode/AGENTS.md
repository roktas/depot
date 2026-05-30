# OpenCode Instructions

These instructions supplement the shared user instructions from `~/.agents/AGENTS.md`.

Treat the required skill rules below as mandatory dispatch rules. They exist to prevent missed context, not to constrain
implementation choices after the right skill is loaded.

## Skills

Always load the relevant language or workflow skill before writing, editing, or reviewing matching code or artifacts.

Required skill use:

- Always load `bash` before writing or editing Bash, POSIX shell, shell snippets, dotfiles, shell hooks, or shell
  commands in Markdown code blocks. Do this every time; do not rely on memory.
- Always load `commits` before preparing, editing, reviewing, or suggesting any commit message. Do this every time.
- Always load `dotagents` before creating, placing, moving, or reorganizing `.agents/` files, agent task state, specs,
  tests, runtime state, or skill directories.
- Always load any skill required by repository or task-specific instructions before acting, even when the task appears
  simple.

For code changes, inspect the existing project shape before editing, keep changes scoped, and run the most relevant
checks available in the repository. If a check cannot run, report the exact blocker.
