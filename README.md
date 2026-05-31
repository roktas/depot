# Tilde

Dotfiles, home provisioning, and workspace management repository.

Tilde is operated primarily through the Tilde agent skill. It is more than a dotfiles provisioning repo: it gives an
agent a bounded way to install tools, create managed links, inspect drift, adopt app configuration, and maintain the
user's home directory as a working environment.

Mutating work is proposal-first. The agent should describe the target, effect, and blast radius before applying anything
that writes files, changes packages, moves home content, or touches a remote host.

## Quick Start

Use an agent session with the Tilde skill enabled. The normal workflow is to make this repository available on the target
machine, preview or request deployment, then continue day-to-day work from `~`.

For a personal machine with Dropbox, install and link Dropbox first, let this repository sync, then ask the agent:

```text
$tilde deploy this machine after Dropbox is synced
```

For a VPS, headless host, or any machine without Dropbox, clone the repository and deploy it as a Git-backed host:

```bash
git clone https://github.com/roktas/tilde.git ~/src/tilde
cd ~/src/tilde
```

```text
$tilde deploy this VPS as a git host
```

For a fresh or underprovisioned host, bootstrap may be needed before normal deployment:

```bash
.agents/skills/tilde/bin/bootstrap
```

When `https://tilde.roktas.dev` exists, the preferred public bootstrap transport will be:

```bash
curl -fsSL https://tilde.roktas.dev/bootstrap | bash
```

Preview the provisioning plan without applying changes:

```bash
.agents/skills/tilde/bin/plan --format markdown
```

The plan helper is read-only. It does not apply links, copies, package installs, or special README sections.

## Prompt Usage

Tilde commands are prompt contracts, not a strict shell CLI. The general format is
`$tilde <command> [<arguments>...]`. The command name is stable; the subject and qualifiers may be natural language.

| Command | Action |
| --- | --- |
| `adopt` | Adopt an app, config, package, or path into public `tilde` or private `tilde-`. |
| `archive` | Move selected home content into an archive according to private policy. |
| `apply` | Apply the lower-level provisioning plan after confirmation. |
| `bootstrap` | Run or guide the fresh-host bootstrap prelude. |
| `clean` | Propose conservative cleanup for selected home content. |
| `dedupe` | Find and propose handling for duplicate selected home content. |
| `deploy` | Prepare a local or remote host and apply desired state. |
| `doctor` | Diagnose deployment, repository, host, router, and managed-link health. |
| `help` | Show all commands or detailed help for one command. |
| `links` | Inspect managed links and copies. |
| `organize` | Propose organization changes for selected home content. |
| `plan` | Show the lower-level provisioning plan without applying it. |
| `refresh` | Update managed external resources only. |
| `repair` | Retry failed deployment modules at the recorded state. |
| `status` | Show a short read-only deployment and home-router summary. |
| `update` | Reconcile desired state, then refresh managed external resources. |
| `upgrade` | Run broad package-manager upgrades after explicit confirmation. |

- Detailed command help: `$tilde help <command>`
- Bare `$tilde` means `update`.

Examples:

```text
$tilde
$tilde help
$tilde help update
$tilde update
$tilde status
$tilde doctor
$tilde plan
$tilde apply
$tilde refresh managed packages
$tilde repair this host
$tilde upgrade managed packages
$tilde deploy this VPS over SSH as a git host
$tilde deploy the new laptop over SSH after Dropbox is synced
$tilde bootstrap this headless VPS
$tilde adopt neovim
$tilde adopt ~/.config/foo into private policy
$tilde links
$tilde organize downloads
$tilde archive old project exports
$tilde clean old screenshots
$tilde dedupe downloaded PDFs
```

Provisioning commands work from repository state. Home-management commands work from `~` after deployment.
Preference-sensitive commands such as `clean`, `organize`, `archive`, and `dedupe` should read private policy from
`tilde-/AGENTS.md` when it exists; otherwise they stay conservative and propose changes rather than inferring personal
cleanup rules.

## Working From Home

After deployment, `~/AGENTS.md` is a small managed entrypoint for agents working in the home directory. It lets the agent
find the canonical Tilde repository and optional private companion repository without recursively scanning `~`.

This means normal follow-up work can start from the home directory:

```text
$tilde status
$tilde links
$tilde adopt alacritty
$tilde organize downloads
```

Private home layout, cleanup, archive, and organization preferences do not belong in this public repository. Put them in
`tilde-/AGENTS.md` when a private companion repo exists.

## Repository Structure

- Durable behavior spec: `.agents/skills/tilde/references/spec.md`
- Tilde skill: `.agents/skills/tilde/SKILL.md`
- Home entrypoint template: `.agents/skills/tilde/assets/AGENTS.md`
- Repository development notes: `.agents/skills/tilde/references/development.md`
- Plan helper: `.agents/skills/tilde/bin/plan`
- Bootstrap helper: `.agents/skills/tilde/bin/bootstrap`

Root directories are provisioning modules when they contain `README.md`. Module frontmatter declares `links`, `copies`,
and `packages`; README body sections may declare platform or lifecycle commands. Platform modules such as `linux` run
first, platform dash variants such as `linux-` run immediately after their base platform module, and other root modules
run alphabetically.

`misc` is a normal provisioning module for small shared declarations without a focused module.
