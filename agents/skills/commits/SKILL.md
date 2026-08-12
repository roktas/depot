---
name: commits
description: Use when creating, editing, reviewing, or explaining git commit messages, commit scopes, changelog-friendly history, semantic-release compatibility, or Conventional Commits formatting. Always load this skill before preparing a commit message, even if only suggesting one.
license: MIT
---

# Conventional Commits

Use Conventional Commits for commit messages that should support readable history, changelogs, and semantic-release
tooling.

Load `references/examples.md` when the user wants examples, asks why a message is invalid, or needs help choosing
between similar messages.

## Workflow

1. Read repository instructions and the actual staged diff. If nothing is staged, inspect the intended diff but do not
   imply that uncommitted work is already in the commit.
2. Identify the single reader-visible purpose of the commit. If unrelated purposes are mixed, recommend or create
   separate commits when the task authorizes history changes.
3. Keep routine dependency refreshes separate. Before `bundle update`, lockfile regeneration, or another broad version
   refresh, commit pending functional work. Commit the dependency-only diff as `chore(deps)` using repository wording.
   Combine it with behavior only when that dependency change is required for the same behavior and cannot be reviewed
   independently.
4. Choose the type from the effect, not the files touched:
   - `fix` corrects faulty behavior.
   - `feat` adds a capability or supported behavior.
   - `refactor` changes implementation without intended behavior change.
   - `docs`, `test`, `build`, `ci`, `perf`, and `style` describe their specific surfaces.
   - `chore` is a fallback for maintenance that fits no more informative type.
5. Choose a scope only when it gives stable project context. Do not repeat the repository name or invent a component
   merely to fill the slot.
6. Check the final message against the diff. Do not claim tests, fixes, compatibility, or breaking behavior that the
   evidence does not show.

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
- Describe the resulting state, not the editing process: prefer `fix(parser): reject empty keys` over `update parser`.
- Return the message as plain text or a fenced block only when the user requests a message; do not add quotation marks
  that could be copied into Git accidentally.

Semantic-versioning convention: `fix` maps to PATCH, `feat` maps to MINOR, and a breaking change maps to MAJOR when
release tooling follows Conventional Commits.
