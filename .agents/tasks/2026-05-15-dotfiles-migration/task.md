# Dotfiles Migration Handoff

## Context

This repository is being reshaped into a Home-style dotfiles provisioning repo. The durable spec lives at
`.agents/specs/home/spec.md`. The repo-local provisioning skill lives at `.agents/skills/provision/`.

The old implementation is at `../dotfiles`. It was Debian/Linux-oriented and module-based. This repo now uses
frontmatter-driven modules with `links`, `copies`, `packages`, platform filters, and state under `.agents/state`.

## Completed

- Moved the original root `SPEC.md` into `.agents/specs/home/spec.md` and iteratively refined the design.
- Created repo-local skill `provision`.
- Added Ruby plan helper at `.agents/skills/provision/bin/plan`.
- Added the repo-local smoke test under `.agents/tests/provision/`.
- Migrated link/copy-oriented modules from `../dotfiles` into this repo, excluding `dropbox`.
- Moved the old `gnome` instructions into the root `linux` platform module and removed the standalone `gnome` module.
- Added `.gitignore` to unignore `_/**` because the user's global Git ignore ignores `_ /`.
- Added `copies` semantics to the spec, skill, helper, smoke test, and `mc/README.md`.
- Migrated shared agent skills from `../dotfiles/agents/skills` into `agents/skills`.
- Added `agents/`, `codex/`, `gemini/`, and `opencode/` modules. `agents` is now a shared source-only module;
  `codex`, `gemini`, and `opencode` link `../agents/skills/` into their own user-wide skill locations.
- Updated provisioning source resolution so `links` and `copies` may use repo-internal `../` sources without escaping
  the repository.
- Migrated `../dotfiles/nvim` as `neovim/`. The old module files are preserved except `install.sh`. The module
  explicitly installs `brew:neovim`; README frontmatter links the richer Neovim config under `~/.config/nvim` and the
  `vi` wrapper under `~/.local/bin`. README fenced blocks create `~/.config/vi` from `kickstart.nvim` on install and
  pull that repo on update.
- Migrated root `LICENSE` and `.shellcheckrc` from the old repo.
- Synced `git/bin/git-renew` with the old repo version so `.git/info` is preserved across renewals.
- Refined remote provisioning design: `remote-git`, `remote-dropbox`, and `remote-any` modes are documented. Remote
  actions always use the target machine's repo copy; state is written on the target first and copied back to the local
  state archive when the target repo is not Dropbox-synced.
- Split provisioning/update behavior into four modes: `apply`, `refresh`, `repair`, and `upgrade`. The plan helper now
  accepts `--mode`, includes mode in JSON/Markdown output, and separates install/refresh/upgrade package action lists.
- Changed package semantics: missing `packages` now means a virtual module with no package installation. Modules that
  install tools now declare packages explicitly; old `packages: []` entries were removed from module README files.
- Follow-up package audit added explicit packages for `bash` and `fzf` dependencies. `bundle` and Linux GNOME helper
  applications are treated as soft dependencies for now. Remaining package-less modules are intentionally virtual:
  `agents`, `bin`, `bundle`, `irb`, `linux`, `npm`, and `todo`.

## Validation

The following checks passed after the latest changes:

```bash
ruby -c .agents/skills/provision/bin/plan
rubocop --config .agents/tests/provision/rubocop.yml .agents/skills/provision/bin/plan
shellcheck .agents/skills/provision/bin/bootstrap .agents/skills/provision/bin/smoke .agents/tests/provision/smoke.sh _/bin/search _/todo/actions/edit _/todo/actions/note _/todo/actions/projectview _/todo/actions/revive _/todo/actions/wtf _/todo/actions/xp bin/bin/ramake javascript/bin/biome-kludge
.agents/tests/provision/smoke.sh
.agents/skills/provision/bin/smoke
python3 /home/roktas/Dropbox/src/dotfiles/agents/skills/.system/skill-creator/scripts/quick_validate.py .agents/skills/provision
```

## Decisions

- `claude/` is intentionally ignored for now.
- `agents/` contains shared files used by multiple agent tools. It currently has no install actions and no direct links.
- `codex/` links shared skills to `~/.codex/skills` and explicitly installs `brew:codex`.
- `gemini/` links shared skills to `~/.gemini/skills` and explicitly installs `brew:gemini-cli`.
- `opencode/` links shared skills to `~/.agents/skills` and explicitly installs `brew:opencode`.
- `neovim/` explicitly installs `brew:neovim`.
- `dropbox/` was removed from this repo after initial migration.
- GNOME desktop settings are Linux-only and live under the `linux/README.md` `Install` section as a guarded subsection.
- Fresh-host bootstrap lives in the provision skill and is run explicitly before normal provisioning.
- `mc.ini` and `skins/` use `copies`, not `links`, because Midnight Commander overwrites `ini`.
- `git/bin/git-renew` now matches `../dotfiles/git/bin/git-renew`.
- Modules without `packages` are intentionally virtual and install no packages.
- Old root `.github/`, `.local/`, `.rubocop.yml`, `Vagrantfile`, and `terminal.png` are not migrated for now.

## Next

Migration checklist is complete. Next session should start with a full status/diff review, run the validation commands in
`AGENTS.md`, and decide commit boundaries for the initial migration.
