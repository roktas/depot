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

## Linux

### Install

```bash
graphical_host() {
	local session=${XDG_CURRENT_DESKTOP:-}${DESKTOP_SESSION:-}

	if [[ -n $session && ! $session =~ (tty|headless) ]]; then
		return 0
	fi

	if [[ $(systemctl get-default 2>/dev/null || true) == graphical.target ]]; then
		return 0
	fi

	if systemctl is-enabled gdm3 sddm lightdm display-manager 2>/dev/null |
		grep -Eq '^(enabled|static|generated|alias|indirect)$'; then
		return 0
	fi

	if [[ -s /etc/X11/default-display-manager ]]; then
		return 0
	fi

	compgen -G '/usr/share/xsessions/*.desktop' >/dev/null && return 0
	compgen -G '/usr/share/wayland-sessions/*.desktop' >/dev/null && return 0

	return 1
}

if ! graphical_host; then
	printf 'W: skipping Ghostty install: no graphical Linux session detected\n' >&2
	exit 0
fi

if command -v ghostty >/dev/null; then
	exit 0
fi

if command -v apt-get >/dev/null; then
	sudo apt-get update
	if apt-cache show ghostty >/dev/null 2>&1; then
		sudo apt-get install -y --no-install-recommends ghostty
		exit 0
	fi
fi

if command -v snap >/dev/null; then
	sudo snap install ghostty --classic
	exit 0
fi

printf 'W: skipping Ghostty install: no apt package or snap command is available\n' >&2
```

## MacOS

### Post Install

```bash
source=$HOME/Dropbox/home/ghostty/terminfo/xterm-ghostty.terminfo

tic -x -o "$HOME"/.terminfo "$source"
```
