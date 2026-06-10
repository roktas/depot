---
all:
  level: minimal
  packages:
    - fish
    - fisher
  links:
    config.fish: ~/.config/fish/config.fish
    functions/: ~/.config/fish/functions
---

# Fish

Minimal Fish shell setup with shared functions and plugin installation.

## Postinstall

```bash
fish -c "fisher install metrofish/metrofish PatrickF1/fzf.fish"
```

Set Fish as the login shell after ensuring its path is accepted by `chsh`. On macOS, Homebrew Fish is normally
`/opt/homebrew/bin/fish`, which is not present in `/etc/shells` by default. This step requires an interactive terminal
because `sudo` may prompt; remote deployment should defer and report it. Reconnect SSH after it succeeds so the new
login shell takes effect.

```bash
fish_path=$(command -v fish 2>/dev/null || true)
current_shell=${SHELL:-}

if [[ -z $fish_path && -x /opt/homebrew/bin/fish ]]; then
	fish_path=/opt/homebrew/bin/fish
fi

if [[ -z $fish_path ]]; then
	printf 'fish is not installed or not on PATH\n' >&2
	exit 1
fi

case $(uname -s) in
Darwin)
	current_shell=$(dscl . -read "/Users/$USER" UserShell | awk '{print $2}')
	;;
Linux)
	if command -v getent >/dev/null; then
		current_shell=$(getent passwd "$USER" | cut -d: -f7)
	fi
	;;
esac

if [[ $current_shell != "$fish_path" ]]; then
	if ! grep -Fxq "$fish_path" /etc/shells; then
		printf '%s\n' "$fish_path" | sudo tee -a /etc/shells >/dev/null
	fi

	sudo chsh -s "$fish_path" "$USER"
fi

printf 'Reconnect SSH to start Fish as the login shell.\n'
```
