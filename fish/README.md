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

## Postinstall

```bash
fish -c "fundle install"
```
