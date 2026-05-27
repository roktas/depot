# Dotagents Workspace Layout Reference

Load this reference when examples, templates, or placement edge cases are useful.

## Precedence

Use this reference as generic `.agents/` layout guidance. More specific instructions win in this order:

1. The user's current request
2. Root repository instructions such as `AGENTS.md`
3. Durable specs under `.agents/specs/`
4. Shared notes under `.agents/notes/`
5. This reference

If a future agent runtime provides native task, memory, TODO, or checkpoint behavior, prefer the platform feature when
it clearly supersedes a repo-local convention. Keep tracked repo-local files only for artifacts that remain useful to
review, version, or share across tools.

## Core Layout

```text
.agents/
  notes/   shared versioned notes, inboxes, and drafts
  skills/  reusable agent capabilities
  specs/   durable repo-level or feature-level specifications
  tests/   agent-facing validation harnesses and fixtures
  state/   local untracked runtime residue
```

Mental model:

```text
specs/  = what must be true
notes/  = shared drafts and inboxes before promotion
skills/ = reusable agent behavior
tests/  = how agent-facing behavior is validated
state/  = local runtime residue and task state
```

Top-level directories should contain durable or reviewable agent assets. Local, transient, machine-generated, or
episode-scoped material belongs under `state/`.

## Durable Areas

### Specs

Canonical structure:

```text
.agents/specs/<feature>/
  spec.md
```

Use `specs/` when the document answers:

> What should be true for this project, subsystem, or feature?

Specs hold behavior, invariants, interfaces, acceptance criteria, data formats, constraints, and architectural rules.
If specs and local task state disagree, the spec wins; update or discard stale state.

### Notes

Canonical shared TODO:

```text
.agents/notes/todo.md
```

Use `notes/` for tracked working material that should survive sessions and be reviewable, but is not yet durable spec
truth.

Good fits:

```text
shared TODO inbox
early spec drafts
cross-task questions
rough decisions waiting for promotion
coordination notes that should be reviewed later
```

Promote notes into `specs/` when they become durable project truth. Move a note into `state/tasks/` only when it
becomes local active work context that should not be reviewed or versioned.

Keep shared TODOs in `.agents/notes/todo.md`. Keep local task TODOs under `.agents/state/tasks/`.

### Skills

When a skill needs executable helper programs, prefer a simple `bin/` layout inside the skill directory:

```text
.agents/skills/<skill>/
  SKILL.md
  bin/
    plan
    apply
```

Use extensionless command names in `bin/` when the helper is meant to be run directly, regardless of implementation
language. Prefer `.agents/skills/<skill>/bin/plan` over deeper paths such as
`.agents/skills/<skill>/scripts/plan.rb` when the file is a user- or agent-facing command.

Use `scripts/` for non-command support scripts, generators, migrations, one-off maintainers, or files that are not the
primary command surface of the skill.

If multiple helpers need shared code, add a small `lib/` directory inside the skill and keep shared implementation
there. Do not add `lib/` preemptively; create it only when duplication or complexity makes it useful.

When writing or editing helper scripts under `.agents/`, use the relevant language skill when one is available. Apply
the same rule to fenced code blocks in `SKILL.md`, `AGENTS.md`, specs, notes, task state, and other agent-facing
documentation.

### Tests

Examples:

```text
.agents/tests/provision/smoke.sh
.agents/tests/provision/Dockerfile
.agents/tests/skill-validation/fixtures/
.agents/tests/prompt-contracts/golden/
```

Use `tests/` for reviewable validation harnesses, fixtures, smoke tests, linter configs, or helper scripts that support
specs, skills, task workflows, or repository automation conventions.

Do not use `tests/` for temporary output, logs, downloaded dependencies, caches, or generated artifacts. Put those
under `state/` or a normal ignored build/cache location.

## State

Use `.agents/state/` for local runtime state. It is ignored by Git by default and should not contain durable project
truth.

Examples:

```text
.agents/state/hosts/<host>/
.agents/state/environments/<environment>/
.agents/state/logs/
.agents/state/sessions/
.agents/state/tasks/
.agents/state/checkpoints/
.agents/state/scratch/
.agents/state/tmp/
.agents/state/cache/
```

