---
name: dev-commits
description: Use when creating, editing, reviewing, or explaining git commit messages, commit scopes, changelog-friendly history, semantic-release compatibility, or Conventional Commits formatting.
license: MIT
metadata:
  author: github.com/bastos
  version: "2.1"
---

# Conventional Commits

Format commit messages according to the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) specification for automated changelogs, semantic versioning, and readable history.

For more examples and common mistakes, load `references/examples.md`.

## Format Structure

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

## Commit Types

- **`feat:`** - A new feature (correlates with MINOR in Semantic Versioning)
- **`fix:`** - A bug fix (correlates with PATCH in Semantic Versioning)
- **`docs:`** - Documentation only changes
- **`style:`** - Code style changes (formatting, missing semicolons, etc.)
- **`refactor:`** - Code refactoring without bug fixes or new features
- **`perf:`** - Performance improvements
- **`test:`** - Adding or updating tests
- **`build:`** - Build system or external dependencies changes
- **`ci:`** - CI/CD configuration changes
- **`chore:`** - Other changes that don't modify src or test files
- **`revert:`** - Reverts a previous commit

## Scope and Description

- Use an optional scope for the affected component: `fix(auth): resolve token expiration issue`
- Use imperative mood ("add feature" not "added feature" or "adds feature")
- Don't capitalize the first letter
- No period at the end
- Hard limit: 72 characters (including type and scope)
- Recommended: 50 characters or fewer for better readability

## Body

- Optional longer description providing additional context
- Must begin one blank line after the description
- Can consist of multiple paragraphs
- Explain the "what" and "why" of the change, not the "how"

## Breaking Changes

Mark breaking changes with `!`, a `BREAKING CHANGE:` footer, or both:

```
feat: allow provided config object to extend other configs

BREAKING CHANGE: `extends` now loads parent config files.
```

## Examples

```
feat: add user authentication

feat(auth): add OAuth2 support

fix: prevent racing of requests

Introduce a request id and a reference to latest request. Dismiss
incoming responses other than from latest request.
```

## Guidelines

1. **Always use a type** - Every commit must start with a type followed by a colon and space
2. **Use imperative mood** - Write as if completing the sentence "If applied, this commit will..."
3. **Be specific** - The description should clearly communicate what changed
4. **Keep it focused** - One logical change per commit
5. **Use scopes when helpful** - Scopes help categorize changes within a codebase
6. **Document breaking changes** - Always indicate breaking changes clearly

## Semantic Versioning Correlation

- **`fix:`** → PATCH version bump (1.0.0 → 1.0.1)
- **`feat:`** → MINOR version bump (1.0.0 → 1.1.0)
- **BREAKING CHANGE** → MAJOR version bump (1.0.0 → 2.0.0)
