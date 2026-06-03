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

- Use the Tilde skill when changing public modules, provisioning metadata, repository identity, skill/package
  declarations, or repo-scoped Tilde workflows that involve this repository.
- Read `~/.agents/skills/tilde/SKILL.md` before Tilde work; it links to the canonical spec and supporting references.
- Read `~/.agents/skills/tilde/references/specification.md` before changing module frontmatter or provisioning semantics.
- Treat this repository as public-safe. Do not add secrets, credentials, host-specific private values, or private
  account metadata here.
- Deployment state belongs under `~/.local/state/tilde`, not in this repository.
- Keep this root `AGENTS.md` limited to public data repository identity and repository-scope instructions.
- Target-home layout, cleanup policy, organization policy, adoption policy, and Tilde operation refinements belong in
  `~/AGENTS.md`, normally managed from the private data repository's `home/AGENTS.md`; use this repository's
  `home/AGENTS.md` only when no private data repository is configured.
