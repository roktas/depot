---
linux:
  links:
    config.linux: ~/.config/ghostty/config
macos:
  links:
    config.macos: ~/.config/ghostty/config
  packages:
    - cask:font-ioskeley-mono
    - cask:ghostty
---

# Ghostty

Ghostty terminal configuration.

Linux uses Spleen 32x64. macOS uses Ioskeley Mono.

## MacOS

### Postinstall

```bash
source=$HOME/Dropbox/src/home/ghostty/terminfo/xterm-ghostty.terminfo

tic -x -o "$HOME"/.terminfo "$source"
```
