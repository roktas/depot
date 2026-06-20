---
macos:
  packages:
    - cask:google-chrome@beta
---

# Chrome

Google Chrome Beta browser package and Linux apt repository setup.

## Linux

### Install

Install Google Chrome Beta from Google's apt repository on Debian-family Linux hosts.

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
	printf 'W: skipping Chrome install: no graphical Linux session detected\n' >&2
	exit 0
fi

if ! command -v apt-get >/dev/null; then
	printf 'W: skipping Chrome install: apt-get is unavailable\n' >&2
	exit 0
fi

sudo apt-get update

sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://dl.google.com/linux/linux_signing_key.pub |
	sudo gpg --dearmor --batch --yes -o /etc/apt/keyrings/google-chrome.gpg
sudo chmod a+r /etc/apt/keyrings/google-chrome.gpg

arch=$(dpkg --print-architecture)
printf 'deb [arch=%s signed-by=/etc/apt/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main\n' "$arch" |
	sudo tee /etc/apt/sources.list.d/google-chrome.list >/dev/null

sudo apt-get update
sudo apt-get install -y --no-install-recommends google-chrome-beta
```
