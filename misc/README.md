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
    - moreutils
    - ncdu
    - optipng
    - rclone
    - ripgrep
    - slides
    - socat
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

# Misc

This is a normal provisioning module for small shared tools and config sets that do not deserve a focused module.

Keep this module small. If an item grows platform-specific behavior, multi-step instructions, or a clear standalone
identity, move it to a focused module. GUI- or desktop-session-dependent installs belong in guarded special-section
commands, not in frontmatter packages.
