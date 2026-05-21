---
all:
  level: minimal
  packages:
    - tmux
  links:
    tmux.conf: ~/.config/tmux/tmux.conf
    bin/: ~/.local/bin
---

# Tmux

Minimal tmux configuration and terminal editor/viewer helpers.

Interactive Fish sessions with a real TTY auto-start or attach to the `main` tmux session, while non-interactive shells
and shells started with `NO_TMUX=1` stay outside tmux. Tmux panes use `tmux-default-command` to start Fish through
`PATH`, so Linux Homebrew and macOS Homebrew installations both work.
