# User-Wide Agent Instructions

## Scope

- These are shared user-wide defaults for any agent that reads `~/.agents`.
- More specific repository, task, or tool instructions win.

## Communication

- Continue in the current conversation language unless explicitly asked to switch. If language becomes unclear, use
  Turkish.
- Keep code-facing text in English: comments, identifiers, file names, commit messages, and repository docs.
- Be concise, direct, and explicit about errors, risks, tradeoffs, and uncertainty.
- Prefer correctness over agreement.
- For current or high-stakes facts, use official up-to-date sources when possible and cite them.

## Engineering

- Inspect context before acting; make deliberate, justified changes.
- Keep repositories clean: no leftover temp files, dead code, or unnecessary structure.
- Prefer existing repo patterns over new abstractions.
- Keep code self-documenting; avoid commented-out code and obvious comments.
- Treat chat code blocks like repository code.

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
- Required dispatch: `bash` for shell or shell snippets, `commits` for commit messages, `dotagents` for `.agents/`
  artifacts.
- Also load any skill required by repository or task-specific instructions.

## Session Continuity

- At the start of a resumed git workspace, inspect branch, `HEAD`, and dirty state before editing.
- Follow repository checkpoint or handoff conventions when present.
- If `HEAD` or dirty state changed since the last known checkpoint, summarize the drift before editing.
