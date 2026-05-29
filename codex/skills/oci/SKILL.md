---
name: oci
description: Use when working with Oracle Cloud Infrastructure via the OCI CLI, especially for session auth, budgets, quotas, networking, and compute operations. Read workspace AGENTS.md, if present, for workspace-specific tenancy and VPS state.
metadata:
  author: https://github.com/roktas
  version: "1.0.0"
---

# OCI

Use this skill for OCI CLI work. Read workspace `AGENTS.md`, if present, for tenancy and VPS state.

- Prefer read-only inspection before mutation.
- Confirm profile, region, compartment, and OCID before write operations.
- Do not stop, delete, or resize resources unless explicitly requested.
- For auth issues, validate the session before inferring resource state.
- Use JSON output for parsed data and summarize only relevant fields.
- Cite the command result or exact field behind conclusions about limits, budgets, networking, or compute.
