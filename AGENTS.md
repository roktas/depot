---
tilde:
  protocol: tilde/v1
  role: public
  private: ../home-
---

# Agent Development Guide

Scope: this file applies to agent work in this public data repository.

This repository contains public-safe desired state, modules, and shared agent assets for a Tilde-managed workspace.
The Tilde control plane is installed separately as the `tilde` skill, normally at `~/.agents/skills/tilde`.

## Tilde

- Use the Tilde skill for deployment, provisioning, bootstrapping, repair, status, diagnostics, and adoption.
- Read `~/.agents/skills/tilde/SKILL.md` before Tilde work; it links to the canonical spec and supporting references.
- Read `~/.agents/skills/tilde/references/specification.md` before changing module frontmatter or provisioning semantics.
- Read `~/.agents/skills/tilde/references/development.md` before editing Tilde control-plane behavior, helper scripts,
  or validation docs.
- Treat this repository as public-safe. Do not add secrets, credentials, host-specific private values, or private
  account metadata here.
- Deployment state belongs under `~/.local/state/tilde`, not in this repository.
- Target-home layout and preference policy belong in `~/AGENTS.md`, normally managed from the private data repository's
  `home/AGENTS.md`; use this repository's `home/AGENTS.md` only when no private data repository is configured.
