---
name: dev-colon
description: Use when the user message starts with `:` to interpret prompt shortcuts such as `:commit`, `:push`, `:ship`, `:harness`, `:todo TEXT`, `:todo! TEXT`, or `:close`.
---

# Colon Shortcuts

Use this skill only for explicit prompt shortcuts at the beginning of a user message. The first token selects the
shortcut; the rest of the message is shortcut input.

Do not treat incidental `:` characters inside normal prose as shortcuts.

## Shortcuts

- `:commit`: stage relevant current changes and create a Conventional Commit using the `dev-commits` rules. Do not push.
- `:push`: push the current branch. Do not create a commit unless explicitly requested.
- `:ship`: commit current changes using the `dev-commits` rules, then push.
- `:harness`: run the repository's relevant harness or consistency checks. In this repo, use the validation commands in
  `AGENTS.md` and the active task/spec context.
- `:todo TEXT`: append `TEXT` to `.agents/state/human/todo.md`.
- `:todo! TEXT`: append `TEXT` to `.agents/state/agent/todo.md`.
- `:todo edit` or `:todo --edit`: open the human TODO in the default editor.
- `:todo! edit` or `:todo! --edit`: open the agent TODO in the default editor.
- `:todo path` or `:todo --path`: print the human TODO path.
- `:todo! path` or `:todo! --path`: print the agent TODO path.
- `:close`: perform the `dev-agents` closeout routine: check root instructions and `.agents/` consistency, update
  useful state or task notes, refresh the checkpoint, and commit/push only if closeout produced tracked changes.

## TODO Files

Use untracked state files:

- `.agents/state/human/todo.md` for user-owned inbox notes.
- `.agents/state/agent/todo.md` for assistant-owned operational notes.

These files are not canonical project truth. Promote useful items into `.agents/tasks/<task>/todo.md` or
`.agents/specs/` only when they become tracked work or durable behavior.

## TODO Helper

Use this skill's helper, resolved relative to the directory that contains this `SKILL.md`. Do not look for `bin/todo`
in the target repository root.

```bash
./bin/todo human "Revisit Linux package baseline"
./bin/todo agent "Re-run smoke test after changing plan helper"
./bin/todo human --edit
./bin/todo agent --path
```
