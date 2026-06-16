---
all:
  links:
    alacritty.toml: ~/.config/alacritty/alacritty.toml
macos:
  packages:
    - cask:alacritty
---

# Alacritty

Alacritty terminal emulator configuration and package installation.

## Linux

### Install

Install alacritty via apt on Debian-family Linux hosts.

```bash
if command -v alacritty >/dev/null; then
	exit 0
fi

if ! command -v apt-get >/dev/null; then
	exit 0
fi

sudo apt-get install -y --no-install-recommends alacritty
```
