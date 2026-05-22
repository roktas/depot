# Debian Provisioning Migration

## Brief

Plan the migration of `../debian` provisioning scripts into this Depot-style dotfiles repository.

The planning pass is complete and the migration has started. Keep migrating in small reviewable groups.

The source repository provisions Debian machines system-wide with root privileges. This repository should prefer
user-wide provisioning wherever practical. System-wide Linux work is acceptable only when it is inherently operating
system state, such as apt policy, locale, timezone, firewall, service setup, virtualization, printing, or hardware
support.

## Ground Rules

- Prefer Homebrew packages for normal CLI and development tools on Linux.
- Use `deb:` packages only for unavoidable Linux system integration.
- Use `flatpak:` for desktop applications when it gives a better user-wide or distro-neutral Linux story.
- Prefer existing modules over new root modules.
- Avoid tiny identity-less root modules that only declare a few packages.
- Merge same-name scripts across namespaces into one target module, for example `runtime/javascript.sh` and
  `development/javascript.sh` both feed `javascript`.
- Treat old Debian-specific repository bootstrapping, backports setup, and legacy `.deb` download logic as migration
  hints, not behavior to preserve.
- Convert GitHub release download/install scripts to either normal package declarations when Homebrew has a good
  formula, or to `github:` package declarations only when no better package source exists.
- Put conditional system instructions in `linux/README.md` for now. Avoid `linux/bin/*` helpers until the module file
  layout is revisited, because module-local `bin/` directories read like linkable target assets in this repository.

## Module Strategy

- Existing focused modules must absorb all related packages and instructions. Do not put a provisioning item in a meta
  module when a matching focused module already exists, for example `alacritty`, `direnv`, `fish`, `ghostty`, `git`,
  `javascript`, `markdown`, `mc`, `neomutt`, `neovim`, `python`, `ruby`, `tmux`, `vscode`, and `zsh`.
- Do not add `terminal` or `desktop` root meta modules. Put small shared user tools without a focused module under `_`.
  Put Linux GUI, Flatpak, fonts, hardware, printing, VPN, and system integration work under `linux`.
- Do not add a `development` meta module. This whole repository already has a development-oriented purpose, so a
  `development` module would duplicate the repository's top-level semantics instead of creating a useful boundary.
- Add language modules only when they collect a coherent language runtime/toolchain: `c`, `crystal`, `go`, `java`,
  `javascript`, `lua`, `python`, `ruby`, `shell`, and `tex`. Fold small language-specific tool modules into their
  owning language module; use a dash variant only when the owning language module becomes too broad.
- Use `level: normal` for `bash`, `ruby`, `python`, and `javascript`; use `level: extra` for the other language modules
  unless later promoted.
- Add a `ghostty` focused module instead of burying Ghostty in `linux`.
- Do not add a `virtualization` root meta module. Treat virtualization provisioning as Linux system work under
  `linux/README.md`, using explicit extra/manual sections instead of frontmatter package declarations.
- Keep OS policy, apt configuration, locale, timezone, SSH/sudo tweaks, cleanup, and conditional GNOME/Linux snippets in
  `linux`.
- Do not migrate language server installation. Neovim/LazyVim Mason will manage language servers.
- Avoid system-wide development package installs where project-local managers can own the toolchain, for example Bundler,
  uv, npm/Bun, or per-project package manifests.
- Ignore legacy Debian development provisioning scripts that mainly install Debian packaging tools or broad system
  development headers.
- Keep Dropbox installation out of normal provisioning. Treat it as a separate bootstrap problem for Dropbox-backed
  hosts.

## Validation Notes

Fresh-host validation now uses the Lima-based smoke helper from the provision skill.
- Neovim postinstall did not complete cleanly. `nvim --headless +qall!` triggered Lazy.nvim plugin work and reached an
  interactive prompt related to Codeium auth, so the process was terminated and `neovim` was marked `notok` in state.
- SSH install instructions were applied manually after the Neovim stop, and `/etc/ssh/sshd_config` plus
  `/etc/sudoers.d/ssh` were updated.
- RubyGems warned that the user gem bin directory is not on `PATH`:
  `~/.local/share/gem/ruby/4.0.0/bin`.

## Script Review

### Root

