# Local Hierarchy

Load this reference when deciding where a project lifecycle side file belongs under `.local/`.

## Common Areas

| Path | Typical role |
| --- | --- |
| `README.md` | Optional index, notes, and local TODOs |
| `root/` | Canonical files projected at the project root |
| `bin/` | Directly invoked project-local commands |
| `doc/` | Local, private, immature, or subjective documentation |
| `etc/` | Static local configuration |
| `src/` | Experiments and unpublished source |
| `var/` | Generated, reinstallable, tool-managed, or environment-dependent data |
| `tmp/` | Disposable data whose only copy has no value |
| `lib/` | Optional helpers, templates, resources, or data shared by local consumers |
| `home/` | Optional persistent files with no clearer role |

These names are a shared vocabulary, not an exhaustive list. Use only the areas a project needs. Prefer a
project-specific name when it communicates a genuine role that the common areas do not.

## Placement

Choose by consumer and lifecycle:

- Put a directly invoked file in `bin/`.
- Put private implementation shared by local commands in `lib/`; put experiments or unpublished source in `src/`.
- Put durable prose in `doc/` when it does not belong in the main project.
- Put static tool or workspace configuration in `etc/`.
- Put rebuildable, downloaded, generated, or environment-dependent data under `var/<producer>/`.
- Put immediately disposable output in `tmp/`.
- Use `home/` only as a persistent fallback when a clearer role would be misleading.

Files under `root/`, `bin/`, `doc/`, `etc/`, `src/`, `lib/`, and `home/` are usually durable enough to consider for
versioning. Files under `var/` and `tmp/` are usually ignored. A project may choose differently for a specific subtree.

## README

Use `.local/README.md` when durable local content needs an entrypoint. Plain Markdown is enough. It may contain:

- a short explanation of why the local tree exists;
- links to important local files;
- working notes;
- a small local TODO list.

Do not require metadata or frontmatter. A tree containing only obvious generated or disposable data normally does not
need a README.

## Root Projections

Use `.local/root/` when a consumer requires a project-root name but the canonical content should remain local or
separately owned. Treat each direct child as one projection unit:

```text
.local/root/
├── AGENTS.md
└── .agents/

AGENTS.md -> .local/root/AGENTS.md
.agents   -> .local/root/.agents
```

Prefer relative symbolic links so the working tree remains movable. Projection does not imply that `.local/` is a Git
repository, and a separate Git repository does not imply a remote.

Before replacing an existing root path, inspect whether it is tracked, modified, ignored, or already a link. Moving a
tracked path changes its publication boundary and needs explicit user intent.
