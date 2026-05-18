# Agent Workspace Layout Reference

Load this reference when examples, templates, or placement edge cases are useful.

## Directory Semantics

```text
.agents/skills/   Reusable agent capabilities
.agents/specs/    Durable repo-level or feature-level specifications
.agents/tasks/    Versioned work areas for bounded tasks
.agents/tests/    Agent-facing validation harnesses and fixtures
.agents/state/    Local, untracked runtime residue
```

Mental model:

```text
skills/ = reusable agent behavior
specs/  = what must be true
tasks/  = how a bounded piece of work is being done
tests/  = how agent-facing behavior is validated
state/  = local runtime residue
```

## Specs

Canonical structure:

```text
.agents/specs/<feature>/
  spec.md
```

Examples:

```text
.agents/specs/svg-dsl/spec.md
.agents/specs/pdf-export/spec.md
.agents/specs/build-pipeline/spec.md
.agents/specs/release-process/spec.md
```

Use `specs/` when the document answers:

> What should be true for this project, subsystem, or feature?

## Tasks

Canonical structure:

```text
.agents/tasks/YYYY-MM-DD-short-slug/
  task.md
  todo.md
```

Examples:

```text
.agents/tasks/2026-05-12-renderer-refactor/
.agents/tasks/2026-05-13-jpg-support/
.agents/tasks/2026-05-14-font-embedding-investigation/
```

Use `tasks/` when the document answers:

> How is this particular change being planned, executed, reviewed, or handed off?

### `task.md`

Suggested sections:

```md
# Task Title

## Brief

## Context

## Plan

## Notes

## Decisions

## Review
```

Keep `task.md` short. Omit sections that add no value.

### `todo.md`

Example:

```md
# TODO

- [x] Inspect current behavior
- [x] Identify edge cases
- [ ] Implement change
- [ ] Add or update tests
- [ ] Update docs
- [ ] Run validation
```

## Tests

Examples:

```text
.agents/tests/provision/smoke.sh
.agents/tests/provision/Dockerfile
.agents/tests/skill-validation/fixtures/
.agents/tests/prompt-contracts/golden/
```

Use `.agents/tests/` for reviewable validation harnesses, fixtures, smoke tests, linter configs, or helper scripts that
support specs, skills, task workflows, or repository automation conventions.

Do not use `.agents/tests/` for temporary output, logs, downloaded dependencies, caches, or generated artifacts. Put
those under `.agents/state/` or a normal ignored build/cache location.

## State

Examples:

```text
.agents/state/hosts/<host>/
.agents/state/environments/<environment>/
.agents/state/logs/
.agents/state/sessions/
.agents/state/checkpoints/
.agents/state/scratch/
.agents/state/tmp/
.agents/state/cache/
```

Use a category directory before runtime entity names:

```text
.agents/state/hosts/<host>/
.agents/state/sessions/2026-05-12T101500Z/
```

Avoid placing entity instances directly under `state/`:

```text
.agents/state/kant/
.agents/state/2026-05-12T101500Z/
```

Use `state/` for:

```text
raw logs
session traces
tool-call dumps
temporary scratch files
checkpoints
intermediate outputs
local caches
```

### Human And Agent TODO

Use these untracked checklists for lightweight notes that should not become tracked task work yet:

```text
.agents/state/human/todo.md
.agents/state/agent/todo.md
```

- `human/todo.md` is user-owned inbox material.
- `agent/todo.md` is assistant-owned operational scratch work.
- Promote items into `.agents/tasks/<task>/todo.md` when they become tracked work.

## Avoid Extra Top-Level Directories

Avoid creating:

```text
.agents/docs/
.agents/logs/
.agents/tmp/
.agents/cache/
.agents/scratch/
.agents/work/
.agents/plans/
.agents/todos/
.agents/test-output/
```
