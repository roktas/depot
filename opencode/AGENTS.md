# OpenCode Agent Instructions

## Scope

- These are user-wide defaults for OpenCode.
- More specific repository, task, or tool instructions win.
- Treat the required skill rules below as mandatory dispatch rules. They exist to prevent missed context, not to
  constrain implementation choices after the right skill is loaded.

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

Always load the relevant language or workflow skill before writing, editing, or reviewing matching code or artifacts.

Required skill use:

- Always load `bash` before writing or editing Bash, POSIX shell, shell snippets, dotfiles, shell hooks, or shell
  commands in Markdown code blocks. Do this every time; do not rely on memory.
- Always load `commits` before preparing, editing, reviewing, or suggesting any commit message. Do this every time.
- Always load `dotagents` before creating, placing, moving, or reorganizing `.agents/` files, agent task state, specs,
  tests, runtime state, or skill directories.
- Always load any skill required by repository or task-specific instructions before acting, even when the task appears
  simple.

## Session Continuity

- At the start of a resumed git workspace, inspect branch, `HEAD`, and dirty state before editing.
- Follow repository checkpoint or handoff conventions when present.
- If `HEAD` or dirty state changed since the last known checkpoint, summarize the drift before editing.