- `debian`
  - Target module: none; use as migration map and historical reference.
  - Packages: none.
  - Instructions:
    - Preserve only bundle ordering and predicates as planning hints.
    - Ignore root repo cloning and `/usr/local/bin/debian` linking.
    - Treat `boot.prepare` as superseded by `_/bin/bootstrap`.
    - Treat dotfiles bootstrap as obsolete for this repository.

### Foundation

- `foundation/foundation.sh`
  - Target module: `linux`.
  - Packages: `deb:curl`, `deb:git`, `deb:gnupg`, `deb:lsb-release`; possible brew/user packages in existing modules:
    `jq`, `libarchive`, `make`, `rsync`, `unzip`, `wget`, `xz`, `zstd`.
  - Instructions:
    - Keep apt translation disable and no-recommends policy as Linux install instructions.
    - Skip Debian backports and Griffo repository setup as legacy Debian-specific behavior.
    - Do not perform global `apt upgrade` during normal apply; map it only to explicit `upgrade`.

- `foundation/standard.sh`
  - Target module: `linux` plus possible `_` package candidates.
  - Packages: likely `deb:file`, `deb:dnsutils`, `deb:plocate`, `deb:procps`; possible brew/user packages `htop`,
    `moreutils`, `ncdu`, `rclone`, `socat`, `telnet`, `tree`, `zip`.
  - Instructions:
    - Skip Debian priority sweep with `grep-aptavail`; it is too broad and system-image oriented.
    - Review each listed package for user-wide Homebrew availability before adding.

- `foundation/locale.sh`
  - Target module: `linux`.
  - Packages: `deb:locales`.
  - Instructions:
    - Keep as guarded Linux system instructions.
    - Support Ubuntu and Debian branches explicitly.
    - Default locale remains a decision point; current script defaults to `en_US.UTF-8` while also generating
      `tr_TR.UTF-8`.

- `foundation/timezone.sh`
  - Target module: `linux`.
  - Packages: none, except implicit `deb:tzdata` if missing.
  - Instructions:
    - Keep as optional system instruction for `Europe/Istanbul`.
    - Simplify if Ubuntu handles `timedatectl set-timezone Europe/Istanbul` reliably.

- `foundation/tweak.sh`
  - Target module: `linux`.
  - Packages: none.
  - Instructions:
    - Keep only clearly wanted OS tweaks after review: SSH keepalive/env, sudo SSH env preservation, optional MOTD
      suppression, grub timeout, kernel log level, speaker blacklist.
    - Treat user `adm` group addition as system policy needing confirmation.
    - Avoid blindly editing PAM, GRUB, and sshd config unless the section is explicit and guarded.

- `foundation/firewall.sh`
  - Target module: `linux`.
  - Packages: `deb:ufw`.
  - Instructions:
    - Keep as optional system firewall section.
    - Do not enable the firewall automatically without confirmation.

- `foundation/dropbox.sh`
  - Target module: none.
  - Packages: none.
  - Instructions:
    - Skip. Dropbox installation is a separate bootstrap problem for Dropbox-backed hosts.
    - Do not manage Dropbox as part of normal provisioning.

- `foundation/clean.sh`
  - Target module: `linux`.
  - Packages: none.
  - Instructions:
    - Keep only as a guarded VM/image cleanup section.
    - Run only when virtualization is detected or the user explicitly requests image cleanup.
    - Skip aggressive documentation removal by default.
    - Keep apt cache/log/history cleanup as optional, not normal provisioning.

### Terminal

- `terminal/terminal.sh`
  - Target module: `_` and `linux`.
  - Packages: `rclone`, `qalc`, `units`.
  - Instructions:
    - Move SSH environment import snippets to `linux` if still needed system-wide.
    - Prefer user shell config equivalents before writing `/etc/profile.d` or `/etc/fish/conf.d`.

- `terminal/git.sh`
  - Target module: `git`.
  - Packages: `git`, `gh`, `tig`, `lazygit`.
  - Instructions:
    - `git` owns GitHub CLI config and package declaration.
    - Prefer Homebrew `lazygit` and `tig` over GitHub release or apt install.
    - Do not migrate `git-cc`.
    - Reconsider system credential helper build; prefer user Git config and package-provided helpers.

- `terminal/fish.sh`
  - Target module: `fish`.
  - Packages: `fish`.
  - Instructions:
    - Existing module already declares `fish`.
    - `chsh` is system state; keep as optional postinstall instruction, not default.

