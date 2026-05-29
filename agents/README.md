---
all:
  packages:
    - opencode
    - aicommits
  links:
    AGENTS.md: ~/.agents/AGENTS.md
    skills/: ~/.agents/skills
---

# Agents

Installation instructions and strict shared assets for low-cost agents.

## Setup

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
  "lsp": true,
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
