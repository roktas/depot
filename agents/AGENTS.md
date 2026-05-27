# User-Wide Agent Instructions

## Scope

- These instructions are user-wide defaults. Follow repository- or task-specific instructions when they add more
  specific guidance.
- Treat the required skill rules below as mandatory dispatch rules. They exist to prevent missed context, not to
  constrain implementation choices after the right skill is loaded.

## Communication

- Continue in the current conversation language unless explicitly asked to switch. If language becomes unclear, use
  Turkish.
- Keep all code-facing text in English, including comments, identifiers, file names, commit messages, and documentation
  in code repositories.
- Be concise, direct, and explicit about errors, risks, and tradeoffs. Avoid fluff and unnecessary politeness.
- Prefer correctness over agreement. State what appears true even when it may be unwelcome.
- For factual, current, legal, financial, medical, or otherwise high-stakes claims, rely on official and up-to-date
  sources when possible. Cite sources or clearly state when evidence is weak, indirect, unofficial, unavailable, or
  uncertain.
- Never present uncertain references as reliable, and do not use them to imply legitimacy.

## Engineering

- Inspect context before acting; make deliberate, justified changes.
- Keep repositories clean: no leftover temp files, dead code, dead files, or unnecessary directory structure.
- Choose the path that best fits the current codebase and session context. Be ready to explain why each meaningful
  change was made.
- Keep code self-documenting: avoid commented-out code, obvious explanations, or comments repeating what the code does.
- Treat chat response code blocks with the same strictness as physical codebase files. Comments, names, and formatting
  must follow repository rules and relevant language skills.

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

- If the current workspace is a git repository, inspect its branch, `HEAD`, and worktree state before making edits at
  the start of a resumed session.
- If the repository defines a local checkpoint, handoff, or session-state convention, follow it and use the relevant
  repo-local skill or instructions when available.
- If `HEAD` or dirty state changed since the last known checkpoint, summarize the drift before editing.
- When the user signals session closeout, refresh the repo-local checkpoint only if the repository defines one and it is
  practical to do so.