- `terminal/nvim.sh`
  - Target module: `neovim`.
  - Packages: `neovim`.
  - Instructions:
    - Existing module already uses `neovim`.
    - Skip nightly tarball and alternatives setup; this repo now manages user config and package declaration.

- `terminal/vifm.sh`
  - Target module: none; dropped for now.
  - Packages: none.
  - Instructions:
    - Do not migrate `vifm` unless it is explicitly revived later.

- `terminal/bat.sh`
  - Target module: `_`.
  - Packages: `bat`.
  - Instructions:
    - `_` owns Bat config because the module is small and has no standalone behavior.
    - Skip GitHub `.deb` release installer.

- `terminal/crush.sh`
  - Target module: none.
  - Packages: none.
  - Instructions:
    - Do not migrate `crush` for now.

- `terminal/direnv.sh`
  - Target module: `direnv`.
  - Packages: `direnv`.
  - Instructions:
    - Existing module already declares `direnv`.

- `terminal/fd.sh`
  - Target module: `_`.
  - Packages: `fd`.
  - Instructions:
    - Prefer Homebrew `fd`.
    - Skip GitHub `.deb` release installer.

- `terminal/fzf.sh`
  - Target module: `_`.
  - Packages: `fzf`.
  - Instructions:
    - `_` owns `fzf` because the module only contributes a small search helper.
    - Keep `ripgrep` in `_` because the local search helper requires it.

- `terminal/ripgrep.sh`
  - Target module: `_`.
  - Packages: `ripgrep`.
  - Instructions:
    - Existing `_` module already declares `ripgrep`.
    - Skip GitHub `.deb` release installer.

- `terminal/slides.sh`
  - Target module: `_`.
  - Packages: `slides` or `github:maaslalani/slides`.
  - Instructions:
    - Verify Homebrew formula; otherwise use `github:`.

- `terminal/sudo.sh`
  - Target module: `linux`.
  - Packages: none.
  - Instructions:
    - Keep only as optional system sudo policy.
    - Do not install passwordless sudo rules by default.

- `terminal/tmux.sh`
  - Target module: `tmux`.
  - Packages: `tmux`.
  - Instructions:
    - Existing module already declares `tmux`.
    - Skip shell-changing behavior unless explicitly requested.

- `terminal/ttyd.sh`
  - Target module: `_`.
  - Packages: `ttyd` or `github:tsl0922/ttyd`.
  - Instructions:
    - Prefer Homebrew if available; otherwise install to `~/.local/bin` via `github:`.

- `terminal/mc.sh`
  - Target module: `mc`.
  - Packages: `mc`.
  - Instructions:
    - Existing module already declares `mc`.

- `terminal/neomutt.sh`
  - Target module: `neomutt`.
  - Packages: `neomutt`.
  - Instructions:
    - Existing module declares `neomutt`.
    - Do not migrate `mailcap` or `urlview` extras for now.

- `terminal/yazi.sh`
  - Target module: `_`.
  - Packages: `yazi`.
  - Instructions:
    - Prefer Homebrew `yazi`.

- `terminal/zoxide.sh`
  - Target module: `_`.
  - Packages: `zoxide`.
  - Instructions:
    - Prefer Homebrew `zoxide`.
    - Skip GitHub `.deb` release installer.

- `terminal/zsh.sh`
  - Target module: `zsh`.
  - Packages: `zsh`.
  - Instructions:
    - Existing module already declares `zsh`.

- `terminal/caddy.sh`
  - Target module: none.
  - Packages: none.
  - Instructions:
    - Do not migrate `caddy` or `xcaddy` for now.

- `terminal/fastfetch.sh`
  - Target module: `_`.
  - Packages: `fastfetch`.
  - Instructions:
    - Prefer Homebrew `fastfetch`.
    - Skip GitHub `.deb` release installer.

### Runtime And Development

- `runtime/runtime.sh`
  - Target module: none.
  - Packages: none.
  - Instructions:
    - Ignore broad system development headers by default.
    - Move a dependency to a focused language module only if a later concrete module needs it.

- `development/development.sh`
  - Target module: none.
  - Packages: none.
  - Instructions:
    - Ignore broad system development header and build dependency provisioning.
    - Add individual tools later only when a focused module needs them.

- `runtime/debian.sh`
  - Target module: none.
  - Packages: none.
  - Instructions:
    - Empty script; skip.

