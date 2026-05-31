# Tilde

Dotfiles, home provisioning, and workspace management repository.

Tilde is operated primarily through the Tilde agent skill. It is not only a dotfiles provisioning repo: it also gives an
agent a bounded way to organize, inspect, adopt, and maintain the user's home directory as a working environment.

The helper scripts provide deterministic bootstrap and provisioning plans. The skill uses those helpers for desired
state work, and uses the spec for home-management workflows such as adopting app configuration into Tilde, inspecting
managed links, diagnosing drift, organizing selected home areas, and coordinating private policy from `tilde-`.

Mutating work is proposal-first. The agent should describe the target, effect, and blast radius before applying anything
that writes files, changes packages, moves home content, or touches a remote host.

## Prompt Usage

Tilde commands are prompt contracts, not a strict shell CLI. Use them in an agent session:

```text
$tilde status
$tilde doctor
$tilde plan
$tilde apply
$tilde refresh managed packages
$tilde deploy this VPS over SSH as a git host
$tilde deploy the new laptop over SSH after Dropbox is synced
$tilde adopt neovim
$tilde links
$tilde organize downloads
$tilde clean old screenshots
```

The command name is stable; the subject and qualifiers may be natural language. Mutating commands are proposal-first:
the agent should describe the target, effect, and blast radius before applying changes.

Provisioning commands work from repository state. Home-management commands work from `~` after deployment, using the
home router to find the canonical Tilde repo without recursively scanning the home directory. Preference-sensitive
commands such as `clean`, `organize`, `archive`, and `dedupe` should read private policy from `tilde-/AGENTS.md` when it
exists; otherwise they stay conservative and propose changes rather than inferring personal cleanup rules.

## Home Router

The canonical router template is `.agents/skills/tilde/assets/AGENTS.md`. Tilde deployment links it directly to
`~/AGENTS.md` as a core managed link, before normal modules. The router is intentionally short: it routes agents to the
canonical Tilde repository, the Tilde skill, and the optional private companion repository `tilde-`.

The router resolves the repository from the `~/AGENTS.md` symlink target chain. The normal target is
`.agents/skills/tilde/assets/AGENTS.md`; agents walk upward from that target until they find
`.agents/skills/tilde/SKILL.md` and `.agents/skills/tilde/references/spec.md`. This is a bounded ancestor walk, not a
home scan.

Private home layout and cleanup preferences do not belong in this public repository. Put them in `tilde-/AGENTS.md`
when a private companion repo exists.

## Bootstrap And Planning

Fresh hosts may need the bootstrap helper before normal provisioning:

```bash
.agents/skills/tilde/bin/bootstrap
```

When the future public site exists, the preferred public bootstrap transport will be:

```bash
curl -fsSL https://tilde.roktas.dev/bootstrap | bash
```

Preview the provisioning plan:

```bash
.agents/skills/tilde/bin/plan --format markdown
```

The plan helper is read-only. It does not apply links, copies, package installs, or special README sections.

## Repository Layout

- Durable design: `.agents/skills/tilde/references/spec.md`
- Discoverability alias: `.agents/specs/tilde.md`
- Tilde skill: `.agents/skills/tilde/SKILL.md`
- Home router template: `.agents/skills/tilde/assets/AGENTS.md`
- Repository development notes: `.agents/skills/tilde/references/development.md`
- Plan helper: `.agents/skills/tilde/bin/plan`
- Bootstrap helper: `.agents/skills/tilde/bin/bootstrap`

Root directories are provisioning modules when they contain `README.md`. Module frontmatter declares `links`, `copies`,
and `packages`; README body sections may declare platform or lifecycle commands. Platform modules such as `linux` run
first, platform dash variants such as `linux-` run immediately after their base platform module, and other root modules
run alphabetically.

`misc` is a normal provisioning module for small shared declarations without a focused module.
