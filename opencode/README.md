---
all:
  packages:
    - opencode
    - aicommits
  links:
    AGENTS.md: ~/.config/opencode/AGENTS.md
    skills/: ~/.config/opencode/skills
---

# OpenCode

OpenCode package setup and heavier low-cost-agent skill assets.

## Setup

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

OpenCode reads skills from `~/.config/opencode/skills`; provisioning links the heavier OpenCode skill surface there.

Keep shared, model-neutral skills under `agents/skills`. Put OpenCode-only heavy prompts under `opencode/skills`.

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
