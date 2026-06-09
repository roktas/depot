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

### Postinstall

```bash
if [[ -z ${DISPLAY:-}${WAYLAND_DISPLAY:-} ]]; then
	exit 0
fi

if ! command -v xdg-mime >/dev/null; then
	exit 0
fi

xdg-mime default org.inkscape.Inkscape.desktop image/svg+xml
```

## MacOS

### Postinstall

```bash
xattr -d com.apple.quarantine /Applications/Inkscape.app
```