- `development/debian.sh`
  - Target module: none.
  - Packages: none.
  - Instructions:
    - Ignore Debian packaging provisioning for now.
    - Revisit only if Debian package maintenance becomes an explicit use case.

- `runtime/crystal.sh`
  - Target module: `crystal`.
  - Packages: `crystal`; possible Linux build deps `deb:libgmp-dev`, `deb:libssl-dev`, `deb:libxml2-dev`,
    `deb:libyaml-dev`, `deb:zlib1g-dev`.
  - Instructions:
    - Prefer Homebrew `crystal` over upstream install script.
    - Mark as `extra` unless Crystal is part of normal baseline.

- `development/crystal.sh`
  - Target module: `crystal`.
  - Packages: none.
  - Instructions:
    - Empty script; skip unless Crystal development tools are added later.

- `runtime/go.sh`
  - Target module: `go`.
  - Packages: `go`.
  - Instructions:
    - Prefer Homebrew `go`.
    - Skip `/opt/go` and `/usr/local/bin` symlink management.
    - Put GOPATH/GOBIN config in user shell/environment files if needed.

- `development/go.sh`
  - Target module: `go`.
  - Packages: possible package or project-local command for `github.com/mvdan/gofumpt`.
  - Instructions:
    - Do not install `gopls`; language servers are managed by Neovim/LazyVim Mason.
    - Add `gofumpt`; decide later whether it is a Homebrew package, `go install` action, or project-local tool.

- `runtime/java.sh`
  - Target module: `java`.
  - Packages: `openjdk`.
  - Instructions:
    - Replaced `default-jre` with Homebrew `openjdk`.
    - Migrated as `level: extra`.

- `development/java.sh`
  - Target module: `java`.
  - Packages: same JDK package as runtime; no separate `default-jdk`.
  - Instructions:
    - Collapsed runtime and development Java into one module.

- `runtime/javascript.sh`
  - Target module: `javascript`.
  - Packages: `node`, `yarn`, `bun`.
  - Instructions:
    - Prefer Homebrew packages over NodeSource/Yarn apt repositories and Bun GitHub zip.
    - JavaScript owns Bun, npm, Biome, and ESLint config.
    - Avoid `npm install -g npm@latest`; use package manager update semantics.

- `development/javascript.sh`
  - Target module: `javascript`.
  - Packages: `npm:@biomejs/biome`.
  - Instructions:
    - JavaScript owns Biome config and helper script.
    - Skip direct GitHub binary installer.

- `runtime/lua.sh`
  - Target module: `lua`.
  - Packages: `lua`.
  - Instructions:
    - Prefer Homebrew `lua`.

- `development/lua.sh`
  - Target module: `lua`.
  - Packages: none.
  - Instructions:
    - Do not migrate `lua-language-server`; language servers are managed by Neovim/LazyVim Mason.

- `runtime/markdown.sh`
  - Target module: none.
  - Packages: none.
  - Instructions:
    - Empty script; skip.

- `development/markdown.sh`
  - Target module: none.
  - Packages: none.
  - Instructions:
    - Do not migrate `marksman`; language servers are managed by Neovim/LazyVim Mason.
    - Existing `markdown` module covers Markdownlint and Prettier.

- `runtime/python.sh`
  - Target module: `python`.
  - Packages: `python`, `uv`; avoid system `python3-numpy`, `python3-pandas`, `python3-pip` unless explicitly needed.
  - Instructions:
    - Prefer user Python tooling via `uv`.
    - Numeric packages should be project dependencies, not dotfiles baseline, unless user confirms.

- `development/python.sh`
  - Target module: `python`.
  - Packages: `uv`, maybe `ruff`, existing `egg:pylint`.
  - Instructions:
    - Python owns Pylint config and package declaration.
    - Prefer Homebrew `uv`.
    - Avoid broad system-wide development installs; Python tools should usually be project-local through `uv`.
    - Decide whether `ruff` belongs globally or remains project-local.

- `runtime/ruby.sh`
  - Target module: `ruby` and `bundle`.
  - Packages: `ruby`.
  - Instructions:
    - Prefer Homebrew `ruby`; skip `ruby-install` and `/opt/ruby`.
    - Existing `bundle` module owns Gemfile/config; `ruby` owns IRB and RuboCop.
    - Do not install system-wide or broad global gems from this migration.
    - Keep user gemrc behavior only if it is represented as user config.

