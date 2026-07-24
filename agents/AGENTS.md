# User-Wide Agent Instructions

## Scope

- User-wide defaults for agents reading `~/.agents`; more-specific repository, task, or tool instructions override them.
- This is not `~/AGENTS.md`; keep target-home layout and preference policy there.

## Skills (Mandatory)

- Before work, load relevant language, workflow, repository, and task skills.
- Mandatory dispatch: `bash` for shell code or snippets, `commits` for commit messages, and `lokal` for `.agents/`
  artifacts and project-local ownership or placement. Dispatch selects context. Choose implementation after reading
  the skill.
- Load `turkish` only for Turkish prose, translation, terminology, tone, grammar, documentation, or UI text;
  conversation language alone is insufficient.

## Shell Commands (Mandatory)

- Prefix every shell command with `rtk`. In a chain or pipeline, prefix each command.
- Use `rtk proxy <cmd>` for raw output. Use `rtk gain` or `rtk gain --history` for savings data.
- Run scripts with shebangs directly, e.g. `rtk ./bin/foo`; do not invoke them through `bash`, `ruby`, `python`, or
  similar interpreters.
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

- Treat user questions as genuine unless explicitly marked rhetorical. They imply no answer, decision, or command.
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

## Engineering

### Workflow

- Before acting, inspect relevant instructions, files, and context. Identify the user's underlying goal.
- On resumed Git work, inspect the branch, `HEAD`, and dirty state before editing. First summarize drift from the last
  handoff or visible session context.
- If ambiguity could materially change the approach, ask before acting. Otherwise state a reasonable assumption and
  proceed.
- Stay within the user's review or edit scope. Report any required dependency that would expand it.
- Prefer existing repository patterns over new abstractions; verify changes in proportion to risk.
- Keep repositories clean: leave no temporary files, dead code, or unnecessary structure.

### Fixes and Code

- Fix root causes in the model, parser, runtime, architecture, or instructions. Do not bypass defects with sentinel or
  dummy state, narrow special cases, compatibility shims, or migration code.
- For a broad or architectural fix, plan deliberately, add or update tests first, and validate the design.
- Keep persistent desired state free of one-off migrations and recovery workarounds. Run them as explicit operator
  steps; track only the final steady-state code or documentation.
- Keep code self-documenting; avoid obvious comments and commented-out code. Treat chat code blocks like repository
  code.
- In tracked files, use `~` for home-relative paths and repository- or module-relative paths for repository files. Never
  write expanded home paths.

## Naming Things

When creating, renaming, or proposing a file, directory, command, skill, module, class, function, variable, public API,
or concept, apply this mandatory preflight. Project- or language-specific naming rules override it.

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

Break this preflight only for a concrete reason, and state it briefly.
