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
	nvim --headless +qall!
fi
```

## Update

```bash
config=${XDG_CONFIG_HOME:-"$HOME"/.config}/vi

if [[ -d $config/.git ]]; then
	git -C "$config" pull --ff-only
fi
```
