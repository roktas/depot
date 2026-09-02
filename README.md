# Home

Public home data for a Tilde-managed workspace.

This repository contains dotfiles, provisioning modules, and package declarations. Public user-wide agent instructions
and reusable agent skills live in the sibling Ajans repository and are consumed by the `agents` module. The Tilde
control plane lives in the installed `tilde` skill, normally at `~/.agents/skills/tilde`, and is developed in the sibling
`tilde` repository.

The private companion repository is conventionally named `home-`.
Deployment state is local runtime data under `~/.local/state/tilde`; it is not stored in this repository.

## Usage

Use an agent session with the Tilde skill enabled:

```text
/tilde status
/tilde doctor
/tilde deploy dry-run
/tilde deploy
/tilde update
```

These are agent prompt examples, not shell commands.

When a shell runtime helper is needed, use the loaded Tilde skill's `bin/tilde` or
`~/.agents/skills/tilde/bin/tilde`; do not rely on bare `tilde` being on `PATH`.

Mutating work is proposal-first. The agent should describe the target, effect, and blast radius before applying anything
that writes files, changes packages, moves home content, or touches a remote host.

## Repository Structure

Root directories are provisioning modules when they contain `README.md`. Module frontmatter declares `links`, `copies`,
and `packages`; README body sections may declare platform or lifecycle commands.

Platform-specific commands use platform headings with lifecycle sections nested below them:

```text
## Linux
### Install

## MacOS
### Configure
```

Do not add placeholder frontmatter just to make a platform-scoped section run.

- `agents/`: deployment module for the shared `~/.agents` surface and external agent packages.
- `linux/`, `macos/`, `windows/`: platform modules.
- `linux-`, `macos-`, `windows-`: private or extra platform variants when present.

The `agents` module includes the local Tilde skill link for this maintainer deployment.
