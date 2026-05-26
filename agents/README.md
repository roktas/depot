---
all:
  packages:
    - cask:codex
    - opencode
    - aicommits
  links:
    codex/hooks/rubyfmt: ~/.codex/hooks/rubyfmt
    codex/hooks/shellcheck: ~/.codex/hooks/shellcheck
    codex/hooks/shfmt: ~/.codex/hooks/shfmt
    skills/: ~/.agents/skills
---

# Agents

Installation instructions and shared assets for agents.

## Setup

### Codex

Make Enter insert a newline in the editor and submit with Ctrl/Alt+Enter or Ctrl+M.

```toml
[tui.keymap.composer]
submit = ["ctrl-enter", "alt-enter", "ctrl-m"]

[tui.keymap.editor]
insert_newline = ["enter"]
```

Format changed shell scripts with `shfmt` after Codex writes files through shell commands or patches.

```toml
[[hooks.PostToolUse]]
matcher = "^(Bash|apply_patch)$"

[[hooks.PostToolUse.hooks]]
type = "command"
command = "~/.codex/hooks/shfmt"
timeout = 30
statusMessage = "Formatting shell files"
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

### OpenCode

Make Return insert a newline in the input and submit with Ctrl/Alt/Super+Return.

```json
{
  "$schema": "https://opencode.ai/tui.json",
  "keybinds": {
    "input_newline": "return",
    "input_submit": "ctrl+return,alt+return,super+return"
  }
}
```

Format and lint supported file types after writes and edits.

```json
{
  "$schema": "https://opencode.ai/config.json",
  "lsp": {
    "bash": {},
    "gopls": {},
    "ruby-lsp": {},
    "pyright": {},
    "yaml-ls": {}
  },
  "formatter": {
    "rubyfmt": {
      "command": ["rubyfmt", "--in-place", "$FILE"],
      "extensions": [".rb", ".rake", ".gemspec", ".ru"]
    },
    "rubocop": {
      "disabled": true
    },
    "standardrb": {
      "disabled": true
    },
    "shfmt": {},
    "gofmt": {},
    "ruff": {},
    "prettier": {}
  }
}
```

Go formatting uses `gofmt` (wrapper at `go/bin/gofmt` prefers `gofumpt` when available).

### Antigravity

Make Enter insert a newline and submit with Ctrl/Alt/Cmd+Enter.

```json
[
  {
    "command": "-input.submit",
    "key": "enter"
  },
  {
    "command": "input.newline",
    "key": "enter"
  },

  {
    "command": "-input.newline",
    "key": "ctrl+enter"
  },
  {
    "command": "-input.newline",
    "key": "alt+enter"
  },
  {
    "command": "-input.newline",
    "key": "cmd+enter"
  },

  {
    "command": "input.submit",
    "key": "ctrl+enter"
  },
  {
    "command": "input.submit",
    "key": "alt+enter"
  },
  {
    "command": "input.submit",
    "key": "cmd+enter"
  }
]
```

Apply these bindings and hook settings to the user-level configuration files.
