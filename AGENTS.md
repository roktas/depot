---
tilde:
  protocol: tilde/v1
  role: public
  private: ../home-
---

# Agent Development Guide

A file for [guiding coding agents](https://agents.md/). This file applies to the whole repository unless a nested
`AGENTS.md` overrides it.

This is the public home data repository for Tilde-managed dotfiles, provisioning modules, and workspace configuration.
The Tilde control plane is installed separately as the `tilde` skill, normally at `~/.agents/skills/tilde`.

## Home Development

- Use the Tilde skill for deployment, provisioning, bootstrapping, repair, status, diagnostics, link inspection,
  adoption, and home-management behavior.
- Read `~/.agents/skills/tilde/SKILL.md` before Tilde work; it links to the canonical spec and supporting references.
- Read `~/.agents/skills/tilde/references/spec.md` before changing module frontmatter or provisioning semantics.
- Read `~/.agents/skills/tilde/references/development.md` before editing Tilde control-plane behavior, helper scripts,
  or validation docs.
- Deployment state belongs under `~/.local/state/tilde`, not in this repository.
- Keep this file as repository-local instructions.
