# Repository Instructions

## Scope

This repository is a Depot-style dotfiles provisioning repo.

## Canonical Design

- Durable provisioning spec: `.agents/specs/depot/spec.md`
- Repo-local Depot skill: `.agents/skills/depot/SKILL.md`
- Plan helper: `.agents/skills/depot/bin/plan`
- Bootstrap helper: `.agents/skills/depot/bin/bootstrap`
- Provisioning state: `.agents/state/hosts/HOST/depot.md`
- Agent resume checkpoint: `.agents/state/checkpoints/assistant.md`
- Shared notes and TODO inbox: `.agents/notes/todo.md`
- Local task state: `.agents/state/tasks/`

Read the spec before changing provisioning behavior.

## Session Drift

At session start, compare `.agents/state/checkpoints/assistant.md` with the current branch, `HEAD`, and worktree state when
the checkpoint exists. If `HEAD` or dirty state changed since the checkpoint, inspect the drift and summarize it before
editing. During this session-start drift check, reread any current canonical skill, spec, or instruction file before
applying conventions remembered from an earlier session; treat the repository version as authoritative. At session
closeout, refresh the checkpoint after any requested commits or pushes when practical.

## Conventions

- Root modules must have `README.md`; YAML frontmatter is optional when a module has no explicit provisioning config.
- `misc` is a normal provisioning module for small shared declarations that do not deserve a focused module. It has no
  special ordering and runs alphabetically with other non-platform root modules. If `misc-` exists, it must be `extra`.
- Run `.agents/skills/depot/bin/bootstrap` explicitly on fresh hosts before normal provisioning when base tools are
  missing.
- Platform root modules are named `linux`, `macos`, or `windows`. Dash variants such as `linux-` are ordinary variant
  modules and run immediately after the active platform module. Normal plans use the active platform module first, the
  active platform dash variant next, then other root modules alphabetically.
- Root modules may be platform-gated by defining only the relevant platform key, for example `linux:` in a module
  README.
- Use `links` for symlink placement.
- Use `copies` for files or directories that target applications may overwrite.
- Omit `level` for normal modules. Use `level: minimal` for the smallest useful base and `level: extra` for optional
  additions.
- Omit `packages` for virtual modules. Add `packages` only when the module should install explicit packages.
- Keep GUI- or desktop-host-dependent package installs out of frontmatter `packages`; use guarded special-section
  commands instead. For Linux package installs, prefer a desktop-host guard such as `systemctl get-default` equals
  `graphical.target`; reserve `DISPLAY`/`WAYLAND_DISPLAY` checks for active GUI session commands.
- Prefer short contextual file, directory, and helper names. Avoid encoding implementation details in names unless
  they disambiguate real siblings or are part of an established external interface.
- Keep `opencode/AGENTS.md` in sync with `agents/AGENTS.md`: whenever shared user instructions change, apply the same
  change there too. `opencode/AGENTS.md` is basically a standalone copy of `agents/AGENTS.md`, strengthened with stricter
  OpenCode-specific wording and mandatory skill-dispatch rules.
- Do not add absolute filesystem paths to tracked repository files, including module frontmatter, instructions, and
  scripts. Use repository-relative paths, module-relative paths, or home-relative provisioning targets such as
  `~/.config/foo` when needed.
- Do not migrate old `install.sh` files by default. Prefer README frontmatter and special sections; keep a script only
  when it is an intentional module implementation detail.
- When searching for literal text that may contain shell metacharacters such as backticks, `$`, `!`, or quotes, do not
  put the pattern inside a double-quoted shell argument. Prefer `rg -F -e 'literal text'` or another form that prevents
  shell command substitution.

## Validation

Run relevant checks after Depot skill or migrated module changes:

```bash
.agents/skills/depot/bin/plan --allow-dirty --platform linux --host smoke --format markdown
.agents/tests/provision/smoke.sh
RUBOCOP_SERVER=false RUBOCOP_CACHE_ROOT=/tmp/rubocop-cache rubocop --cache false --config .agents/tests/provision/rubocop.yml .agents/skills/depot/bin/plan
mapfile -t shell_files < <(rg --hidden -l '^#!.*(bash|sh)' -g '!**/.git/**' -g '!**/.agents/state/**')
shellcheck "${shell_files[@]}"
```

Use Lima with the external `"there"` helper for end-to-end smoke tests. See
`.agents/skills/depot/references/testing.md`.

This repository's `.envrc` may put a neighboring `there` checkout ahead of the packaged `"there"` command. In
non-interactive tool shells, direnv may not be loaded automatically; use `direnv exec . COMMAND` when validating
commands that depend on `.envrc`.

Lima:

```bash
.agents/skills/depot/bin/smoke
.agents/skills/depot/bin/smoke boot
.agents/skills/depot/bin/smoke stop
```
