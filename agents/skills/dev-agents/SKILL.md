---
name: dev-agents
description: Use when creating, placing, or updating agent-facing repository files under `.agents/`, including skills, specs, task notes, todos, logs, scratch files, checkpoints, or runtime state.
---

# Agent Workspace

Use `.agents/` for agent-facing repository artifacts. Keep it small; do not turn it into a second project root.

For concrete directory examples and task templates, load `references/layout.md`.

## Layout

```text
.agents/
  skills/
  specs/
  tasks/
  state/
```

## Placement Rules

- `.agents/skills/` - Reusable agent capabilities. Skill file structure is defined by the active skill-authoring convention, not by this workspace layout (e.g. Codex `skill-creator` skill).
- `.agents/specs/` - Durable repo-level or feature-level truth.
- `.agents/tasks/` - Versioned work areas for bounded tasks.
- `.agents/state/` - Local, untracked runtime residue.

When unsure:

1. If it teaches agents a reusable workflow, use `skills/`.
2. If it describes what the project or feature must do, use `specs/`.
3. If it describes how a particular change is being planned, executed, reviewed, or handed off, use `tasks/`.
4. If it is raw, local, temporary, machine-generated, or not worth reviewing, use `state/`.

## Specs

Use `.agents/specs/<feature>/spec.md` for durable project or feature requirements: behavior, invariants, interfaces, acceptance criteria, data formats, constraints, or architectural rules.

Do not put temporary task plans, progress tracking, raw logs, or local state in `specs/`.

## Tasks

Use `.agents/tasks/YYYY-MM-DD-short-slug/` for bounded units of work such as refactors, bug fixes, investigations, migrations, experiments, documentation passes, release preparation, or implementation passes.

Default files:

```text
.agents/tasks/<task>/
  task.md
  todo.md
```

- `task.md` - Durable task narrative: refined brief, context, assumptions, plan, notes, decisions, spec updates, review, and handoff information.
- `todo.md` - Versioned coordination checklist. Do not put raw tool traces, transcripts, or temporary scratch output here.

Keep `task.md` as a section-based single-file narrative by default. Do not create task-local companion files unless the content is large enough that splitting improves reviewability.

If a task-local requirement becomes durable project truth, summarize it into `.agents/specs/<feature>/spec.md` and record the spec update in `task.md`.

## State

Use `.agents/state/` only for local runtime state: logs, session traces, tool-call dumps, temporary scratch files, checkpoints, intermediate outputs, and local caches.

When state is scoped to runtime entities such as hosts, environments, or sessions, group those entities under a named state category instead of placing instances at the `state/` root. For example, use `.agents/state/hosts/<host>/` rather than `.agents/state/<host>/`.

This directory should normally be ignored by Git:

```gitignore
.agents/state/
```

If raw state becomes meaningful for future humans, summarize it into `.agents/tasks/<task>/task.md`. If it creates follow-up work, reflect that in `.agents/tasks/<task>/todo.md`.

## Git Policy

Track:

```text
.agents/skills/
.agents/specs/
.agents/tasks/
```

Ignore:

```text
.agents/state/
```

New top-level directories or task-local files require an explicit repository convention.
