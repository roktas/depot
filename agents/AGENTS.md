# User-Wide Agent Instructions

## Scope

- User-wide defaults for agents reading `~/.agents`; more specific repository, task, or tool instructions win.
- This is not `~/AGENTS.md`; target-home layout and preference policy belong there.

## Communication

- Continue in the latest conversation language unless explicitly asked to switch; if unclear, use Turkish.
- Do not switch language because of context compaction, model changes, tool output, or quoted English source text.
- Keep code-facing text in English: comments, identifiers, file names, commit messages, and repository docs.
- Be concise, direct, and explicit about errors, risks, tradeoffs, and uncertainty.
- Prefer correctness over agreement.
- For current or high-stakes facts, use official, up-to-date sources when possible and cite them.
- When you need a binary (yes/no, do/don't) answer from the user (e.g., commit messages, destructive actions),
  use the `question` tool. Set the first (Enter-selectable) option to the positive action (e.g., "Evet, komit et")
  and the negative option second.

## Engineering

- Inspect context before acting; make deliberate, justified changes.
- Track the user's underlying goal, not just the literal request; use it to guide scope, tradeoffs, and verification.
- If the goal is missing or ambiguous enough to change the approach, ask before acting; otherwise state the reasonable
  assumption and proceed.
- Stay inside user-bounded review or edit scope unless a required dependency is missing or the user expands scope.
- Keep repositories clean: no leftover temp files, dead code, or unnecessary structure.
- Keep persistent desired-state code free of one-off migrations. When migration is needed, run it as an explicit
  operator step and leave only the final steady-state behavior in tracked modules or docs.
- Do not paper over defects with sentinel or dummy state, narrow special cases, compatibility shims, or migration code
  that merely bypasses the failure. Find the root cause in the model, parser, runtime, architecture, or instructions and
  fix that cause directly.
- When the correct fix requires a broad or architectural change, plan it deliberately, add or update tests first, and
  validate the design before relying on it. Temporary workarounds are allowed only as explicit one-off operator recovery
  steps; do not leave them in persistent code, desired state, or documentation.
- Prefer existing repo patterns over new abstractions.
- Keep code self-documenting; avoid obvious comments and commented-out code.
- Run scripts with shebangs directly, e.g. `./bin/foo`; do not prefix with `bash`, `ruby`, `python`, or similar.
- Treat chat code blocks like repository code.
- In tracked repository files, do not write expanded home paths. Use `~` for home-relative paths and repo- or
  module-relative paths for repo files.

## Naming Things

These rules are mandatory when creating, renaming, or proposing names for files, directories, commands, skills, modules,
classes, functions, variables, public APIs, or concepts. Project- or language-specific naming rules override.

Before choosing a name, apply this preflight:

1. Prefer one simple, meaningful word when context allows.
2. Do not repeat context supplied by the containing project, directory, module, class, or command.
   For example, in `provision`, prefer `Plan` over `ProvisionPlan`.
3. Before using `-`, `_`, `:`, `/`, camel/Pascal compounds, or multiword names, look for a simpler one-word name.
4. Match sibling names in the same scope: style, length, and specificity.
5. Public names should be short, polished, and memorable. Internal names may be plainer or more explicit.
6. Let name length follow scope: longer globally, shorter locally.
7. Add a qualifier only when it separates real sibling concepts in the current scope; do not add one just to sound more
   precise.
8. Avoid generic modeling words unless they name a real domain role. Name what the thing is for, not the container or
   implementation shape.

Use a name that violates this preflight only for a concrete reason, and state it briefly.

## Skills

- Before matching work, load relevant language, workflow, repository, and task-specific skills.
- Treat required dispatch rules as mandatory context loading; they do not dictate implementation after loading.
- Required dispatch: `bash` for shell or shell snippets, `commits` for commit messages, `dotagents` for `.agents/`
  artifacts.
- Do not load `turkish` just because the conversation is Turkish; load it only for Turkish prose, translation,
  terminology, tone, grammar, Turkish-facing docs, or UI text.

## Session Continuity

- On resumed git workspaces, inspect branch, `HEAD`, and dirty state before editing.
- Follow checkpoint or handoff conventions; if `HEAD` or dirty state changed since the last checkpoint, summarize drift
  first.
