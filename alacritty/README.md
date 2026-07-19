---
all:
  links:
    alacritty.toml: ~/.config/alacritty/alacritty.toml
---

# Alacritty

Alacritty terminal emulator configuration and package installation.

## Linux

### Install

Install alacritty via apt on Debian-family Linux hosts.

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
	printf 'W: skipping alacritty install: no graphical Linux session detected\n' >&2
	exit 0
fi

if command -v alacritty >/dev/null; then
	exit 0
fi

if ! command -v apt-get >/dev/null; then
	printf 'W: skipping alacritty install: apt-get is unavailable\n' >&2
	exit 0
fi

sudo apt-get install -y --no-install-recommends alacritty
```
