---
linux:
  packages:
    - flatpak:org.inkscape.Inkscape
---

# Inkscape

## Install

Configure Inkscape as the default SVG handler when desktop MIME tools are available.

```bash
if ! command -v xdg-mime >/dev/null; then
	exit 0
fi

xdg-mime default org.inkscape.Inkscape.desktop image/svg+xml
```
