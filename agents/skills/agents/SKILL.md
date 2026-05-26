---
name: agents
description: Use when creating, placing, or updating agent-facing repository files under `.agents/`, including skills, specs, task notes, tests, logs, scratch files, checkpoints, or runtime state.
---

# Agent Workspace

Use `.agents/` for agent-facing repository artifacts. Keep it small; do not turn it into a second project root.

This skill is a layout and workflow guide. More specific root instructions, specs, task notes, or platform-provided
features take precedence when they conflict with this generic guidance.

Load `references/layout.md` when examples, templates, or placement edge cases are useful.

## Directory Map

```text
.agents/
  notes/   shared versioned notes, inboxes, and drafts
  skills/  reusable agent capabilities
  specs/   durable repo-level or feature-level truth
  tasks/   bounded work areas and handoff notes
  tests/   agent-facing validation harnesses and fixtures
  state/   local untracked runtime residue
```

## Placement

When unsure:

1. If it teaches agents a reusable workflow, use `skills/`.
2. If it is a shared inbox note, early draft, or cross-task note that should be versioned but is not durable truth yet,
   use `notes/`.
3. If it describes what the project or feature must do, use `specs/`.
4. If it describes how a particular change is being planned, executed, reviewed, or handed off, use `tasks/`.
5. If it verifies agent-facing behavior and should be reviewed or reused, use `tests/`.
6. If it is raw, local, temporary, machine-generated, or not worth reviewing, use `state/`.

Promote information as it hardens: `notes/` can become task context or specs; task decisions that become project truth
belong in `specs/`; raw `state/` should be summarized into task notes when it matters to future humans.

## Minimal Workflow

- Use `.agents/notes/todo.md` as the shared repository TODO inbox when one is useful. It is not canonical truth.
- Create `.agents/tasks/YYYY-MM-DD-short-slug/` only for work that is broad, risky, multi-file, likely to span sessions,
  or likely to need reviewable decisions. Trivial one-turn work can stay in the conversation.
- Keep task notes short and factual: brief, context, decisions, validation, remaining work, and handoff details.
- Keep `.agents/specs/` for durable behavior, invariants, interfaces, acceptance criteria, and architectural rules.
- Keep `.agents/state/` local and untracked by default. Put checkpoints, logs, caches, scratch files, and temporary
  outputs there.
- For repo-local session checkpoints or closeout routines, follow the repository's root instructions when present and
  practical. Do not use runtime state as a substitute for durable task or spec notes.
- Prompt shortcuts are handled by the focused `colon` skill.

## Naming And Helpers

Start with the shortest clear name that the local context supports. Avoid implementation details, technology names, or
category prefixes unless they disambiguate real siblings or are part of an established interface.

For skill helpers, prefer simple command surfaces:

```text
.agents/skills/<skill>/
  SKILL.md
  bin/
    plan
    apply
```

Use extensionless names in `bin/` for directly run helper commands. Use `scripts/` for support scripts, generators, or
one-off maintainers. Add `lib/` only when shared implementation code is justified by real duplication or complexity.

When writing helper scripts or fenced code blocks under `.agents/`, load the relevant language skill when available.

## Consistency Pass

After meaningful `.agents/` changes, do a short pass:

- Specs contain durable behavior, not temporary execution notes.
- Task notes do not contradict updated specs.
- TODO items reflect the current state of work.
- Agent-facing tests still match the specs, skills, and root validation commands they support.
- Runtime residue remains under `.agents/state/` or is summarized into task notes.
- Root repository instructions still point to the right canonical files when those files changed.
