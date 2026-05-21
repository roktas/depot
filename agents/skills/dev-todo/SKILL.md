---
name: dev-todo
description: Use when the user message starts with `todo ` or `todo! ` to append, edit, or print human/agent TODO files under `.agents/state/`.
---

# Agent TODO

Use this skill only for explicit TODO prompt shortcuts at the beginning of a user message.

## Shortcuts

- `todo TEXT`: append `TEXT` to `.agents/state/human/todo.md`.
- `todo! TEXT`: append `TEXT` to `.agents/state/agent/todo.md`.
- `todo edit` or `todo --edit`: open the human TODO in the default editor.
- `todo! edit` or `todo! --edit`: open the agent TODO in the default editor.
- `todo path` or `todo --path`: print the human TODO path.
- `todo! path` or `todo! --path`: print the agent TODO path.

Only treat messages that start with `todo ` or `todo! ` as shortcuts. Incidental mentions of `todo` inside normal
sentences are not commands.

## Files

Use untracked state files:

- `.agents/state/human/todo.md` for user-owned inbox notes.
- `.agents/state/agent/todo.md` for assistant-owned operational notes.

These files are not canonical project truth. Promote useful items into `.agents/tasks/<task>/todo.md` or
`.agents/specs/` only when they become tracked work or durable behavior.

## Helper

Use this skill's helper, resolved relative to the directory that contains this `SKILL.md`. Do not look for `bin/todo`
in the target repository root.

```bash
./bin/todo human "Revisit Linux package baseline"
./bin/todo agent "Re-run smoke test after changing plan helper"
./bin/todo human --edit
./bin/todo agent --path
```

