# Agent Files

Load this reference when placing `AGENTS.md`, `.agents/` content, agent runtime state, or related root project
documents.

## Agent Surface

Common repository agent files are:

```text
AGENTS.md
.agents/
  guides/
  skills/
  specs/
  tests/
  state/
```

Use the roles that fit:

- `AGENTS.md`: concise always-read repository instructions, important paths, and validation entrypoints.
- `guides/`: longer repository-specific operating guidance.
- `skills/`: reusable agent capabilities and their resources.
- `specs/`: durable behavior, interfaces, formats, invariants, and acceptance criteria.
- `tests/`: reviewable agent-facing harnesses, fixtures, smoke tests, and contracts.
- `state/`: ignored task state, logs, caches, scratch files, generated output, and other runtime residue.

This layout is not exhaustive. A focused directory such as `notes/` is reasonable when the repository gives it a clear
role. Avoid turning `.agents/` into a duplicate project root.

## Ownership

Keep `AGENTS.md` and durable `.agents/` content in the main repository when they are part of the project. This is the
ordinary case and does not require `.local/`.

When agent-facing content should remain outside the published repository, keep canonical copies under `.local/root/`
and expose relative links at the expected root paths:

```text
.local/root/AGENTS.md
.local/root/.agents/
```

This is an optional publication boundary, not the default and not an access-control mechanism. The local tree may be
versioned separately when history is useful, but neither Git nor a remote is required.

## State

Use `.agents/state/` as the usual home for agent-specific runtime residue. Ignore it in whichever repository owns
`.agents/` and keep durable project truth elsewhere.

If a project already centralizes all generated and environment-dependent data under `.local/var/`,
`.local/var/agents/` is also a reasonable existing convention. Do not create `.local/` solely for agent state, and do
not split one project's agent state across both roots without a concrete reason.

Create task state only when work is broad, risky, multi-file, multi-session, or explicitly needs a handoff. Promote
durable decisions into a spec or the appropriate root document instead of preserving raw state indefinitely.

## Root Project Documents

Root project documents remain outside `.agents/` unless they are specifically agent-only:

- `README.md`: human-facing project overview and stable facts.
- `AGENTS.md`: agent-facing operating guidance.
- `PLAN.md`: project planning or incubation when the project chooses to keep one.
- `TODO.md`: a shared work queue when useful.
- `CHANGELOG.md`: a durable project record when the project maintains one.

Do not impose a required template or lifecycle on these files. Follow the repository's established meaning and move
only content whose role is clear.

## Consistency

After meaningful agent-file moves, check root instructions, guides, specs, skills, tests, project documents, ignore
rules, and state paths for stale references. Prefer durable specs for product behavior and repository instructions for
operational guidance when their roles overlap.
