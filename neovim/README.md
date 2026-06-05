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

## Postinstall

```bash
config=${XDG_CONFIG_HOME:-"$HOME"/.config}/vi

if [[ ! -e $config ]]; then
	git clone https://github.com/nvim-lua/kickstart.nvim.git "$config"
fi
```

```bash
nvim --headless +qall!
```

## Update

```bash
config=${XDG_CONFIG_HOME:-"$HOME"/.config}/vi

if [[ -d $config/.git ]]; then
	git -C "$config" pull --ff-only
fi
```
