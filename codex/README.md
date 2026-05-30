---
all:
  packages:
    - cask:codex
  links:
    hooks/: ~/.codex/hooks
    skills/: ~/.codex/skills
---

# Codex

Codex-specific user assets.

Codex uses the shared instructions from `~/.agents/AGENTS.md`. Keep this module limited to Codex-only hooks and skills;
do not mirror shared agent instructions here.

## Setup

Make Enter insert a newline in the editor and submit with Ctrl/Alt+Enter or Ctrl+M.

```toml
[tui.keymap.composer]
submit = ["ctrl-enter", "alt-enter", "ctrl-m"]

[tui.keymap.editor]
insert_newline = ["enter"]
```

Format changed shell and Go files after Codex writes files through shell commands or patches.

```toml
[[hooks.PostToolUse]]
matcher = "^(Bash|apply_patch)$"

[[hooks.PostToolUse.hooks]]
type = "command"
command = "~/.codex/hooks/shfmt"
timeout = 30
statusMessage = "Formatting shell files"

[[hooks.PostToolUse.hooks]]
type = "command"
command = "~/.codex/hooks/gofmt"
timeout = 30
statusMessage = "Formatting Go files"
```

Run `shellcheck` before Codex stops so generated Bash issues are fixed before the final response.

```toml
[[hooks.Stop]]

[[hooks.Stop.hooks]]
type = "command"
command = '/usr/bin/python3 "$HOME"/.codex/hooks/shellcheck'
timeout = 30
statusMessage = "Running shellcheck on modified Bash files"
```

Review and trust the hook from `/hooks` the first time Codex reports a new hook.
