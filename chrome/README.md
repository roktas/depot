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
if [[ $(systemctl get-default 2>/dev/null || true) != graphical.target ]]; then
	exit 0
fi

if ! command -v apt-get >/dev/null; then
	exit 0
fi

sudo apt-get update

# Remove stale unsigned chrome.list that duplicates the signed google-chrome.list.
if [[ -f /etc/apt/sources.list.d/chrome.list ]]; then
	sudo rm -f /etc/apt/sources.list.d/chrome.list
fi

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
