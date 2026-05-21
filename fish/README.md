---
all:
  level: minimal
  packages:
    - fish
  links:
    config.fish: ~/.config/fish/config.fish
    functions/: ~/.config/fish/functions
---

# Fish

Minimal Fish shell setup with shared functions and plugin installation.

## Postinstall

```bash
fish -c "fundle install"
```

Set Fish as the login shell after ensuring its Homebrew path is accepted by `chsh`.

```bash
fish_path=$(command -v fish)
current_shell=${SHELL:-}

if command -v getent >/dev/null; then
	current_shell=$(getent passwd "$USER" | cut -d: -f7)
fi

if [[ $current_shell == "$fish_path" ]]; then
	exit 0
fi

if ! grep -Fxq "$fish_path" /etc/shells; then
	printf '%s\n' "$fish_path" | sudo tee -a /etc/shells >/dev/null
fi

sudo chsh -s "$fish_path" "$USER"
```
