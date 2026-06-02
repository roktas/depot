---
name: commits
description: Use when creating, editing, reviewing, or explaining git commit messages, commit scopes, changelog-friendly history, semantic-release compatibility, or Conventional Commits formatting. Always load this skill before preparing a commit message, even if only suggesting one.
license: MIT
metadata:
  author: github.com/bastos
  version: "2.1"
---

# Conventional Commits

Use Conventional Commits for commit messages that should support readable history, changelogs, and semantic-release
tooling.

Load `references/examples.md` when the user wants examples, asks why a message is invalid, or needs help choosing
between similar messages.

## Format

```text
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

## Rules

- Common types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`.
- Prefer the most specific accurate type. Use scopes when they help readers or release tooling.
- Use imperative mood, lowercase description, and no trailing period.
- Keep the subject at 72 characters or less; prefer 50 or less when practical.
- Add a body only when it explains non-obvious what/why context.
- Mark breaking changes with `!` and/or a `BREAKING CHANGE:` footer.

Semantic-versioning convention: `fix` maps to PATCH, `feat` maps to MINOR, and a breaking change maps to MAJOR when
release tooling follows Conventional Commits.
