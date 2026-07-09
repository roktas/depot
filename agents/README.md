---
all:
  packages:
    - playwright-cli
  links:
    AGENTS.md: ~/.agents/AGENTS.md
    skills/: ~/.agents/skills
---

# Agents

Common agent instructions and skills installed through the shared `~/.agents` surface.

Keep this module model-neutral. If an asset is only for one agent CLI, put it in that CLI's own module.

## Configure

```bash
cd "$HOME" || exit

playwright-cli install
playwright-cli install --skills agents
```