Use a category directory before runtime entity names:

```text
.agents/state/hosts/<host>/
.agents/state/sessions/2026-05-12T101500Z/
.agents/state/tasks/2026-05-12-renderer-refactor/
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
task state
temporary scratch files
checkpoints
intermediate outputs
local caches
```

If raw state becomes meaningful for future humans, summarize it into `notes/` or `specs/`. If it creates local
follow-up work, reflect that in `.agents/state/tasks/<task>/todo.md`.

### Tasks

Canonical structure:

```text
.agents/state/tasks/YYYY-MM-DD-short-slug/
  task.md
  todo.md
```

Examples:

```text
.agents/state/tasks/2026-05-12-renderer-refactor/
.agents/state/tasks/2026-05-13-jpg-support/
.agents/state/tasks/2026-05-14-font-embedding-investigation/
```

Use `state/tasks/` when the document answers:

> How is this particular change being planned, executed, reviewed, or handed off?

Create a task directory when the work is broad, risky, multi-file, likely to span sessions, or likely to need handoff
notes. Do not create one for trivial one-turn edits unless the user explicitly asks for local task state.

Task state is mutable, local, and normally ignored by Git. It is not durable project truth and should not be committed.
Promote durable decisions into `specs/` and shared non-canonical context into `notes/`.

Suggested `task.md` sections:

```md
Task Title

Brief

Context

Plan

Notes

Decisions

Review
```

Keep `task.md` short. Omit sections that add no value.

For long-running work, refresh useful sections before pausing, ending a session, or switching context:

- Completed work
- Decisions made
- Validation run, including failures or skipped checks
- Remaining work or next recommended first step
- Specs, skills, tests, or root instructions updated as part of the task

Use `todo.md` as a coordination checklist. Keep open items actionable and bounded. Mark an item complete only after it
is implemented or deliberately resolved. If an item is intentionally skipped, close it with a short reason instead of
leaving it ambiguous.

### Checkpoints

Use `.agents/state/checkpoints/assistant.md` only when a repository benefits from resume-aware agent sessions and the
root instructions define or allow that convention. The checkpoint is runtime state, not project truth, and should
normally remain untracked.

At session start, compare the checkpoint with the current branch, `HEAD`, and worktree state before editing when the
repository asks for that behavior. If `HEAD` changed, inspect recent commits when practical and summarize the drift.
During this session-start drift check, reread current canonical skills, specs, or root instructions before applying
conventions remembered from an earlier session. Treat the repository version as authoritative.

At session closeout, refresh the checkpoint only when the user signals closeout and it is practical after any requested
commits or pushes. Keep it small and factual:

```yaml
---
repo: name
branch: main
head: HEAD_SHA
dirty: false
timestamp: 2026-05-21T21:30:00+03:00
---

Last assistant checkpoint.
```

## Repository Instructions

If the repository has an `AGENTS.md` or similar root instruction file, keep it short and operational. Use it for
repository-wide conventions, canonical file locations, and validation commands. Do not put detailed task history or
temporary decisions there.

When updating `.agents/specs/`, `.agents/skills/`, or long-lived task state, check root instructions for drift. If root
instructions and a spec disagree, prefer the spec for detailed behavior and update root instructions to point to it or
summarize it accurately.

Prompt shortcuts belong to the focused `colon` skill; this layout reference should not duplicate shortcut semantics.

## Consistency Pass

After meaningful `.agents/` changes, check that:

- Specs contain durable behavior, not temporary execution notes.
- Durable decisions from local task state have been promoted to specs or notes when needed.
- TODO items reflect the current state of work.
- Agent-facing tests still match the specs, skills, and root validation commands they support.
- Root repository instructions still point to the right canonical files and validation commands.
- Skill instructions do not contain project-specific details unless the skill is intentionally repo-local.
- Local runtime residue remains under `.agents/state/` or is summarized into notes or specs.

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
.agents/tasks/
.agents/test-output/
```
