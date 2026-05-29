# OpenCode Supplemental Instructions

These instructions supplement the shared user instructions from `~/.agents/AGENTS.md`.

When a task matches an available skill, load the skill before acting and follow its workflow closely. Prefer explicit
skill context over memory, especially for commit messages, repository-local agent assets, shell edits, and cloud CLI
work.

For code changes, inspect the existing project shape before editing, keep changes scoped, and run the most relevant
checks available in the repository. If a check cannot run, report the exact blocker.
