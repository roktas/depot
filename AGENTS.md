# Repository Instructions

## Scope

This repository is a Home-style dotfiles provisioning repo. Keep repository-facing code, comments, file names, commit
messages, and documentation in English.

## Canonical Design

- Durable provisioning spec: `.agents/specs/home/spec.md`
- Repo-local provisioning skill: `.agents/skills/provision/SKILL.md`
- Plan helper: `.agents/skills/provision/bin/plan`
- Bootstrap helper: `.agents/skills/provision/bin/bootstrap`
- Provisioning state: `.agents/state/hosts/HOST/home.md`
- Migration task notes: `.agents/tasks/2026-05-15-dotfiles-migration/`

Read the spec before changing provisioning behavior.

## Conventions

- Root modules must have `README.md`; YAML frontmatter is optional when a module has no explicit provisioning config.
- `_` is the first normal provisioning module. Use it only for small shared declarations that do not deserve a focused
  module.
- Run `.agents/skills/provision/bin/bootstrap` explicitly on fresh hosts before normal provisioning when base tools are
  missing.
- Platform root modules are named `linux`, `macos`, or `windows`. Dash variants such as `linux-` are ordinary variant
  modules and run immediately after the active platform module. Normal plans use `_` first, the active platform module
  next, the active platform dash variant next, then other root modules alphabetically.
- Root modules may be platform-gated by defining only the relevant platform key, for example `linux:` in a module
  README.
- Use `links` for symlink placement.
- Use `copies` for files or directories that target applications may overwrite.
- Omit `level` for normal modules. Use `level: minimal` for the smallest useful base and `level: extra` for optional
  additions.
- Omit `packages` for virtual modules. Add `packages` only when the module should install explicit packages.
- Prefer short contextual file, directory, and helper names. Avoid encoding implementation details in names unless
  they disambiguate real siblings or are part of an established external interface.
- Do not migrate old `install.sh` files by default. Prefer README frontmatter and special sections; keep a script only
  when it is an intentional module implementation detail.
- When searching for literal text that may contain shell metacharacters such as backticks, `$`, `!`, or quotes, do not
  put the pattern inside a double-quoted shell argument. Prefer `rg -F -e 'literal text'` or another form that prevents
  shell command substitution.

## Validation

Run relevant checks after provisioning skill or migrated module changes:

```bash
.agents/skills/provision/bin/plan --allow-dirty --platform linux --host smoke --format markdown
.agents/tests/provision/smoke.sh
RUBOCOP_SERVER=false RUBOCOP_CACHE_ROOT=/tmp/rubocop-cache rubocop --cache false --config .agents/tests/provision/rubocop.yml .agents/skills/provision/bin/plan
shellcheck .agents/skills/provision/bin/bootstrap .agents/skills/provision/bin/smoke .agents/tests/provision/smoke.sh _/bin/search _/todo/actions/edit _/todo/actions/note _/todo/actions/projectview _/todo/actions/revive _/todo/actions/wtf _/todo/actions/xp bin/bin/ramake javascript/bin/biome-kludge
```

Use Lima with the external `"there"` helper for end-to-end smoke tests. See
`.agents/skills/provision/references/testing.md`.

This repository's `.envrc` may put a neighboring Liman checkout ahead of the packaged `"there"` command. In
non-interactive tool shells, direnv may not be loaded automatically; use `direnv exec . COMMAND` when validating
commands that depend on `.envrc`.

Lima:

```bash
.agents/skills/provision/bin/smoke
.agents/skills/provision/bin/smoke boot
.agents/skills/provision/bin/smoke stop
```
