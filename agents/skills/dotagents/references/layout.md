# Dotagents Workspace Layout Reference

Load this reference when examples, templates, or placement edge cases are useful.

## Precedence

Use this reference as generic `.agents/` layout guidance. More specific instructions win in this order:

1. The user's current request
2. Root repository instructions such as `AGENTS.md`
3. Loaded operational guides under `.agents/guides/`
4. Durable specs under `.agents/specs/`
5. This reference

If a guide and a spec disagree, prefer the spec for durable behavior, invariants, interfaces, data formats, and
acceptance criteria. Prefer the guide for operational command selection and closeout workflow. Do not leave the
disagreement in place; update the stale file when the correct source is clear.

If a future agent runtime provides native task, memory, or TODO behavior, prefer the platform feature when it clearly
supersedes a repo-local convention. Keep tracked repo-local files only for artifacts that remain useful to review,
version, or share across tools.

## Core Layout

```text
.agents/
  guides/  long-form agent-facing operational guidance
  skills/  reusable agent capabilities
  specs/   durable repo-level or feature-level specifications
  tests/   agent-facing validation harnesses and fixtures
  state/   local untracked runtime residue
```

Mental model:

```text
guides/ = how agents should operate in this repository
specs/  = what must be true
skills/ = reusable agent behavior
tests/  = how agent-facing behavior is validated
state/  = local runtime residue and task state
```

`.agents/` is not a second project root. Human-facing project docs and shared human-agent planning docs live at the
repository root unless they are explicitly agent-only.

## Root Project Docs

Use these root files when a repository adopts project-level planning docs:

```text
PLAN.md       project incubation, boot planning, or living project plan
TODO.md       shared current queue for humans and agents
CHANGELOG.md  append-only project record
README.md     human-facing project invariant
AGENTS.md     agent-facing operational invariant, bootstrap instructions, and progressive-disclosure index
```

Root `TODO.md` is the shared queue. Use this shape unless the repository defines a more specific one:

```md
## Now

## Next

## Inbox
```

Add new unprioritized ideas to `Inbox`. Move items into `Now` or `Next` only when the current task or the user has made
that priority clear. Do not add a `Done` section; completed work is represented by the commit history and
`CHANGELOG.md`.

Root `AGENTS.md` should stay short enough to be read on every session. Use it for always-on rules, precedence, canonical
file locations, validation entrypoints, and links to relevant `.agents/guides/` files. It may act as a table of
contents for long operational guidance; keep enough context in the root file for an agent to know which guide to load.

Root `PLAN.md` is the first source for boot decisions and planning rationale. When planning material becomes durable
project truth, place it where it belongs:

- behavior, interfaces, invariants, acceptance criteria, formats, or architecture -> `.agents/specs/`
- human-facing project facts -> `README.md`
- agent operational rules -> `AGENTS.md`
- current queue items -> `TODO.md`
- completed work or milestones -> `CHANGELOG.md`

Load `references/project.md` for project-start templates, boot closeout, and `PLAN.md` handling.

## Guides

Common shapes:

```text
.agents/guides/build.md
.agents/guides/review.md
.agents/guides/deploy.md
.agents/guides/troubleshooting.md
```

Use `guides/` for long-form agent-facing operational guidance delegated from root `AGENTS.md`. A guide answers:

> How should an agent operate for this kind of work in this repository?

Good guide topics include build and test procedures, review expectations, release or deploy checklists, data-handling
procedures, debugging playbooks, and other repository-specific operating instructions. Guides are tracked and shared;
they are not local task notes.

When splitting a large `AGENTS.md`, keep the root file as the bootstrap and progressive-disclosure index:

```md
# Agent Instructions

Always apply this file.

## Always

- Follow existing repository patterns.
- Keep generated state out of tracked files.
- Do not run destructive cleanup without explicit approval.

## Load When Relevant

- For build, test, lint, and verification commands, read `.agents/guides/build.md`.
- For code review expectations, read `.agents/guides/review.md`.
- For release and publishing work, read `.agents/guides/release.md`.
- For deployment work, read `.agents/guides/deploy.md`.

## Canonical Truth

- Architecture and invariants live under `.agents/specs/`.
- Reusable agent workflows live under `.agents/skills/`.
- Validation harnesses live under `.agents/tests/`.
```

Do not force all split `AGENTS.md` content into `specs/`. Use the content type:

