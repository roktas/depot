# Repository Instructions

## Scope

This repository is a Home-style dotfiles provisioning repo. Keep repository-facing code, comments, file names, commit
messages, and documentation in English.

## Canonical Design

- Durable provisioning spec: `.agents/specs/home/spec.md`
- Repo-local provisioning skill: `.agents/skills/provision/SKILL.md`
- Plan helper: `.agents/skills/provision/bin/plan`
- Provisioning state: `.agents/state/hosts/HOST/home.md`
- Migration task notes: `.agents/tasks/2026-05-15-dotfiles-migration/`

Read the spec before changing provisioning behavior.

## Conventions

- Root modules must have `README.md`; YAML frontmatter is optional when a module has no explicit provisioning config.
- `_` is reserved for state-free support helpers. Normal plans never include `_`; run `_/bin/bootstrap` explicitly on
  fresh hosts before normal provisioning.
- Platform root modules are named `linux`, `macos`, or `windows`. Normal plans use the active platform module first,
  then non-platform root modules alphabetically.
- Root modules may be platform-gated by defining only the relevant platform key, for example `linux:` in a module
  README.
- Use `links` for symlink placement.
- Use `copies` for files or directories that target applications may overwrite.
- Omit `level` for normal modules. Use `level: minimal` for the smallest useful base and `level: extra` for optional
  additions.
- Omit `packages` for virtual modules. Add `packages` only when the module should install explicit packages.
- Do not migrate old `install.sh` files by default. Prefer README frontmatter and special sections; keep a script only
  when it is an intentional module implementation detail.

## Validation

Run relevant checks after provisioning skill or migrated module changes:

```bash
.agents/skills/provision/bin/plan --allow-dirty --platform linux --host smoke --format markdown
.agents/tests/provision/smoke.sh
RUBOCOP_SERVER=false RUBOCOP_CACHE_ROOT=/tmp/rubocop-cache rubocop --cache false --config .agents/tests/provision/rubocop.yml .agents/skills/provision/bin/plan
shellcheck _/bin/bootstrap .agents/skills/provision/bin/lxd-smoke .agents/tests/provision/smoke.sh bin/bin/ramake biome/bin/biome-kludge bundle/bin/bundle-kludge fzf/bin/search todo/actions/edit todo/actions/note todo/actions/projectview todo/actions/revive todo/actions/wtf todo/actions/xp
```

Use container smoke tests when container runtimes are available. See
`.agents/skills/provision/references/test-environments.md` for Docker and LXD setup details.

Docker:

```bash
docker run --rm -v /home/roktas/Dropbox/src/home:/repo:ro home-provision-smoke
```

LXD Ubuntu smoke:

```bash
.agents/skills/provision/bin/lxd-smoke
.agents/skills/provision/bin/lxd-smoke --boot
```
