---
name: oci
description: Use when working with Oracle Cloud Infrastructure via the OCI CLI, especially for session auth, budgets, quotas, networking, and compute operations. Read workspace AGENTS.md, if present, for workspace-specific tenancy and VPS state.
---

# OCI

Use this skill for Oracle Cloud Infrastructure CLI work. Read workspace `AGENTS.md`, if present, for tenancy, region,
compartment, VPS, or other workspace-specific state. Read `references/official-docs.md` only when exact Oracle docs or
command references matter. For pricing, Free Tier eligibility, service limits, quota semantics, or destructive
recovery, verify the current official documentation instead of relying on remembered values.

## Default Pattern

Inspect the configured profiles without exposing keys or token contents. Use the authentication method established by
the workspace. For a session-token profile, make config, profile, and auth explicit:

```text
oci <command> --config-file ~/.oci/config --profile SESSION --auth security_token
```

Validate auth before inferring resource state:

```bash
oci session validate --config-file ~/.oci/config --profile SESSION --auth security_token
```

Validation checks the token before a resource query; it does not prove the selected tenancy, region, or compartment is
the intended target. Refresh only when the session is invalid or near expiry and the established authentication flow
permits it:

```bash
oci session refresh --config-file ~/.oci/config --profile SESSION --auth security_token
```

If refresh is unavailable or unsuccessful, use `oci session authenticate ... --no-browser`, ask the user to open the
printed URL and finish login, then return to the terminal flow. Never paste a token, private key, full config, or signed
request into chat or tracked files.

## Working Rules

- Prefer read-only inspection before mutation.
- Before a write, resolve and report the profile, tenancy, region, compartment, exact resource OCID, current lifecycle
  state, requested end state, and cost or connectivity consequence that can be known.
- Treat terminate, delete, detach, boot-volume replacement, resize, route-table changes, security-list changes, public
  IP changes, and quota changes as destructive or service-affecting. Execute them only when the user's request clearly
  authorizes that exact target and effect; otherwise stop with the resolved command and ask for approval.
- Use JSON output for parsed data; prefer `--query ... --raw-output` for narrow extraction.
- Prefer generated JSON input plus `file://...` over long inline JSON.
- Prefer `--wait-for-state` when the command supports it.
- Use an idempotency or retry token when the operation supports one. After a timeout or dropped connection, inspect the
  resource and work request before retrying a create, launch, or other non-idempotent mutation.
- Base conclusions about limits, budgets, networking, compute, and billing on the exact returned field or current
  official documentation. Distinguish configured limits from current usage and available capacity.
- If a networked OCI call hangs in a sandboxed agent environment, consider sandbox or network restrictions before
  treating it as an auth problem.

## Operational Notes

- Budgets are soft limits; they alert and do not stop resources. Quotas are the main creation and scale guardrail.
- Never infer that a resource is free from its shape name or account type alone. Verify the current tenancy, home region,
  eligibility label, quantity, and usage against current Oracle documentation before describing it as no-cost.
- For instance launch work, check the installed CLI's supported flags.
- For a relaunch across immutable network identity boundaries, first verify the boot-volume OCID, preservation setting,
  attachment state, network consequences, and rollback limits. Do not terminate the old instance until the user has
  explicitly approved that exact instance and the verified replacement plan.
- Capacity can be transient for some shapes and availability domains. Before trying another availability domain,
  verify that the previous launch did not succeed asynchronously and that the requested identity and placement allow a
  different domain.
