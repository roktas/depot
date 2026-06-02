---
name: dotagents
description: Use when creating, placing, moving, reorganizing, or updating repository-local agent assets and artifacts that follow the dotagents layout under `.agents/`, including skills, specs, notes, tests, task state, logs, scratch files, checkpoints, or runtime state.
metadata:
  author: https://github.com/roktas
  version: "1.0.0"
---

# Dotagents

Use `.agents/` for agent-facing repository artifacts. Keep it small; do not turn it into a second project root.

More specific root instructions, specs, task state, or platform-provided features take precedence when they conflict
with this generic guidance.

Load `references/layout.md` when placing files, choosing between specs/notes/state, updating checkpoint conventions,
needing examples or templates, or checking edge cases.

## Core Layout

```text
.agents/
  notes/   shared versioned notes, inboxes, and drafts
  skills/  reusable agent capabilities
  specs/   durable repo-level truth
  tests/   reviewable agent-facing validation
  state/   local untracked runtime residue
```

## Placement

- `specs/`: durable behavior, invariants, interfaces, acceptance criteria, or architectural rules.
- `notes/`: shared drafts, inboxes, questions, TODOs, and non-canonical context that should be versioned.
- `skills/`: reusable agent workflows, tools, references, and metadata.
- `tests/`: reviewable validation harnesses, fixtures, smoke tests, and prompt or skill contracts.
- `state/`: local task state, checkpoints, logs, caches, scratch files, generated output, and other runtime residue.

Keep canonical project docs outside `.agents/` unless they are specifically for agents. Keep root instructions short;
move long reusable detail into a skill or spec.

Do not create top-level `tasks/`, `logs/`, `tmp/`, `cache/`, `scratch/`, `work/`, `plans/`, or `todos/` directories. Use
`.agents/state/` for local runtime residue.

In repositories that use the `.agents/` layout, interpret shorthand paths such as `notes/foo.md`, `specs/foo.md`, and
`state/tasks/foo/` as `.agents/notes/foo.md`, `.agents/specs/foo.md`, and `.agents/state/tasks/foo/` when the requested
artifact is agent-facing and the user has not explicitly asked for a top-level path.

Use `.agents/state/tasks/YYYY-MM-DD-short-slug/` only for broad, risky, multi-file, multi-session, or explicitly
requested work. Task state is mutable, local, ignored by Git, and not durable project truth. Promote durable decisions
to `specs/`; promote shared non-canonical context to `notes/`.

After meaningful `.agents/` changes, check that specs, skills, notes, tests, root instructions, and local state still
agree.
