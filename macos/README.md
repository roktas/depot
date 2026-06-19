---
all:
  level: minimal
  packages:
    - dockutil
    - duti
    - gh
    - mole
    - zoxide
---

# macOS

Minimal macOS platform tools for managing system integration and maintenance.

This module also provides common command-line tools needed by later macOS module `Install` sections.

## Configure

Enable Screen Sharing so the machine is accessible via VNC.

```bash
screen_sharing_active() {
	launchctl print system/com.apple.screensharing >/dev/null 2>&1 &&
		nc -z 127.0.0.1 5900 >/dev/null 2>&1
}

if screen_sharing_active; then
	exit 0
fi

status=0
sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.screensharing.plist || status=$?

if screen_sharing_active; then
	exit 0
fi

exit "$status"
```
