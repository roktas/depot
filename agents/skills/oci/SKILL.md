---
name: oci
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

# OCI

Use this skill for Oracle Cloud Infrastructure CLI work. Read workspace `AGENTS.md`, if present, for tenancy, region,
compartment, VPS, or other workspace-specific state. Read `references/official-docs.md` only when exact Oracle docs or
command references matter.

## Default Pattern

Use explicit config and session-token auth unless the workspace says otherwise:

```text
oci <command> --config-file ~/.oci/config --profile SESSION --auth security_token
```

Validate auth before inferring resource state:

```bash
oci session validate --config-file ~/.oci/config --profile SESSION
oci session refresh --config-file ~/.oci/config --profile SESSION
```

If refresh is not enough, use `oci session authenticate ... --no-browser`, ask the user to open the printed URL and
finish login, then return to the terminal flow.

## Working Rules

- Prefer read-only inspection before mutation.
- Confirm profile, region, compartment, and resource OCID/name before write operations.
- Treat terminate, delete, detach, resize, route, and security-list changes as destructive unless the user explicitly
  requested them.
- Use JSON output for parsed data; prefer `--query ... --raw-output` for narrow extraction.
- Prefer generated JSON input plus `file://...` over long inline JSON.
- Prefer `--wait-for-state` when the command supports it.
- Cite the command result or exact field behind conclusions about limits, budgets, networking, or compute.
- If a networked OCI call hangs in a sandboxed agent environment, consider sandbox or network restrictions before
  treating it as an auth problem.

## Operational Notes

- Budgets are soft limits; they alert and do not stop resources. Quotas are the main creation and scale guardrail.
- PAYG accounts still retain Always Free entitlements, but charges start when usage exceeds Always Free limits or paid
  resources are created.
- For instance launch work, check the installed CLI's supported flags.
- To relaunch across immutable network identity boundaries, preserve the boot volume, verify its OCID and preservation
  setting, terminate the old instance, then relaunch from `--source-boot-volume-id`.
- Capacity can be transient for some shapes and availability domains; retry across availability domains when
  appropriate.
