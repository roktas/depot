---
all:
  level: minimal
  packages:
    - fish
    - fisher
  links:
    conf.d/brew.fish: ~/.config/fish/conf.d/brew.fish
    config.fish: ~/.config/fish/config.fish
    functions/: ~/.config/fish/functions
---

# Fish

Minimal Fish shell setup with shared functions and plugin installation.

## Configure

```bash
install_plugins() {
	local fish_path=$1

	"$fish_path" <<'FISH'
set -l plugins metrofish/metrofish PatrickF1/fzf.fish

functions -q fisher
or begin
	printf '%s\n' 'fisher is not available' >&2
	exit 1
end

set -l installed (fisher list 2>/dev/null)
set -l missing

for plugin in $plugins
	contains -- $plugin $installed; or set -a missing $plugin
end

test (count $missing) -eq 0; or fisher install $missing
FISH
}

fish_path=$(command -v fish 2>/dev/null || true)

if [[ -z $fish_path && -x /opt/homebrew/bin/fish ]]; then
	fish_path=/opt/homebrew/bin/fish
fi

if [[ -z $fish_path ]]; then
	printf 'fish is not installed or not on PATH\n' >&2
	exit 1
fi

install_plugins "$fish_path"

case $(uname -s) in
Darwin)
	current_shell=$(dscl . -read "/Users/$USER" UserShell | awk '{print $2}')
	;;
Linux)
	current_shell=$(getent passwd "$USER" 2>/dev/null | cut -d: -f7 || true)
	;;
esac

if [[ ${current_shell:-} != "$fish_path" ]]; then
	sudo line ensure /etc/shells "$fish_path"
	sudo chsh -s "$fish_path" "$USER"
	printf 'Reconnect SSH to start Fish as the login shell.\n'
fi
```
