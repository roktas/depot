---
name: provision
description: Use in this repository to plan and perform Home-style dotfiles provisioning from `.agents/specs/home/spec.md`, including module discovery, README frontmatter interpretation, host/platform filtering, state-aware planning, package/link/copy actions, and confirmation-gated application.
---

# Provision

Use this repo-local skill for provisioning this `home` repository. Treat `.agents/specs/home/spec.md` as the canonical behavior specification.

## Workflow

1. Read `.agents/specs/home/spec.md` when the user asks to provision, change provisioning behavior, or inspect the design.
2. Ensure the worktree is clean before real local or `remote-git` provisioning. For `remote-git`, ensure the target
   commit is pushed.
3. Generate a non-destructive plan with `bin/plan`.
4. Present the plan and ask for confirmation unless the user already gave bulk approval for this provisioning run.
5. Apply the confirmed actions manually with normal tools. The helper does not apply changes.
6. Update `.agents/state/hosts/HOST/home.md` in the repo copy where actions were applied. For remote provisioning
   without Dropbox sync, copy that host state back into the local repo state archive before finishing.

## Remote Modes

- `remote-git`: default remote mode. Prepare the target repo with `git clone` or fetch/checkout, usually under
  `~/.local/src/<repo-name>`. Use the cloned repository's own name; do not force the directory name to `home`. Use
  `main` and the latest pushed commit unless instructed otherwise. Require a clean local worktree and pushed commit.
- `remote-dropbox`: use the target repo already present under Dropbox. Do not require local and remote Git HEADs to
  match. State is expected to sync through Dropbox, so no explicit state copy-back is needed.
- `remote-any`: use the target repo path as-is. This mode is intentionally less deterministic; call out dirty worktree,
  branch, or HEAD uncertainty and continue only with explicit confirmation.

In all remote modes, resolve links and copies against the target machine's repo copy, not the local orchestrating repo.
Write state on the target first. If the target is not Dropbox-synced, fetch the resulting
`.agents/state/hosts/HOST/home.md` back into the local repo at the end.

## Helper

Run from the repo root:

```bash
.agents/skills/provision/bin/plan
```

Useful options:

```bash
.agents/skills/provision/bin/plan --host kant --platform linux
.agents/skills/provision/bin/plan --level minimal
.agents/skills/provision/bin/plan --level extra
.agents/skills/provision/bin/plan --mode refresh
.agents/skills/provision/bin/plan --mode repair
.agents/skills/provision/bin/plan --format markdown
.agents/skills/provision/bin/plan --allow-dirty
```

Use `--allow-dirty` only while developing or reviewing the skill. Real provisioning must use a clean worktree.

## Development And Test Environments

For Lima/Liman setup and smoke-test commands, read `references/testing.md`.

`bin/smoke` uses the external Liman `"there"` command when running end-to-end tests. Keep this dependency loose:
`"there"` must be discoverable through `PATH`, but this skill must not assume how it was installed or provided. Use
Liman's own documentation for detailed `"there"` usage.

## Bootstrap

Use `bin/bootstrap` from this skill when a fresh target host does not yet have the minimum tools needed for
provisioning. Bootstrap is an explicit, state-free prelude step and is not a repository module. It must be idempotent,
must be Bash, and must not require Ruby. It installs the platform package-manager baseline, Homebrew, and the `curl`,
`git`, and `ruby` tools needed by the rest of this repository.

## Modes

- `apply`: apply this repo's desired state to the target host. This is the default mode and covers first provisioning
  plus normal state/HEAD-based reconciliation.
- `refresh`: update only managed external resources: active plan packages and README `Update` sections. Do not skip
  solely because the repo `HEAD` is unchanged.
- `repair`: retry modules marked `notok` in state at the same `HEAD`.
- `upgrade`: perform broad package-manager upgrades only when explicitly requested. Describe the larger blast radius
  before asking for confirmation.

## Application Rules

- README frontmatter may be omitted when a module has no explicit provisioning config; missing `all` and platform keys
  are treated as empty maps by `bin/plan`.
- `misc` is a normal provisioning module for small shared declarations that do not deserve a focused module. Keep it
  small; if an item grows configuration, platform-specific behavior, or a clear identity, move it to a focused module.
  `misc` has no special ordering and runs alphabetically with other non-platform root modules. If `misc-` exists, treat
  it as an `extra` variant.
- Plan module work in this order: active platform root module (`linux`, `macos`, or `windows`) first when present, the
  active platform dash variant (`linux-`, `macos-`, or `windows-`) after that when present, then other root modules
  alphabetically. Exclude inactive platform root modules and inactive platform variants.
- Dash-suffixed module names such as `linux-` are ordinary modules. The suffix has no global meaning; each pair defines
  its own local variant semantics in README text.
- Root modules that define platform keys but do not define `all` are selected only when the active platform key exists.
  This gates both frontmatter actions and special README sections. A platform key may use YAML null (`macos: ~`) to
  select that platform without adding platform-specific actions.
- `level` is optional and defaults to `normal`. Valid levels are `minimal`, `normal`, and `extra`; plan selection is a
  threshold, so `normal` includes `minimal` and `normal`, while `extra` includes all three levels.
- Link and copy sources are resolved relative to the module directory; `../` may reference shared files elsewhere in
  this repo, but sources must not escape the repository.
- A `links` target may be either one string or a list of strings. Use a list when the same source must be linked to
  multiple targets.
- Link sources ending with `/` use fan-in semantics: link each direct child of the source directory into the target
  directory with the same basename, rather than linking the source directory itself.
