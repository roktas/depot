---
linux:
  packages:
    - flatpak:org.inkscape.Inkscape
macos:
  packages:
    - cask:inkscape
---

# Inkscape

Vector graphics editor module installed through Flatpak on Linux and Homebrew Cask on macOS.

## Linux

### Configure

```bash
if [[ -z ${DISPLAY:-}${WAYLAND_DISPLAY:-} ]]; then
	exit 0
fi

if ! command -v xdg-mime >/dev/null; then
	exit 0
fi

if [[ $(xdg-mime query default image/svg+xml 2>/dev/null || true) != org.inkscape.Inkscape.desktop ]]; then
	xdg-mime default org.inkscape.Inkscape.desktop image/svg+xml
fi
```

## MacOS

### Configure

```bash
xattr -d com.apple.quarantine /Applications/Inkscape.app 2>/dev/null || true
```
