---
linux:
  level: extra
---

# GIMP

Extra Linux image editor module installed through Flatpak.

## Linux

### Install

Install GIMP only on graphical Linux hosts.

```bash
if [[ -z ${DISPLAY:-}${WAYLAND_DISPLAY:-} ]]; then
	exit 0
fi

if ! command -v flatpak >/dev/null; then
	exit 0
fi

flatpak install -y --user flathub org.gimp.GIMP
```
