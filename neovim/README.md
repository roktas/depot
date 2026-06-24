---
all:
  level: minimal
  packages:
    - neovim
    - tree-sitter-cli
  links:
    init.lua: ~/.config/nvim/init.lua
    lazyvim.json: ~/.config/nvim/lazyvim.json
    lua/: ~/.config/nvim/lua
    bin/: ~/.local/bin
---

# Neovim

Minimal Neovim and `vi` setup with LazyVim-oriented user configuration.

## Configure

```bash
config=${XDG_CONFIG_HOME:-"$HOME"/.config}/vi

if [[ ! -e $config ]]; then
	mkdir -p "${config%/*}"
	git clone https://github.com/nvim-lua/kickstart.nvim.git "$config"
fi
```

```bash
if command -v nvim >/dev/null; then
	nvim_config=${XDG_CONFIG_HOME:-"$HOME"/.config}/nvim

	if [[ -e $nvim_config/init.lua && -e $nvim_config/lazyvim.json && -d $nvim_config/lua ]]; then
		nvim --headless \
			'+Lazy! install' \
			'+lua require("config.mason").install_tools()' \
			+qa
	fi
fi
```

## Linux

### Configure

Expose the Homebrew-managed Neovim executable through sudo's system path without adding the whole user-writable
Homebrew `bin` directory to `secure_path`.

```bash
nvim=$(command -v nvim || true)
target=/usr/local/bin/nvim

[[ -n $nvim ]] || exit 0

if [[ -L $target && $(readlink "$target") == "$nvim" ]]; then
	exit 0
fi

if [[ -e $target || -L $target ]]; then
	printf 'E: refusing to replace existing %s\n' "$target" >&2
	exit 1
fi

sudo install -d "${target%/*}"
sudo ln -s "$nvim" "$target"
```

## Update

```bash
config=${XDG_CONFIG_HOME:-"$HOME"/.config}/vi

if [[ -d $config/.git ]]; then
	git -C "$config" pull --ff-only
fi
```
