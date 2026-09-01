# User-Wide Agent Instructions

These are user-wide defaults. More-specific repository, task, or tool instructions override them only for a concrete
conflict.

## Skills

- Load a skill only when its unique guidance can materially affect a decision or result; do not load one merely because
  its language, file type, tool, or name appears.
- Before creating, renaming, or proposing a durable name or path, load `naming`.
- Use `local` when deciding ownership or placement of `.local/`, `.agents/`, or other project-lifecycle side files.

## Shell

- Prefix every shell command with `rtk`; in chains and pipelines, prefix each command. Use `rtk proxy <cmd>` when raw
  output is required.
- Run executable shebang scripts directly. Do not bypass a missing executable bit by invoking the interpreter; fix the
  mode only when the file is in scope, otherwise report the defect.
- For literal `rg` searches, single-quote the pattern; prefer `-e 'pattern'` when it may look like an option.

## Communication

- Continue in the latest conversation language; if unclear, use Turkish. Do not switch because of tool output, quoted
  text, context compaction, or model changes.
- Keep code-facing text in English: comments, identifiers, file names, commit messages, and repository documentation.
- When writing technical English, use ASD-STE100 Simplified Technical English unless a more-specific project,
  publication, or genre convention requires otherwise.
- Be concise, direct, and explicit about errors, risks, tradeoffs, and uncertainty. Prefer correctness over agreement.
- Treat questions as questions and hedges as uncertainty, not as commands or settled conclusions.
- Verify current or high-stakes facts against authoritative, up-to-date sources when practical.

## Repository work

- Inspect applicable instructions, relevant artifacts, repository state, and the underlying goal before editing. On
  resumed Git work, check branch, `HEAD`, and dirty state for material drift.
- A review or diagnosis request does not authorize edits.
- Prefer project-native solutions and existing patterns. Make the smallest coherent change and leave no dead code,
  temporary structure, accidental churn, or unrelated cleanup.
- Preserve compatibility only for a concrete current contract such as a released API, external consumer, persisted or
  deployed state, or explicit requirement. Do not preserve superseded paths merely because they existed before.
- When a decision changes, make the resulting current state canonical across affected code, tests, documentation,
  configuration, specifications, and instructions; remove contradictory residue within scope.
- Review the affected artifact or bounded surface as a whole, not only changed hunks. Check for stale names, obsolete
  branches, dead code, unused dependencies, stale tests or docs, TODOs, debug output, generated residue, and accidental
  formatting churn.
- Verify changes in proportion to risk. Run narrow checks first and broaden only when shared behavior or risk warrants it.

## Commits

- Use Conventional Commits unless a repository has a stronger established convention.
- Derive the commit message from the staged or intended diff and its effect. Keep one reader-visible purpose per commit
  when practical; use a scope only when it adds stable context, and do not claim fixes, tests, compatibility, performance,
  or breaking behavior that the diff does not support.
- Prefer a short imperative subject. Use a body only when non-obvious rationale or compatibility consequences matter.
