---
all:
  level: minimal
  packages:
    - mc
  links:
    kshrc: ~/.local/share/mc/kshrc
    mc.keymap: ~/.config/mc/mc.keymap
    menu: ~/.config/mc/menu
  copies:
    mc.ini: ~/.config/mc/ini
    skins/: ~/.local/share/mc/skins
---

# Midnight Commander

Minimal Midnight Commander setup with keymap, menu, and copied mutable configuration.