- durable behavior, interfaces, invariants, acceptance criteria, formats, or architecture -> `.agents/specs/`
- reusable multi-step agent workflows, helper commands, and portable task capabilities -> `.agents/skills/`
- reviewable validation harnesses, fixtures, smoke tests, and prompt or skill contracts -> `.agents/tests/`
- long operational guidance that remains mostly prose -> `.agents/guides/`
- local execution notes, logs, scratch files, and handoff state -> `.agents/state/`

Keep guides focused. Each guide should have a clear load condition near the top, such as "Load for release work" or
"Load before changing generated API clients." Do not put temporary decisions, task history, raw logs, or session notes
in guides. If a guide becomes durable product truth, promote that part into `specs/`. If it becomes a reusable
capability, promote it into `skills/`. If it starts carrying executable fixtures or harnesses, move those assets into
`tests/` and leave the guide as the explanation or entrypoint.

## Specs

Common shapes:

```text
.agents/specs/<feature>.md
.agents/specs/<feature>/
  spec.md
```

Use the single-file form when the feature is represented by one durable document and the file name is already clear in
the `specs/` scope. Use the directory form when the feature needs multiple spec files, fixtures, examples, or sibling
references. Do not force the directory form when it only repeats context, such as `specs/tilde/spec.md`.

Use `specs/` when the document answers:

> What should be true for this project, subsystem, or feature?

Specs hold behavior, invariants, interfaces, acceptance criteria, data formats, constraints, and architectural rules.
If specs and local task state disagree, the spec wins; update or discard stale state.

## Skills

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

Use `scripts/` for non-command support scripts, generators, one-off maintainers, or files that are not the primary
command surface of the skill.

If multiple helpers need shared code, add a small `lib/` directory inside the skill and keep shared implementation
there. Do not add `lib/` preemptively; create it only when duplication or complexity makes it useful.

When writing or editing helper scripts under `.agents/`, use the relevant language skill when one is available. Apply
the same rule to fenced code blocks in `SKILL.md`, `AGENTS.md`, specs, task state, and other agent-facing
documentation.

## Tests

Examples:

```text
.agents/tests/provision/smoke.sh
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
intermediate outputs
local caches
```

If raw state becomes meaningful for future humans, summarize it into root project docs or `.agents/specs/`. If it
creates local follow-up work, reflect that in `.agents/state/tasks/<task>/todo.md`.

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
Promote durable decisions into `specs/`; promote shared project intent into root `TODO.md`, `PLAN.md`, or
`CHANGELOG.md`.

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

Use `todo.md` as a local coordination checklist. Keep open items actionable and bounded. Mark an item complete only
after it is implemented or deliberately resolved. If an item is intentionally skipped, close it with a short reason
instead of leaving it ambiguous.

## Repository Instructions

If the repository has an `AGENTS.md` or similar root instruction file, keep it short and operational. Use it for
repository-wide conventions, canonical file locations, validation entrypoints, progressive-disclosure guide links, and
whether `PLAN.md` is boot-only or a living plan. Do not put detailed task history or temporary decisions there.

When updating `.agents/guides/`, `.agents/specs/`, `.agents/skills/`, `.agents/tests/`, or long-lived task state, check
root instructions for drift. If root instructions and a spec disagree, prefer the spec for detailed behavior and update
root instructions to point to it or summarize it accurately. If root instructions and a guide disagree, update the stale
copy or make the guide load condition more precise.

Prompt shortcuts belong to the focused `colon` skill; this layout reference should not duplicate shortcut semantics.

## Consistency Pass

After meaningful `.agents/` changes, check that:

- Specs contain durable behavior, not temporary execution notes.
- Guides contain operational guidance, not durable product truth or local task history.
- Durable decisions from local task state have been promoted to specs or root project docs when needed.
- Root `TODO.md` reflects the current state of shared work.
- Agent-facing tests still match the specs, skills, and root validation commands they support.
- Root repository instructions still point to the right guides, canonical files, and validation commands.
- Skill instructions do not contain project-specific details unless the skill is intentionally repo-local.
- Local runtime residue remains under `.agents/state/` or is summarized into root project docs or specs.

## Avoid Extra Directories

Avoid creating:

```text
.agents/agents/
.agents/docs/
.agents/instructions/
.agents/logs/
.agents/rules/
.agents/tmp/
.agents/cache/
.agents/scratch/
.agents/work/
.agents/plans/
.agents/todos/
.agents/tasks/
.agents/notes/
.agents/test-output/
tasks/
logs/
tmp/
cache/
scratch/
work/
plans/
todos/
```
