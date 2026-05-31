# Agent Development Guide

A file for [guiding coding agents](https://agents.md/). This file applies to the whole repository unless a nested
`AGENTS.md` overrides it.

Tilde is a public dotfiles, home provisioning, and workspace management repository operated through agent prompts, with
deterministic helpers for bootstrap, planning, validation, and the core home router link.

## Tilde Development

- Use the Tilde skill for deployment, provisioning, bootstrapping, repair, status, diagnostics, link inspection,
  adoption, and home-management behavior.
- Read `.agents/skills/tilde/SKILL.md` before Tilde work; it links to the canonical spec and supporting references.
- Read `.agents/skills/tilde/references/development.md` before editing provisioning behavior, skills, helper scripts,
  module metadata, or validation docs.
- Keep this file as repository-local instructions.
