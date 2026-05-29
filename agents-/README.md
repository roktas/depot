---
all:
  packages:
    - cask:codex
  links:
    AGENTS.md:
      - ~/.codex/AGENTS.md
      - ~/.claude/CLAUDE.md
      - ~/.gemini/GEMINI.md
    codex/hooks/: ~/.codex/hooks
    skills/:
      - ~/.codex/skills
      - ~/.claude/skills
      - ~/.gemini/skills
---

# Agents Frontier

Installation instructions and concise shared assets for frontier agents.

## Setup

### Codex

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
