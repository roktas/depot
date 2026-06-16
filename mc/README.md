---
all:
  level: minimal
  packages:
    - mc
  links:
    kshrc: ~/.local/share/mc/kshrc
    mc.keymap: ~/.config/mc/mc.keymap
    menu: ~/.config/mc/menu
  seeds:
    mc.ini: ~/.config/mc/ini
  copies:
    skins/: ~/.local/share/mc/skins
---

# Midnight Commander

Minimal Midnight Commander setup with keymap, menu, skins, and seeded mutable configuration.
