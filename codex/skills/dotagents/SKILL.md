---
name: dotagents
description: Use when creating, placing, moving, reorganizing, or updating repository-local agent assets and artifacts that follow the dotagents layout under `.agents/`, including skills, specs, notes, tests, task state, logs, scratch files, checkpoints, or runtime state.
metadata:
  author: https://github.com/roktas
  version: "1.0.0"
---

# Dotagents

Use `.agents/` for agent-facing repository artifacts. Keep it small; do not turn it into a second project root.

Load `references/layout.md` when placing files, choosing between specs/notes/state, updating checkpoint conventions, or
checking edge cases.

- `specs/`: durable behavior and design specs.
- `skills/`: reusable workflows with clear triggers.
- `notes/`: shared human/agent notes.
- `tests/`: tests for agent-facing automation.
- `state/`: local runtime state, scratch, logs, tasks, and checkpoints.

Keep canonical project docs outside `.agents/` unless they are specifically for agents. Keep root instructions short;
move long reusable detail into a skill or spec. Do not create top-level task, log, cache, scratch, or work directories;
use `.agents/state/` for local runtime residue.

In repositories that use the `.agents/` layout, interpret shorthand paths such as `notes/foo.md`, `specs/foo.md`, and
`state/tasks/foo/` as `.agents/notes/foo.md`, `.agents/specs/foo.md`, and `.agents/state/tasks/foo/` when the requested
artifact is agent-facing and the user has not explicitly asked for a top-level path.

Use `.agents/state/tasks/YYYY-MM-DD-short-slug/` only for broad, risky, multi-file, multi-session, or explicitly
requested work. After meaningful `.agents/` changes, check that root instructions, specs, skills, notes, and tests still
agree.
