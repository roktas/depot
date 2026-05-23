---
name: dev-agents
description: Use when creating, placing, or updating agent-facing repository files under `.agents/`, including skills, specs, task notes, tests, logs, scratch files, checkpoints, or runtime state.
---

# Agent Workspace

Use `.agents/` for agent-facing repository artifacts. Keep it small; do not turn it into a second project root.

For concrete directory examples and task templates, load `references/layout.md`.

## Layout

```text
.agents/
  notes/
  skills/
  specs/
  tasks/
  tests/
  state/
```

## Placement Rules

- `.agents/skills/` - Reusable agent capabilities. Skill file structure is defined by the active skill-authoring
  convention, not by this workspace layout (e.g. Codex `skill-creator` skill).
- `.agents/notes/` - Versioned shared working notes that are useful before they belong in specs or task directories.
- `.agents/specs/` - Durable repo-level or feature-level truth.
- `.agents/tasks/` - Versioned work areas for bounded tasks.
- `.agents/tests/` - Agent-facing validation harnesses, fixtures, smoke tests, or test configs that support specs,
  skills, or task workflows.
- `.agents/state/` - Local, untracked runtime residue.

When unsure:

1. If it teaches agents a reusable workflow, use `skills/`.
2. If it is a shared inbox note, early draft, or cross-task note that should be versioned but is not durable truth yet,
   use `notes/`.
3. If it describes what the project or feature must do, use `specs/`.
4. If it describes how a particular change is being planned, executed, reviewed, or handed off, use `tasks/`.
5. If it verifies agent-facing behavior and should be reviewed or reused, use `tests/`.
6. If it is raw, local, temporary, machine-generated, or not worth reviewing, use `state/`.

## Naming

Start with the shortest clear name that the local context can support. Do not encode implementation details,
technology choices, or category prefixes into file, directory, or helper names unless they disambiguate real neighbors
or form an established convention.

Prefer simple contextual names such as `smoke`, `testing.md`, `plan`, or `state/hosts/` when the parent directory or
section already supplies the missing meaning. Use hyphenated or underscored multiword names only when a single word
would be ambiguous, when several sibling artifacts need the same prefix, or when an external ecosystem requires that
style.

Avoid names that would need to change only because an internal implementation changed. For example, a smoke-test helper
should not include the container or VM backend in its name unless multiple backend-specific helpers coexist.

## Specs

Use `.agents/specs/<feature>/spec.md` for durable project or feature requirements: behavior, invariants, interfaces,
acceptance criteria, data formats, constraints, or architectural rules.

Do not put temporary task plans, progress tracking, raw logs, or local state in `specs/`.

When a task-local decision becomes durable project truth, move or summarize it into `specs/`. Keep only a short note in
the task narrative saying the spec was updated. If task notes and specs disagree, the spec wins; update stale task
notes.

## Notes

Use `.agents/notes/` for shared, versioned working material that is useful across sessions but has not earned a more
specific home yet.

Good fits:

- `.agents/notes/todo.md` - Shared repository TODO inbox. It is not user-owned or agent-owned; both humans and agents
  may add, edit, complete, or promote items.
- Early spec drafts before the owning `.agents/specs/<feature>/spec.md` location is clear.
- Cross-task questions, rough decisions, or coordination notes that are expected to be reviewed later.

Do not put raw logs, local caches, generated output, private machine state, or throwaway scratch in `notes/`; those
belong under `.agents/state/`. Do not leave durable requirements in `notes/` after they become project truth; promote
them into `specs/` and keep only a short pointer if useful.

## Skill Helpers

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

If multiple helpers need shared code, add a small `lib/` directory inside the skill and keep shared implementation there.
Do not add `lib/` preemptively; create it only when duplication or complexity makes it useful.

When writing or editing helper scripts under `.agents/`, use the relevant language skill when one is available. Apply
the same rule to fenced code blocks in `SKILL.md`, `AGENTS.md`, specs, task notes, and other agent-facing documentation:
the code should follow the conventions of its language, even when it is documentation rather than a standalone file.

## Tasks

Use `.agents/tasks/YYYY-MM-DD-short-slug/` for bounded units of work such as refactors, bug fixes, investigations,
migrations, experiments, documentation passes, release preparation, or implementation passes.

Default files:

```text
.agents/tasks/<task>/
  task.md
  todo.md
```

- `task.md` - Durable task narrative: refined brief, context, assumptions, plan, notes, decisions, spec updates, review,
  and handoff information.
- `todo.md` - Versioned coordination checklist. Do not put raw tool traces, transcripts, or temporary scratch output here.

Keep `task.md` as a section-based single-file narrative by default. Do not create task-local companion files unless the
content is large enough that splitting improves reviewability.

If a task-local requirement becomes durable project truth, summarize it into `.agents/specs/<feature>/spec.md` and record the spec update in `task.md`.

Use `todo.md` as a coordination checklist:

- Keep open items actionable and bounded.
- Mark an item complete only after it is implemented or deliberately resolved.
- If an item is intentionally skipped, close it with a short reason instead of leaving it ambiguous.
- Split vague or broad items into smaller decision or implementation items.
- Remove or rewrite stale items when the task direction changes.

For long-running work, maintain `task.md` as a handoff document. Before pausing, ending a session, or switching context,
refresh the useful sections:

