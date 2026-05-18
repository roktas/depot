# Dotfiles Migration Todo

- [x] Review and migrate old `agents/` module as shared agent skills only.
- [x] Migrate AI tool modules `codex/`, `gemini/`, and `opencode/` as README-only provisioning modules.
- [x] Ignore `claude/` for now.
- [x] Decide and migrate `../dotfiles/nvim` as `neovim/`:
  - keep the old module files except `install.sh`;
  - rely on the default `brew:neovim` package;
  - link `~/.config/nvim` and `~/.local/bin/vi` through frontmatter;
  - create `~/.config/vi` from `kickstart.nvim` during install;
  - pull `~/.config/vi` during update.
- [x] Review and sync `git/bin/git-renew` with `../dotfiles/git/bin/git-renew`.
- [x] Decide old repo root files:
  - keep `LICENSE`;
  - keep `.shellcheckrc` for possible shared disables;
  - skip `.github/`, `.local/`, `.rubocop.yml`, `Vagrantfile`, and `terminal.png` for now.
