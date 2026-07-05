---
name: dotagents
description: Use when creating, placing, moving, reorganizing, or updating repository-local agent assets and artifacts that follow the dotagents layout under `.agents/`, including guides, skills, specs, tests, task state, logs, scratch files, or runtime state. Also use when deciding how `.agents/` relates to root project docs such as `PLAN.md`, `TODO.md`, `CHANGELOG.md`, `README.md`, and `AGENTS.md`.
metadata:
  author: https://github.com/roktas
  version: "1.0.0"
---

# Dotagents

Use `.agents/` for agent-facing repository artifacts. Keep it small; do not turn it into a second project root.

More specific root instructions, specs, task state, or platform-provided features take precedence when they conflict
with this generic guidance.

Load `references/layout.md` when placing files, choosing between specs/state/root docs, needing examples or templates,
or checking edge cases. Load `references/project.md` when initializing a project, using `PLAN.md`, `TODO.md`, or
`CHANGELOG.md`, closing a boot phase, or deciding whether planning material should become a durable spec.

## Core Layout

```text
.agents/
  guides/  long-form agent-facing operational guidance
  skills/  reusable agent capabilities
  specs/   durable repo-level truth
  tests/   reviewable agent-facing validation
  state/   local untracked runtime residue
```

## Placement

- `guides/`: long-form operational guidance delegated from `AGENTS.md`.
- `specs/`: durable behavior, invariants, interfaces, acceptance criteria, or architectural rules.
- `skills/`: reusable agent workflows, tools, references, and metadata.
- `tests/`: reviewable validation harnesses, fixtures, smoke tests, and prompt or skill contracts.
- `state/`: local task state, logs, caches, scratch files, generated output, and other runtime residue.

Keep canonical project docs outside `.agents/` unless they are specifically for agents:

- `PLAN.md`: project incubation, boot planning, or a living project plan.
- `TODO.md`: shared current queue for humans and agents.
- `CHANGELOG.md`: append-only project record.
- `README.md`: human-facing project invariant.
- `AGENTS.md`: agent-facing operational invariant, bootstrap instructions, and progressive-disclosure index.

Keep root instructions short. Move long operational guidance into `guides/`, durable truth into `specs/`, reusable
agent workflows into `skills/`, and reviewable validation assets into `tests/`.

Do not create top-level `tasks/`, `logs/`, `tmp/`, `cache/`, `scratch/`, `work/`, `plans/`, or `todos/` directories. Use
`.agents/state/` for local runtime residue. Do not create `.agents/notes/`; place shared project intent in root
`TODO.md` or `PLAN.md`, durable truth in `.agents/specs/`, and local task context in `.agents/state/tasks/`.
For split `AGENTS.md` content, use `.agents/guides/`; do not create parallel catch-all directories such as
`.agents/agents/`, `.agents/rules/`, or `.agents/instructions/`.

In repositories that use the `.agents/` layout, interpret shorthand paths such as `specs/foo.md`,
`guides/review.md`, and `state/tasks/foo/` as `.agents/specs/foo.md`, `.agents/guides/review.md`, and
`.agents/state/tasks/foo/` when the requested artifact is agent-facing and the user has not explicitly asked for a
top-level path.

Use `.agents/state/tasks/YYYY-MM-DD-short-slug/` only for broad, risky, multi-file, multi-session, or explicitly
requested work. Task state is mutable, local, ignored by Git, and not durable project truth. Promote durable decisions
to `specs/`; promote shared project intent to root `TODO.md`, `PLAN.md`, or `CHANGELOG.md` as appropriate.

After meaningful `.agents/` changes, check that guides, specs, skills, tests, root instructions, root project docs, and
local state still agree.
