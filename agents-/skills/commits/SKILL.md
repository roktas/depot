---
name: commits
description: Use when creating, editing, reviewing, or explaining git commit messages, commit scopes, changelog-friendly history, semantic-release compatibility, or Conventional Commits formatting.
license: MIT
metadata:
  author: github.com/bastos
  version: "2.1"
---

# Conventional Commits

Use Conventional Commits.

- Format: `<type>[optional scope]: <description>`.
- Common types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`.
- Use imperative mood, lowercase description, no trailing period.
- Keep the subject at 72 characters or less; prefer 50 or less when practical.
- Add a body only when it explains non-obvious what/why context.
- Mark breaking changes with `!` and/or a `BREAKING CHANGE:` footer.

Prefer the most specific accurate type. Use scopes when they help readers or release tooling.
