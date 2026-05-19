---
all:
  level: minimal
  packages:
    - fish
  links:
    config.fish: ~/.config/fish/config.fish
    functions/: ~/.config/fish/functions
---

# Fish

Minimal Fish shell setup with shared functions and plugin installation.

## Postinstall

```bash
fish -c "fundle install"
```
