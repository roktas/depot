# User-Wide Agent Instructions

## Scope

- These are shared user-wide defaults for any agent that reads `~/.agents`.
- More specific repository, task, or tool instructions win.
- This file is not `~/AGENTS.md`; keep target-home layout and preference policy in the home-directory entrypoint.

## Communication

- Continue in the current conversation language unless explicitly asked to switch. If language becomes unclear, use
  Turkish.
- Context compaction, model changes, tool output, or quoted English source text are not reasons to switch languages.
  After any transition, resume in the user's latest conversation language.
- Keep code-facing text in English: comments, identifiers, file names, commit messages, and repository docs.
- Be concise, direct, and explicit about errors, risks, tradeoffs, and uncertainty.
- Prefer correctness over agreement.
- For current or high-stakes facts, use official up-to-date sources when possible and cite them.

## Engineering

- Inspect context before acting; make deliberate, justified changes.
- When the user bounds the review or edit scope to specific files or sources, stay inside that scope unless a required
  dependency is missing or the user expands the scope.
- Keep repositories clean: no leftover temp files, dead code, or unnecessary structure.
- Prefer existing repo patterns over new abstractions.
- Keep code self-documenting; avoid commented-out code and obvious comments.
- When running a script with a shebang, execute it directly (e.g. `./bin/foo`). Do not prefix with `bash`, `ruby`, `python`, or similar — trust the shebang to select the right interpreter.
- Treat chat code blocks like repository code.
- Do not write expanded home paths in tracked repository files. Use `~` for home-relative paths, for example
  `~/.config/foo`, and use repository-relative or module-relative paths for repo files.

## Naming Things

- Project- or language-specific naming rules override this section.
- Use the simplest meaningful, pleasant name the context supports. Do not repeat context in the name; in `provision`,
  prefer `Plan` over `ProvisionPlan`.
- Before using separators such as `-`, `_`, `:`, or `/` in a compound name, stop and look for a simpler one-word name.
- Match sibling names in the same scope, such as a module, class, file, or directory. Inspect nearby names before adding
  a new one.
- Private/internal names may be longer or plainer. Public API names should be shorter and more polished.
- Let name length roughly follow scope: longer at global scope, shorter at local scope.

## Skills

- Load relevant language/workflow skills before matching work.
- Treat required dispatch rules as mandatory context-loading rules. They prevent missed context without constraining
  implementation choices after the right skill is loaded.
- Required dispatch: `bash` for shell or shell snippets, `commits` for commit messages, `dotagents` for `.agents/`
  artifacts.
- Also load any skill required by repository or task-specific instructions.
- Do not load the Turkish skill just because the conversation is in Turkish. Load it only when the task is about Turkish
  prose, translation, terminology, tone, grammar, or Turkish-facing documentation/UI text.

## Session Continuity

- At the start of a resumed git workspace, inspect branch, `HEAD`, and dirty state before editing.
- Follow repository checkpoint or handoff conventions when present.
- If `HEAD` or dirty state changed since the last known checkpoint, summarize the drift before editing.
