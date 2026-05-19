---
all:
  packages:
    - bat
    - fastfetch
    - fd
    - fzf
    - gnu-units
    - htop
    - imagemagick
    - libqalculate
    - moreutils
    - ncdu
    - optipng
    - rclone
    - ripgrep
    - slides
    - socat
    - telnet
    - tree
    - ttyd
    - yazi
    - zip
    - zoxide
  links:
    bat/config: ~/.config/bat/config
    bin/search: ~/.local/bin/search
    todo/actions/: ~/.config/todo/actions
    todo/config: ~/.config/todo/config
---

# General

This is a normal provisioning module for small shared tools and config sets that do not deserve a focused module.

Keep this module small. If an item grows platform-specific behavior, multi-step instructions, or a clear standalone
identity, move it to a focused module.