- `packages` must be a flat YAML list of `[package-type:]package-name` strings. Do not nest package types as mapping
  keys; use `gemini-cli` or `brew:gemini-cli`, not `brew: [gemini-cli]`.
- Treat `packages` as plan-time declarations. If package installation depends on runtime state such as GUI/session
  availability, keep it out of `packages` and put a guarded command in a special README section instead.
- Install GUI- or desktop-session-dependent packages only through guarded special-section commands, not through
  frontmatter `packages`.
- Missing `packages` means the module is virtual and installs no packages. Add package names explicitly for modules that
  should install packages.
- Do not remove packages unless the user explicitly asks for package removal.
- Link overwrites, copy overwrites, and link removals are confirmation-scoped actions.
- Remove a dropped link only if the target is a symlink into this repo, or if it is a dangling symlink.
- Do not touch dropped link targets that are not symlinks or point outside this repo.
- Do not remove dropped copy targets unless the user explicitly asks for copy removal.
- If a special README section contains only `bash` fenced blocks, run them in written order after confirmation.
- Special README sections may contain lower-level headings such as `### GNOME`; keep those as instructions inside the
  selected section rather than adding new special-section semantics.
- README bodies may scope special sections under `## All Platforms`, `## Linux`, `## MacOS`, or `## Windows`. Within
  those scopes, write special sections one level lower, such as `### Install`. Select `All Platforms` and the active
  platform only; ignore other platform scopes. Top-level special sections such as `## Install` remain valid and are
  treated like all-platform instructions.
- Special sections have plain exit-code semantics: `0` is success or intentional no-op; non-zero is failure. Do not use
  custom skip exit codes, fenced-block metadata, or a separate precondition protocol.

## Package Installation

Group package installs by package type, present the commands in the plan, and run them only after confirmation. Package
removal is never inferred from removed frontmatter entries.

Use these installation commands:

- `brew:<name>`: `brew install <name>`
- `cask:<name>`: `brew install --cask <name>`
- `deb:<name>`: `sudo apt install -y <name>`; run `sudo apt update` first when the package index may be stale. If this
  becomes a non-interactive script, prefer `sudo apt-get install -y <name>`.
- `npm:<name>`: `bun install -g <name>`
- `gem:<name>`: `gem install --user-install --no-document <name>` unless local RubyGems config already routes installs
  to a user-writable gem home. Do not use `sudo gem install`.
- `egg:<name>`: `uv tool install <name>` for Python CLI tools. If the package does not expose the expected executable,
  inspect the package documentation and use a module README special section for package-specific flags such as
  `--with` or `--with-executables-from`.
- `flatpak:<app-id>`: `flatpak install --user flathub <app-id>` unless the module explicitly requires a system-wide
  Flatpak install.
- `scoop:<name>`: `scoop install <name>`
- `github:<owner>/<repo>`: no fixed shell command. Inspect the latest release assets with the GitHub API, GitHub MCP, or
  `gh release` commands. Select the asset that best matches the target platform and architecture, download it to a temp
  directory, verify checksum or provenance when the release provides it, extract it, and copy executable files to
  `~/.local/bin`. If the correct asset or executable layout is ambiguous, ask before installing.

For `github` assets, prefer official release metadata over scraping HTML. Useful `gh` commands:

```bash
gh release view --repo OWNER/REPO --json tagName,assets
gh release download --repo OWNER/REPO --pattern 'PATTERN'
```

## Package Updates

Default update scope is **managed packages only**: update only package entries present in the active provisioning plan,
one package at a time or grouped by explicit package names. Do not run package-manager-wide upgrade commands unless the
user explicitly asks for a full/global update. This keeps provisioning from changing unrelated packages that happen to
be installed on the machine.

Before managed updates, run metadata refresh commands at most once per package manager represented in the confirmed
update set. Do this as a preflight step, before per-package update commands:

- `brew update`
- `sudo apt update`
- `scoop update`
- `flatpak update --appstream`

Use these managed-package update commands:

- `brew:<name>`: `brew upgrade <name>`
- `cask:<name>`: `brew upgrade --cask <name>`. If the cask is excluded from normal upgrades because it uses
  `version :latest` or self-updates, use `brew upgrade --cask --greedy <name>` only after calling out that extra scope.
- `deb:<name>`: `sudo apt-get install --only-upgrade -y <name>` after `sudo apt update`. If the package may not be
  installed yet, treat it as an install action instead.
- `npm:<name>`: `bun update -g <name>`
- `gem:<name>`: `gem update --user-install --no-document <name>`. Do not use bare `gem update`, because it updates all
  installed gems.
- `egg:<name>`: `uv tool upgrade <name>`. Use `uv tool install <name>` instead when changing version constraints or
  installation flags.
- `flatpak:<app-id>`: `flatpak update --user <app-id>` for per-user installs created by this skill.
- `scoop:<name>`: run `scoop update` first to refresh Scoop and buckets, then `scoop update <name>`.
- `github:<owner>/<repo>`: inspect the latest release assets again, compare with the currently installed binary when
  possible, then download, verify, extract, and replace executables in `~/.local/bin` after confirmation. If the release
  does not expose a reliable version signal, present the selected asset and ask before replacing.

Only use global update commands for an explicit full-update request, and describe the broader blast radius first:

```bash
brew upgrade
brew upgrade --cask
sudo apt upgrade
bun update -g
gem update
uv tool upgrade --all
flatpak update
scoop update *
```
