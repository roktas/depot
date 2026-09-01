# User-Wide Agent Instructions

## Scope

- User-wide defaults for agents reading `~/.agents`; more-specific repository, task, or tool instructions refine them
  and override them only for a concrete conflict.
- This is not `~/AGENTS.md`; keep target-home layout and preference policy there.

## Skills (Mandatory)

- Before work, load relevant language, workflow, repository, and task skills.
- Mandatory dispatch: `code` for engineering and code-review tasks; `text` for substantive prose planning, drafting,
  or structural revision.
- Also mandatory: `bash` for shell code or snippets, and `local` for `.agents/` artifacts and project-local ownership or
  placement.
- Before creating, renaming, or proposing a durable name or path, load `naming`; apply project and language naming rules
  with it.
- For a commit-specific decision under an active Covit root, load that root's `concerns/commit.md`. For Git-only work
  with no active root, inspect the staged diff and follow repository convention; do not activate a root only to obtain
  commit policy.
- Dispatch selects context, not implementation. Choose implementation after reading every applicable skill.
- Apply overlapping instructions cumulatively. Loading a skill does not suspend unrelated user-wide rules, and a
  narrower rule's silence is not a waiver. Override a default only for a concrete conflict; otherwise keep both.
- Load a natural-language skill only when text in that language is the user-requested work product; conversation or
  response language alone is insufficient. When `text` applies, let it orchestrate the target-language skill.

## Shell Commands (Mandatory)

- Prefix every shell command with `rtk`. In a chain or pipeline, prefix each command.
- Use `rtk proxy <cmd>` for raw output. Use `rtk gain` or `rtk gain --history` for savings data.
- Run executable scripts with shebangs directly, e.g. `rtk ./bin/foo`; do not invoke them through `bash`, `ruby`,
  `python`, or similar interpreters.
- If a required shebang script is not executable, use a repository-supported wrapper. If none exists, fix its mode only
  when the file is in edit scope; otherwise report the packaging defect. Do not bypass the mode with an interpreter.
- For literal `rg` searches, single-quote the pattern. Prefer `-e 'pattern'` when the pattern may look like an option or
  contains punctuation-heavy text.

## Communication

### Language and Style

- Continue in the latest conversation language unless asked to switch; if unclear, use Turkish. Never switch because
  of context compaction, model changes, tool output, or quoted English text.
- Keep code-facing text in English: comments, identifiers, file names, commit messages, and repository docs.
- Be concise, direct, and explicit about errors, risks, tradeoffs, and uncertainty.
- Prefer correctness over agreement.
- Verify current or high-stakes facts against official, up-to-date sources when possible and cite them.
- For a required binary user decision, use the `question` tool if available. Put the positive action first (e.g.
  `Evet, komit et`) and the negative action second. Otherwise ask a concise yes/no question in chat.

### Questions and Uncertainty

- Treat user questions as genuine unless explicitly marked rhetorical. Do not treat a question as supplying its own
  answer, decision, or command.
- Treat hedges as uncertainty, not conclusions. Turkish `gibi`, `sanıyorum`, `galiba`, `muhtemelen`, and similar forms
  can mark doubt. Preserve it instead of silently turning the statement into a definite assertion.

For a question or expression of doubt:

1. Inspect the relevant context and evidence.
2. Evaluate the claim and plausible alternatives.
3. State the supported conclusion and reasoning. Say when no change is needed; implement only when warranted and
   authorized.

- `Bu fonksiyon fazla büyüdü gibi` -> assess whether it is actually too large; do not automatically refactor it.
- `Sanıyorum bu tasarım sorunlu` -> verify the concern; do not accept it as a verdict.
- `Değişken adı uygun?` -> evaluate the name; do not assume it is unsuitable.

## Repository Work

- Before acting in a repository, inspect applicable instructions, relevant files, and the user's underlying goal.
- On resumed Git work, inspect the branch, `HEAD`, and dirty state before editing, then summarize drift from the last
  handoff or visible session context.
- If ambiguity could materially change the approach, ask before acting. Otherwise state a reasonable assumption, stay
  within the requested review or edit scope, and report any dependency that would expand it.
- Prefer existing repository patterns, verify changes in proportion to risk, and leave no temporary files, dead code,
  or unnecessary structure.
- For engineering changes, apply the code-review rules below to the final diff and affected artifacts before closeout.
  Fix in-scope findings; report unrelated pre-existing debt instead of silently expanding scope.

## Code Review Rules

- Review the selected change and its bounded affected surfaces, not only the changed hunks.
- Aggressively search those surfaces for leftovers, stale state, and slop: superseded names or concepts, dead code,
  unused dependencies, obsolete branches, stale tests, fixtures, documentation, or configuration, unjustified
  compatibility paths, duplicated logic, TODOs, placeholders, debug output, temporary files, and accidental churn.
- Re-read each affected artifact or module as a whole. Check structural integrity, control and data flow, terminology,
  assumptions, interfaces, error behavior, and agreement among code, tests, documentation, configuration,
  specifications, and desired state.
- Report actionable in-scope defects with evidence and consequences. Treat unrelated pre-existing debt as separate
  context, not as a finding against the reviewed change, unless the change worsens it or relies on it.

## Naming Things

- Treat naming as a preflight, not cleanup: load `naming` before choosing any durable name or path.
- Project vocabulary and language-specific `## Naming` rules refine the general naming skill.
