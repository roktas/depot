---
all:
  hosts:
    - newton
    - spinoza
    - kant
  level: normal
  links:
    bin/box: ~/.local/bin/box
linux:
  links:
    dropbox.service: ~/.config/systemd/user/dropbox.service
---

# Dropbox

Runs Dropbox as a linger-enabled user service on Linux so sync can start at boot without an interactive desktop login.

## Linux

### Prerequisites

Dropbox must already be installed, linked to the user's account, and initialized once.

```bash
command -v dropbox >/dev/null
[[ -x $HOME/.dropbox-dist/dropboxd ]]
[[ -d $HOME/.dropbox ]]
```

### Configure

```bash
[[ $(uname -s) == Linux ]] || exit 0

load_user_bus() {
	local uid

	uid=$(id -u)
	if [[ -z ${XDG_RUNTIME_DIR:-} && -d /run/user/$uid ]]; then
		export XDG_RUNTIME_DIR=/run/user/$uid
	fi

	if [[ -z ${DBUS_SESSION_BUS_ADDRESS:-} && -n ${XDG_RUNTIME_DIR:-} && -S $XDG_RUNTIME_DIR/bus ]]; then
		export DBUS_SESSION_BUS_ADDRESS=unix:path=$XDG_RUNTIME_DIR/bus
	fi
}

systemctl_user() {
	load_user_bus
	systemctl --user "$@"
}

disable_desktop_autostart() {
	local file=$HOME/.config/autostart/dropbox.desktop

	if command -v timeout >/dev/null; then
		timeout 10s dropbox autostart n >/dev/null 2>&1 || true
	else
		dropbox autostart n >/dev/null 2>&1 || true
	fi

	[[ -f $file ]] || return 0

	set_desktop_key "$file" Hidden true
	set_desktop_key "$file" X-GNOME-Autostart-enabled false
}

set_desktop_key() {
	local file=$1
	local key=$2
	local value=$3

	local tmp

	tmp=$(mktemp) || exit
	awk '
		BEGIN {
			found = 0
			prefix = key "="
		}
		index($0, prefix) == 1 {
			if (!found) {
				print key "=" value
				found = 1
			}
			next
		}
		{ print }
		END {
			if (!found) {
				print key "=" value
			}
		}
	' key="$key" value="$value" "$file" >"$tmp" || {
		rm -f "$tmp"
		return 1
	}
	if ! cmp -s "$tmp" "$file"; then
		cp "$tmp" "$file" || {
			rm -f "$tmp"
			return 1
		}
	fi
	rm -f "$tmp"
}

enable_linger() {
	local user

	user=$(id -un)
	if [[ $(loginctl show-user "$user" -p Linger --value 2>/dev/null || true) != yes ]]; then
		sudo loginctl enable-linger "$user"
	fi
}

stop_legacy_dropbox() {
	if ! systemctl_user is-active dropbox.service >/dev/null 2>&1 &&
		pgrep -u "$(id -u)" -x dropbox >/dev/null 2>&1; then
		dropbox stop >/dev/null 2>&1 || true
	fi
}

disable_desktop_autostart
enable_linger
systemctl_user daemon-reload
systemctl_user enable dropbox.service
stop_legacy_dropbox
systemctl_user start dropbox.service
```

## Notes

Use `box` for service-aware manual control. `dropbox status` remains safe for direct status reads, but `box start`,
`box stop`, and `box restart` keep manual operations aligned with the systemd user service.

On non-Linux platforms, `box` does not manage a service. It keeps the same command habit and delegates to the Dropbox
CLI when available.
