---
level: extra
macos:
  packages:
    - cask:obsidian
---

# Obsidian

Extra Obsidian desktop module.

macOS uses Homebrew Cask. Debian-family Linux hosts install the official amd64 `.deb` from the latest Obsidian GitHub
release when Obsidian is not already installed.

## Linux

### Install

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

obsidian_installed() {
	dpkg-query -W -f='${Status}\n' obsidian 2>/dev/null |
		grep -Fxq 'install ok installed'
}

if obsidian_installed; then
	exit 0
fi

if ! graphical_host; then
	printf 'W: skipping Obsidian install: no graphical Linux session detected\n' >&2
	exit 0
fi

if ! command -v apt-get >/dev/null || ! command -v dpkg-query >/dev/null; then
	printf 'W: skipping Obsidian install: apt/dpkg is unavailable\n' >&2
	exit 0
fi

if [[ $(dpkg --print-architecture) != amd64 ]]; then
	printf 'W: skipping Obsidian install: only amd64 deb packages are supported\n' >&2
	exit 0
fi

for command in curl ruby; do
	if ! command -v "$command" >/dev/null; then
		printf 'E: %s is required to install Obsidian\n' "$command" >&2
		exit 1
	fi
done

api_url=https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest
tempdir=$(mktemp -d)
trap 'rm -rf "$tempdir"' EXIT HUP INT QUIT TERM

package=$tempdir/obsidian.deb
download_url=$(
	curl -fsSL "$api_url" |
		ruby -rjson -e '
release = JSON.parse(STDIN.read)
asset = release.fetch("assets").find { |item| item.fetch("name").end_with?("_amd64.deb") }
abort "E: Obsidian amd64 deb asset not found" unless asset
puts asset.fetch("browser_download_url")
'
)

curl -fL "$download_url" -o "$package"
sudo apt-get install -y "$package"
```
