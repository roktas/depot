# Project Planning Reference

Load this reference when a repository is starting, when root `PLAN.md`, `TODO.md`, or `CHANGELOG.md` exists, or when
planning material needs to become durable project truth.

## Root Files

Use this root-level project file set when the repository needs agent-assisted project planning:

```text
PLAN.md       project incubation, boot planning, or living project plan
README.md     human-facing project invariant
AGENTS.md     agent-facing operational invariant
TODO.md       shared current queue for humans and agents
CHANGELOG.md  append-only project record
```

These files are not `.agents/` artifacts. They are root project docs that both humans and agents may read according to
their role.

## File Roles

`PLAN.md` is the planning source during project incubation. It records what the project should become, why it exists,
which alternatives were considered, which decisions are still open, and the first specification or design draft when
one exists. It is not automatically permanent authority.

Keep specification or design material in a clearly named `PLAN.md` section. Use the document language: `Specification`
or `Design` in English; `Spesifikasyon` or `Tasarım` in Turkish. If the planning output is a protocol, wire format, DSL
grammar, acceptance contract, or other durable behavior, promote that content into `.agents/specs/` or an explicitly
named root spec. If the repository keeps `PLAN.md` as a living project plan, root `AGENTS.md` must say so and define the
commit discipline.

`README.md` is for humans. It should describe what the project is, why it exists, and the stable constraints a reader
needs. Avoid implementation diary entries there.

`AGENTS.md` is for agents. Keep it operational: conventions, commands, file locations, validation, and the status of
`PLAN.md` as boot-only or living.

`TODO.md` is the shared current queue:

```md
## Now

## Next

## Inbox
```

Use `Inbox` for unprioritized ideas. Use `Now` for the current active focus. Use `Next` for accepted follow-up work.
Do not add a `Done` section; completed work is recorded by commits and `CHANGELOG.md`.

`CHANGELOG.md` is append-only. Add concise session or milestone notes. Do not rewrite old entries as a substitute for
current planning.

## PLAN.md Shape

Use only the sections that matter. This is the canonical section vocabulary:

```md
# Plan

## Motivation

## Context

## Goals

## Non-Goals

## Specification

## Design

## Rejected

## Open Questions

## Risks

## Success

## Phases

## Glossary
```

Use `Specification` when the section defines externally visible behavior, contracts, formats, or acceptance criteria.
Use `Design` when the section explains structure, architecture, or implementation shape. Keep `PLAN.md` semantic:
behavior, decisions, constraints, alternatives, and success criteria. Avoid low-level implementation notes that will
drift quickly.

Section roles:

- `Motivation`: why the project exists and which problem it solves.
- `Context`: current state, constraints, inputs, and prior decisions.
- `Goals`: what the project intends to accomplish.
- `Non-Goals`: what the project deliberately excludes.
- `Specification`: externally visible behavior, contracts, formats, CLI/API shape, or acceptance criteria.
- `Design`: internal structure, architecture, modules, data flow, or implementation shape.
- `Rejected`: alternatives considered and why they were not chosen.
- `Open Questions`: decisions that still need an answer.
- `Risks`: technical, product, or operational risks and important assumptions.
- `Success`: what counts as finished.
- `Phases`: ordering, milestones, dependencies, or rollout.
- `Glossary`: project terms and definitions.

A compact starting shape is:

```md
# Plan

## Motivation

## Goals

## Non-Goals

## Specification

## Open Questions

## Phases
```

## Project Start

Start tracking immediately so the boot phase is reviewable:

```sh
git init
```

Then create the first planning commit with `PLAN.md`. During boot, agents should read:

```text
AGENTS.md
TODO.md
PLAN.md
```

The boot loop is:

```text
build a little -> update the plan -> build a little -> update durable docs
```

When the project settles, promote durable material from `PLAN.md` into the right place:

- `.agents/specs/` for agent-facing durable behavior, interfaces, formats, or acceptance criteria
- `README.md` for human-facing stable project facts
- `AGENTS.md` for operational agent rules
- `TODO.md` for current queue items
- `CHANGELOG.md` for boot summary and milestones

If the current history stays in place, tag the commit where the initial `PLAN.md` is still available:

```sh
git tag zero
```

If the project needs a clean official history after boot, first shape the working tree as the first official commit.
When `PLAN.md` should remain available from that first commit, keep `PLAN.md` in the tree for this step. Then run the
destructive one-time operator action with explicit user confirmation naming the effect:

```sh
git renew
git tag zero
```

`git renew` is provided by the home `git` module's `git-renew` helper. It preserves the repository's `origin` URL and
default branch, rebuilds `.git`, creates the new initial commit from the tracked tree, and force-pushes that branch.
Without an argument, it reuses the original root commit subject when available and otherwise uses its default message.
Use the helper or the same logic instead of hand-editing the remote reference.

After that, the ordinary official history shape is:

```text
commit 1: PLAN.md
commit 2: PLAN.md removed, project skeleton added
commit 3+: project work
```

With this shape, `PLAN.md` remains available from the first official commit. Use `git show zero:PLAN.md`.

## Session Pattern

At session start:

- Read root `AGENTS.md`.
- Read root `TODO.md` when it exists.
- Read `PLAN.md` when the project is in boot or root `AGENTS.md` says the plan is living.

At session closeout:

- Move `TODO.md` items surgically; do not rewrite the whole file.
- Add a concise `CHANGELOG.md` entry when the session produced a durable change or useful milestone.
- Promote durable decisions from local task state into `.agents/specs/` or root docs.

## Living Plan

Some repositories keep `PLAN.md` or a root `SPEC.md` live for the whole project. This is valid only when root
`AGENTS.md` states the rule clearly.

Use this kind of rule:

```md
`PLAN.md` is a living project plan. If behavior, acceptance criteria, protocol, format, or scope changes, update
`PLAN.md` or the relevant `.agents/specs/` document in the same commit as the implementation.
```

Do not treat an unstated `PLAN.md` as permanent authority. If it conflicts with current specs, root instructions, or
implemented behavior, inspect history and clarify the intended source of truth before broad edits.
