---
name: dotagents
description: Use when creating, placing, moving, reorganizing, or updating repository-local agent assets and artifacts that follow the dotagents layout under `.agents/`, including skills, specs, notes, tests, task state, logs, scratch files, checkpoints, or runtime state.
---

# Dotagents Workspace

Use `.agents/` for agent-facing repository artifacts. Keep it small; do not turn it into a second project root.

This skill is a fast placement guide. More specific root instructions, specs, task state, or platform-provided features
take precedence when they conflict with this generic guidance.

Load `references/layout.md` for examples, templates, helper layout, checkpoint details, or placement edge cases.

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

1. `specs/` - Durable behavior, invariants, interfaces, acceptance criteria, or architectural rules.
2. `notes/` - Shared drafts, inboxes, questions, and non-canonical context that should be versioned.
3. `skills/` - Reusable agent workflows, tools, references, and metadata.
4. `tests/` - Reviewable validation harnesses, fixtures, smoke tests, and prompt or skill contracts.
5. `state/` - Local task state, checkpoints, logs, caches, scratch files, generated output, and other runtime residue.

Do not create top-level `tasks/`, `logs/`, `tmp/`, `cache/`, `scratch/`, `work/`, `plans/`, or `todos/` directories.
Use `state/` for those local categories.

## State And Tasks

Use `.agents/state/tasks/YYYY-MM-DD-short-slug/` only for local work that is broad, risky, multi-file, likely to span
sessions, or likely to need handoff notes. Trivial one-turn work can stay in the conversation.

Task state is mutable, local, ignored by Git, and not durable project truth. Promote durable decisions to `specs/`.
Promote shared non-canonical context to `notes/`.

## Consistency Pass

After meaningful `.agents/` changes, check that:

- Durable truth is in `specs/`, not state or task state.
- Shared reviewable context is in `notes/`.
- Local residue remains under `state/`.
- Agent-facing tests still match the specs, skills, and root validation commands they support.
- Root repository instructions still point to the right canonical files when those files changed.
