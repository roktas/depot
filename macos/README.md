---
all:
  level: minimal
  packages:
    - dockutil
    - duti
    - gh
    - mole
---

# macOS

Minimal macOS platform tools for managing system integration and maintenance.

This module also provides common command-line tools needed by later macOS module `Install` sections.

## Postinstall

Enable Screen Sharing so the machine is accessible via VNC.

```bash
sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.screensharing.plist
```
