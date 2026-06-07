---
linux: ~
macos:
  packages:
    - cask:inkscape
---

# Inkscape

Vector graphics editor module installed through Flatpak on Linux and Homebrew Cask on macOS.

## Linux

### Install

Install Inkscape only on graphical Linux hosts.

```bash
if [[ $(systemctl get-default 2>/dev/null || true) != graphical.target ]]; then
	exit 0
fi

if ! command -v flatpak >/dev/null; then
	exit 0
fi

flatpak install -y --user flathub org.inkscape.Inkscape
```

Configure Inkscape as the default SVG handler when desktop MIME tools are available.


```bash
if [[ -z ${DISPLAY:-}${WAYLAND_DISPLAY:-} ]]; then
	exit 0
fi

if ! command -v xdg-mime >/dev/null; then
	exit 0
fi

xdg-mime default org.inkscape.Inkscape.desktop image/svg+xml
```
