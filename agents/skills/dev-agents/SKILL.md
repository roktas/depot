---
name: dev-agents
description: Use when creating, placing, or updating agent-facing repository files under `.agents/`, including skills, specs, task notes, todos, tests, logs, scratch files, checkpoints, runtime state, or `todo`/`todo!` prompt shortcuts.
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
  tests/
  state/
```

## Placement Rules

- `.agents/skills/` - Reusable agent capabilities. Skill file structure is defined by the active skill-authoring
  convention, not by this workspace layout (e.g. Codex `skill-creator` skill).
- `.agents/specs/` - Durable repo-level or feature-level truth.
- `.agents/tasks/` - Versioned work areas for bounded tasks.
- `.agents/tests/` - Agent-facing validation harnesses, fixtures, smoke tests, or test configs that support specs,
  skills, or task workflows.
- `.agents/state/` - Local, untracked runtime residue.

When unsure:

1. If it teaches agents a reusable workflow, use `skills/`.
2. If it describes what the project or feature must do, use `specs/`.
3. If it describes how a particular change is being planned, executed, reviewed, or handed off, use `tasks/`.
4. If it verifies agent-facing behavior and should be reviewed or reused, use `tests/`.
5. If it is raw, local, temporary, machine-generated, or not worth reviewing, use `state/`.

## Specs

Use `.agents/specs/<feature>/spec.md` for durable project or feature requirements: behavior, invariants, interfaces,
acceptance criteria, data formats, constraints, or architectural rules.

Do not put temporary task plans, progress tracking, raw logs, or local state in `specs/`.

When a task-local decision becomes durable project truth, move or summarize it into `specs/`. Keep only a short note in
the task narrative saying the spec was updated. If task notes and specs disagree, the spec wins; update stale task
notes.

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

## Human And Agent TODO

Use `.agents/state/human/todo.md` for user-owned, untracked project notes that may later be shown to an agent. Use
`.agents/state/agent/todo.md` for the assistant's own untracked operational checklist. Neither file is canonical project
truth; promote useful items into `.agents/tasks/<task>/todo.md` or `.agents/specs/` only when they become tracked work
or durable behavior.

Use this skill's helper, resolved relative to the directory that contains this `SKILL.md`, to append checklist items,
print paths, or open these files. Run these commands from the skill directory, or otherwise resolve `bin/todo` relative
to the skill directory. Do not look for `bin/todo` in the target repository root.

```bash
./bin/todo human "Revisit Linux package baseline"
./bin/todo agent "Re-run smoke test after changing plan helper"
./bin/todo human --edit
./bin/todo agent --path
```

Prompt shortcuts:

- `todo TEXT`: append `TEXT` to `.agents/state/human/todo.md`.
- `todo! TEXT`: append `TEXT` to `.agents/state/agent/todo.md`.
- `todo edit` or `todo --edit`: open the human TODO in the default editor.
- `todo! edit` or `todo! --edit`: open the agent TODO in the default editor.
- `todo path` or `todo --path`: print the human TODO path.
- `todo! path` or `todo! --path`: print the agent TODO path.

Only treat messages that start with `todo ` or `todo! ` as shortcuts. Incidental mentions of `todo` inside normal
sentences are not commands.

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
- Check whether `.agents/specs/`, `.agents/tasks/`, `.agents/skills/`, `.agents/tests/`, or `.agents/state/` need
  updates, summaries, or cleanup for a future resumed session.
- Record durable decisions in specs, bounded work progress in task notes, and runtime residue in state.
- Refresh handoff notes and todos so a later resume can continue without reconstructing context from the chat.
- Mention any closeout updates in the final response, or explicitly say no closeout updates were needed.

## Git Policy

Track:

```text
.agents/skills/
.agents/specs/
.agents/tasks/
.agents/tests/
```

Ignore:

```text
.agents/state/
```

New top-level directories or task-local files require an explicit repository convention.