- Completed work
- Decisions made
- Validation run, including failures or skipped checks
- Remaining work or next recommended first step
- Any spec, skill, or repository-instruction files updated as part of the task

## Tests

Use `.agents/tests/` for validation code that is primarily for agent-maintained behavior rather than the product's normal
test suite. Examples include smoke scripts, fixtures, Dockerfiles, linter configs, golden outputs, or helper scripts for
validating specs and skills.

Prefer the repository's normal test locations for product tests. Use `.agents/tests/` when the tests support agent
workflows, provisioning behavior, prompt/skill contracts, migration safety, or repository automation conventions.

Keep `.agents/tests/` reviewable and deterministic. Do not put temporary run output, downloaded dependencies, logs,
caches, or generated artifacts there; those belong under `.agents/state/` or a normal ignored build/cache location.

## State

Use `.agents/state/` only for local runtime state: logs, session traces, tool-call dumps, temporary scratch files,
checkpoints, intermediate outputs, and local caches.

When state is scoped to runtime entities such as hosts, environments, or sessions, group those entities under a named
state category instead of placing instances at the `state/` root. For example, use `.agents/state/hosts/<host>/` rather
than `.agents/state/<host>/`.

This directory should normally be ignored by Git:

```gitignore
.agents/state/
```

If raw state becomes meaningful for future humans, summarize it into `.agents/tasks/<task>/task.md`. If it creates
follow-up work, reflect that in `.agents/tasks/<task>/todo.md`.

State is not a substitute for task narrative. If state is meant to be durable, portable, or part of the project's
behavioral contract, define that explicitly in a spec.

## Session Checkpoints

Use `.agents/state/checkpoints/assistant.md` as the default local checkpoint when a repository benefits from resume-aware
agent sessions. The checkpoint is runtime state, not project truth, and should normally remain untracked.

At the start of a resumed or fresh session, compare the checkpoint to the current repository state before making edits:

- Read `.agents/state/checkpoints/assistant.md` if it exists.
- Run `git status --short --branch`.
- Compare the recorded branch and `HEAD` with the current branch and `HEAD`.
- If `HEAD` changed, inspect the commits since the checkpoint when possible and summarize the drift before editing.
- If the worktree is dirty, inspect the relevant status or diff before editing.
- If the checkpoint is missing or the history was rewritten so the old `HEAD` is not reachable, fall back to the recent
  local log and explain that the checkpoint could not be compared directly.

When the user signals session closeout and it is practical, refresh the checkpoint after any requested commits or
pushes. Keep it small and factual:

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

If the worktree is dirty at closeout, record `dirty: true` and include a short status summary below the frontmatter.
Do not use the checkpoint to hide unresolved task state; promote durable handoff notes to tracked task files when they
matter to future humans.

## Shared TODO

Use `.agents/notes/todo.md` as the shared repository TODO inbox. It is tracked, reviewable, and editable by humans and
agents. It is still an inbox rather than canonical truth; promote useful items into `.agents/tasks/<task>/todo.md` or
`.agents/specs/` when they become bounded work or durable behavior.

Use `.agents/state/` only for local runtime residue such as checkpoints, logs, cache, or throwaway scratch. Do not use
`.agents/state/human/` for TODOs.

Prompt shortcuts such as `:todo TEXT`, `:todo! TEXT`, `:commit`, `:push`, `:ship`, `:harness`, and `:close` are handled
by the focused `dev-colon` skill.

## Repository Instructions

If the repository has an `AGENTS.md` or similar root instruction file, keep it short and operational. Use it for
repository-wide conventions, canonical file locations, and validation commands. Do not put detailed task history or
temporary decisions there.

When updating `.agents/specs/`, `.agents/skills/`, or long-lived task notes, check root instructions for drift. If root
instructions and a spec disagree, prefer the spec for detailed behavior and update the root instructions to point to it
or summarize it accurately.

## Consistency Pass

After meaningful `.agents/` changes, do a short consistency pass:

- Specs contain durable behavior, not temporary execution notes.
- Task notes do not contradict updated specs.
- Todo items reflect the current state of work.
- Agent-facing tests still match the specs, skills, and root validation commands they support.
- Root repository instructions still point to the right canonical files and validation commands.
- Skill instructions do not contain project-specific details unless the skill is intentionally repo-local.
- Local runtime residue remains under `.agents/state/` or is summarized into task notes.

## Session Closeout

When the user signals they are ending the session, such as "that's enough for today", "I'm leaving", or "we'll continue
later", do a lightweight closeout before the final response when practical:

- Check whether project-specific root instructions such as `AGENTS.md` need updates.
- Check whether `.agents/notes/`, `.agents/specs/`, `.agents/tasks/`, `.agents/skills/`, `.agents/tests/`, or `.agents/state/` need
  updates, summaries, or cleanup for a future resumed session.
- Record durable decisions in specs, bounded work progress in task notes, and runtime residue in state.
- Refresh `.agents/state/checkpoints/assistant.md` when resume drift detection would help future sessions.
- Refresh handoff notes and todos so a later resume can continue without reconstructing context from the chat.
- Mention any closeout updates in the final response, or explicitly say no closeout updates were needed.

## Git Policy

Track:

```text
.agents/skills/
.agents/notes/
.agents/specs/
.agents/tasks/
.agents/tests/
```

Ignore:

```text
.agents/state/
```

New top-level directories or task-local files require an explicit repository convention.
