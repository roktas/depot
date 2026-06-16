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
graphical_host() {
	[[ $(systemctl get-default 2>/dev/null || true) == graphical.target ]] || return 1
	systemctl is-enabled gdm3 sddm lightdm display-manager 2>/dev/null | grep -q enabled
}

graphical_host || exit 0

if command -v alacritty >/dev/null; then
	exit 0
fi

if ! command -v apt-get >/dev/null; then
	exit 0
fi

sudo apt-get install -y --no-install-recommends alacritty
```
