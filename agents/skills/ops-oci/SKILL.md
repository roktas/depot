---
name: ops-oci
description: Use when working with Oracle Cloud Infrastructure via the OCI CLI, especially for session auth, budgets, quotas, networking, and compute operations. Read workspace AGENTS.md, if present, for workspace-specific tenancy and VPS state.
metadata:
  author: https://github.com/roktas
  version: "1.0.0"
  triggers: OCI, Oracle Cloud, Oracle Cloud Infrastructure, oci CLI, budget, quota, VCN, compute instance
  role: specialist
  scope: operations
  output-format: command-oriented
  related-skills: ~
---

# OCI Skill

Use this skill for OCI work in this workspace. Read workspace `AGENTS.md`, if present, for workspace-specific state. Read `references/official-docs.md` only when exact docs or command references matter.

## Default Pattern

- Use explicit config and session-token auth:

  ```bash
  oci <command> --config-file ~/.oci/config --profile SESSION --auth security_token
  ```

## Auth Workflow

- Validate, then refresh if needed:
  - `oci session validate --config-file ~/.oci/config --profile SESSION`
  - `oci session refresh --config-file ~/.oci/config --profile SESSION`
- If refresh is not enough, use `oci session authenticate ... --no-browser`, ask the user to open the printed URL and finish login, then return to the terminal flow.

## Working Rules

- Prefer official Oracle docs when syntax matters.
- Prefer `--query ... --raw-output` for narrow extraction.
- Prefer generated JSON input plus `file://...` over long inline JSON.
- Prefer `--wait-for-state` when the command supports it.
- If a networked OCI call hangs in a sandboxed agent environment, consider sandbox/network restrictions before treating it as an auth problem.

## Budgets and Quotas

- Budgets are soft limits; they alert and do not stop resources.
- Budget alert evaluation is periodic, not instant.
- Quotas are the main creation/scale guardrail.
- Quota changes can take time to propagate.

## Compute and Networking

- For instance launch work, check the installed CLI's supported flags.
- Treat terminate, delete, detach, and route/security-list changes as destructive operations. Before running them, confirm tenancy, region, compartment, resource OCID/name, and intended impact with the user.
- To cross immutable network identity boundaries:
  - preserve the boot volume
  - verify the boot volume OCID and termination setting that preserves the boot volume
  - terminate the old instance
  - relaunch from `--source-boot-volume-id`
- Expect transient capacity issues for some shapes and ADs; retry across availability domains when appropriate.

## Always Free / PAYG Caution

- PAYG accounts still retain Always Free entitlements.
- Charges start when usage exceeds Always Free limits or when paid resources are created.
- Cost control splits into:
  - monitoring: budgets
  - enforcement: quotas and resource design