- `development/ruby.sh`
  - Target module: `ruby`.
  - Packages: none for now; existing `ruby` module already declares `gem:rubocop`.
  - Instructions:
    - Do not run global `gem update`.
    - Do not migrate broad global development gems.
    - Prefer project-wise Bundler/Gemfile management for debug, test, lint, and Rails-related gems.
    - Do not migrate `ruby-lsp`; language servers are managed by Neovim/LazyVim Mason.

- `runtime/shell.sh`
  - Target module: none.
  - Packages: none.
  - Instructions:
    - Empty script; skip.

- `development/shell.sh`
  - Target module: `bash`.
  - Packages: `shellcheck`.
  - Instructions:
    - Prefer Homebrew `shellcheck`.
    - Do not migrate `bash-language-server`; language servers are managed by Neovim/LazyVim Mason.
    - Keep `shellcheck` in the existing `bash` module.

- `runtime/tex.sh`
  - Target module: `tex`.
  - Packages: `texlive`, `pandoc`.
  - Instructions:
    - Replaced Debian TeX Live split packages with Homebrew `texlive`.
    - Migrated as `level: extra`.

- `development/tex.sh`
  - Target module: `tex`.
  - Packages: none.
  - Instructions:
    - Did not migrate `texlab`; language servers are managed by Neovim/LazyVim Mason.

- `development/c.sh`
  - Target module: `c`.
  - Packages: `llvm`, `clang-format`, `cmake`.
  - Instructions:
    - Prefer Homebrew packages; use `llvm` for Clang and clang-tidy.
    - Migrated as `level: extra`; do not use a `development` meta module.

### Desktop

- `desktop/desktop.sh`
  - Target module: focused modules, `_`, and `linux`.
  - Packages: existing `alacritty` and `ghostty` modules own their terminal packages; Linux candidates include
    `flameshot`, `flatpak`, `remmina`, `wl-clipboard`, `xournalpp`, and `flatpak:com.github.PintaProject.Pinta`.
  - Instructions:
    - Existing `alacritty` module owns Alacritty config and package; do not duplicate in `desktop`.
    - `ghostty` is a focused module and should not be duplicated in `linux`.
    - Flatpak update maps to `refresh`, not normal apply.
    - Avahi/mdns setup moved to the normal Linux desktop package baseline.
    - Do not migrate `regexxer` or `ulauncher` for now.

- `desktop/chrome.sh`
  - Target module: `linux`.
  - Packages: likely `cask:google-chrome` for macOS; Linux needs deb repo or browser choice review.
  - Instructions:
    - Skip hardcoded apt repository until Linux browser policy is decided.

- `desktop/dropbox.sh`
  - Target module: none.
  - Packages: none.
  - Instructions:
    - Skip. Dropbox installation is a separate bootstrap problem for Dropbox-backed hosts.
    - Do not auto-authorize account linking.

- `desktop/dropignore.sh`
  - Target module: `linux-`.
  - Packages: `github:mweirauch/dropignore`.
  - Instructions:
    - Install to `~/.local/bin` through the `github:` package flow.

- `desktop/fonts.sh`
  - Target module: `linux`.
  - Packages: `deb:fonts-spleen` for the Linux baseline; other font packages remain in the `fonts` module for now.
  - Instructions:
    - Install `fonts-spleen` from a Linux system section.
    - Prefer user font installation later if font files are vendored or downloaded.

- `desktop/graphics.sh`
  - Target module: `linux`.
  - Packages: `imagemagick`, `optipng`, `flatpak:org.inkscape.Inkscape`, `flatpak:org.gimp.GIMP`.
  - Instructions:
    - Prefer Flatpak for Inkscape and GIMP on Linux.

- `desktop/laptop.sh`
  - Target module: `linux`.
  - Packages: `deb:bluetooth`, `deb:iw`, `deb:powertop`, `deb:wireless-tools`, `deb:wpasupplicant`,
    `deb:avahi-autoipd`.
  - Instructions:
    - Hardware/system services; keep Linux-only and probably `extra`.

- `desktop/obsidian.sh`
  - Target module: `linux`.
  - Packages: `flatpak:md.obsidian.Obsidian` or `cask:obsidian` on macOS; avoid GitHub `.deb` installer if possible.
  - Instructions:
    - Prefer Flatpak/cask package declarations.

