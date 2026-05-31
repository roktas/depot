# Home

Public home data for a Tilde-managed workspace.

This repository contains dotfiles, provisioning modules, package declarations, and shared agent assets. The Tilde
control plane lives in the installed `tilde` skill, normally at `~/.agents/skills/tilde`, and is developed in the sibling
`tilde` repository.

The private companion repository is conventionally named `home-`.
Deployment state is local runtime data under `~/.local/state/tilde`; it is not stored in this repository.

## Usage

Use an agent session with the Tilde skill enabled:

```text
$tilde status
$tilde links
$tilde plan
$tilde deploy
$tilde update
$tilde adopt neovim
```

Mutating work is proposal-first. The agent should describe the target, effect, and blast radius before applying anything
that writes files, changes packages, moves home content, or touches a remote host.

## Repository Structure

Root directories are provisioning modules when they contain `README.md`. Module frontmatter declares `links`, `copies`,
and `packages`; README body sections may declare platform or lifecycle commands.

- `agents/`: shared user-wide agent instructions and common skills exposed through `~/.agents`.
- `codex/`, `opencode/`: agent-specific modules.
- `linux/`, `macos/`, `windows/`: platform modules.
- `linux-`, `macos-`, `windows-`: private or extra platform variants when present.

The `agents` module includes the local Tilde skill link for this maintainer deployment.