- `desktop/printer.sh`
  - Target module: `linux`.
  - Packages: `deb:cups`, `deb:cups-bsd`, `deb:cups-client`, `deb:hplip`, `deb:printer-driver-all`, plus related PPD
    packages if still needed.
  - Instructions:
    - Keep as optional Linux printing section.

- `desktop/vpn.sh`
  - Target module: `linux`.
  - Packages: `deb:network-manager-openvpn-gnome`.
  - Instructions:
    - Keep Linux desktop-only and optional.

- `desktop/vscode.sh`
  - Target module: `vscode`.
  - Packages: existing `cask:visual-studio-code`; Linux package source needs review if VS Code should install on Linux.
  - Instructions:
    - Existing module already owns VS Code extensions.
    - Skip apt repository setup unless Linux Code package is required.

- `desktop/wezterm.sh`
  - Target module: none.
  - Packages: none.
  - Instructions:
    - Skip; WezTerm was removed from this repository in favor of Ghostty.

- `desktop/anki.sh`
  - Target module: `linux`.
  - Packages: `flatpak:net.ankiweb.Anki` if acceptable, or `github:ankitects/anki`.
  - Instructions:
    - Prefer Flatpak if current enough.
    - Keep `libxcb-cursor0` only if GitHub tarball installer remains necessary.

- `desktop/calibre.sh`
  - Target module: `linux-`.
  - Packages: none in frontmatter; install `flatpak:com.calibre_ebook.calibre` from a guarded section.
  - Instructions:
    - Install through Flatpak only on graphical Linux hosts.
    - Skip upstream shell installer on update and likely on apply unless no package option fits.

### Virtualization

- `virtualization/docker.sh`
  - Target module: `linux`.
  - Packages: none in frontmatter; install Linux system packages inside an explicit Docker section:
    `docker-ce`, `docker-ce-cli`, `containerd.io`, `docker-buildx-plugin`, `docker-compose-plugin`.
  - Instructions:
    - Existing provision docs already contain Docker Debian setup; reconcile instead of duplicating.
    - Keep Docker apt repository setup as Linux system instruction.
    - Treat as extra/manual system provisioning, not normal package declaration.
    - User group addition to `docker` requires confirmation and session restart/newgrp note.

- `virtualization/kvm.sh`
  - Target module: none.
  - Packages: none for now.
  - Instructions:
    - Do not migrate KVM for now.

- `virtualization/hashicorp.sh`
  - Target module: none.
  - Packages: none for now.
  - Instructions:
    - Do not migrate HashiCorp/Vagrant tooling for now.
    - Do not preserve arbitrary `hashicorp_packages` env expansion in frontmatter.

- `virtualization/virtualbox.sh`
  - Target module: `virtualbox`.
  - Packages: none for now.
  - Instructions:
    - Migrated as `level: extra`.
    - Keep host installation guarded by `systemd-detect-virt` and `PROVISION_VIRTUALBOX_HOST=1`.
    - Keep extension pack installation separate behind `PROVISION_VIRTUALBOX_EXTPACK=1`.
    - Oracle Guest Additions path is skipped; add a separate guarded section later only if still needed.

## Decisions

1. Existing focused modules own matching provisioning items. Meta modules must not absorb items that already belong to a
   focused module.
2. `bash`, `ruby`, `python`, and `javascript` are normal language baselines. Other language modules are `level: extra`
   for now.
3. Linux GUI applications should prefer Flatpak for now. Future cask policy can be decided separately.
4. Keep Linux system instructions in `linux/README.md` for now. Avoid module-local `bin/*` helpers until the module file
   layout semantics are revisited.
5. Dropbox installation is not managed by normal provisioning. Treat it as a separate bootstrap problem for
   Dropbox-backed hosts.
6. Do not migrate language server installation; Neovim/LazyVim Mason owns language servers.
7. Avoid broad system-wide development tool installs. Prefer project-local managers such as Bundler, uv, npm/Bun, and
   project manifests.
8. Do not add a `development` meta module.
9. Keep `shellcheck` in the existing `bash` module.
10. Ignore Debian packaging and broad Debian development provisioning scripts for now.
11. Bootstrap is a provision skill helper, not a repository module. `_` is now available as the first normal module for
    small shared declarations that do not deserve a focused module.
12. Do not create a `virtualization` root module. Keep Docker as an explicit extra/manual Linux system section in
    `linux-`; keep VirtualBox as its own guarded `level: extra` module; defer KVM and HashiCorp migration.
13. Do not create `terminal` or `desktop` root meta modules. Use `_` for small shared user tools, `linux` for Linux GUI
    and system integration, and focused modules whenever an item has clear identity or configuration.
14. Use dash-suffixed module variants case-by-case. `linux` is the minimal platform baseline; `linux-` is the extra
    Linux system/desktop/manual provisioning variant and runs immediately after `linux`.

## Open Questions

1. How should Linux-heavy sections be represented if single-level root modules keep feeling too flat?
2. Should Linux system sections eventually move to a different non-linkable helper location, and what should that
   location be if `bin/*` remains reserved for target assets?

## Next Step

Migrate in small groups:

1. Existing modules with straightforward package additions.
2. `_` shared-tool additions.
3. Linux system sections.
4. Language toolchains.
5. Deferred Linux GUI and virtualization sections.

## Handoff

First migration pass has been reviewed. Package names were checked against the active plan using Homebrew Formulae JSON
API catalogs, Flathub remote metadata, npm registry metadata, RubyGems metadata, PyPI metadata, Debian/Ubuntu package
references, and the GitHub release package assumption for `github:mweirauch/dropignore`.

Review fixes:

- `javascript` now uses `brew:oven-sh/bun/bun`, because Bun is installed through the official `oven-sh/bun` Homebrew
  tap rather than Homebrew core.
- `alacritty` no longer declares a package. The Homebrew cask is macOS-only and deprecated, and no current Flathub app
  was found during this pass.
- `ghostty` now declares `cask:ghostty` only under `macos`, because the Homebrew cask is macOS-only.
- `vscode` now declares `cask:visual-studio-code` only under `macos`. Linux installation remains undecided because the
  current config and extension flow targets native VS Code paths and CLI behavior, while Flathub uses a different
  application sandbox.

Remaining open design question: decide later how to represent Linux-heavy sections if `linux/README.md` becomes too
large or too hard to review.

## Progress

### 2026-05-19

- Migrated first package batch into existing focused modules:
  - `bash`: added `shellcheck`.
  - `git`: added `lazygit` and `tig`.
- Replaced the old `wezterm` module with a minimal `ghostty` module that installs `cask:ghostty`.
- Added `_` shared-tool packages: `fastfetch`, `fd`, `gnu-units`, `htop`, `libqalculate`, `moreutils`, `ncdu`,
  `rclone`, `slides`, `socat`, `telnet`, `tree`, `ttyd`, `yazi`, `zip`, and `zoxide`.
- Added normal language modules: `javascript`, `python`, and `ruby`.
- Added extra language module: `go`, including `gofumpt`.
- Added guarded `linux` sections for apt policy, locale, and timezone.
- Added guarded Linux sections and focused modules for SSH/sudo tweaks, UFW, Docker, desktop apt packages, user
  Flatpak apps, font packages, laptop tools, printer support, NetworkManager OpenVPN integration, VM cleanup, and GNOME
  settings.
- Canceled deferred ambiguous packages and tools for now: `crush`, `git-cc`, `caddy`/`xcaddy`, Vifm archive helpers,
  Neomutt extras, KVM, HashiCorp, `regexxer`, and `ulauncher`.
- Reviewed package declarations and platform-gated macOS-only casks out of the Linux plan.

Validation:

- `.agents/skills/provision/bin/plan --allow-dirty --platform linux --host smoke --format markdown`
- `.agents/tests/provision/smoke.sh`
- `shellcheck .agents/skills/provision/bin/bootstrap .agents/skills/provision/bin/smoke .agents/tests/provision/smoke.sh _/bin/search _/todo/actions/edit _/todo/actions/note _/todo/actions/projectview _/todo/actions/revive _/todo/actions/wtf _/todo/actions/xp bin/bin/ramake javascript/bin/biome-kludge`
- `RUBOCOP_SERVER=false RUBOCOP_CACHE_ROOT=/tmp/rubocop-cache rubocop --cache false --config .agents/tests/provision/rubocop.yml .agents/skills/provision/bin/plan`
- `git diff --check`

All checks passed.
