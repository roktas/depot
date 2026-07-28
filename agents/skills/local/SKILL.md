---
name: local
description: Organize project lifecycle side files under `.local/` and repository agent artifacts under `.agents/`. Use when deciding where local commands, notes, experiments, configuration, generated state, temporary files, agent instructions, skills, specs, tests, or agent runtime state should live; when separating private working material from published project content; or when reviewing an existing project-local layout.
---

# Local

Use a small shared vocabulary for files produced around a project during its lifetime. Adopt only the parts that help
the project; this is a placement convention, not a required tool or repository model.

Repository instructions and the user's current request take precedence.

## Purpose

Treat placement and incubation as the primary uses:

- place durable, generated, and disposable side files predictably;
- incubate experiments, notes, tools, or private work without forcing them into the main project;
- keep material outside the published project when disclosure or privacy boundaries require it;
- use ordinary version control when separate history is useful.

Local separation is not access control by itself. Version control, remotes, publication, and recovery policy remain
project choices.

## Surfaces

- Use `.local/` for project-related side files that do not naturally belong in the main project tree.
- Use root `AGENTS.md` and `.agents/` for repository agent instructions and artifacts. They may remain ordinary tracked
  project files; `.local/` is not required.
- Use `.local/root/` only when a root-visible file needs a different canonical home, such as privately maintained
  `AGENTS.md` or `.agents/` content projected into the working tree.

Load [hierarchy.md](references/hierarchy.md) when choosing a `.local/` area, reviewing durable versus generated content,
or projecting a root path. Load [agents.md](references/agents.md) for `AGENTS.md`, `.agents/`, agent state, and root
project documents.

## Workflow

1. Inspect existing repository instructions, ownership, ignore rules, and established tool paths.
2. Prefer an existing clear project convention over introducing `.local/` or `.agents/`.
3. Choose the narrowest role that accurately describes the file's consumer and lifecycle.
4. Keep durable material separate from generated state and disposable output.
5. Preserve existing ownership unless the user asks to move or privatize content. Explain a publication-boundary change
   before moving tracked project files outside the main repository.
6. After a move, update ordinary references and ignore rules that name the old path.

## Versioning

`.local/` may be an ordinary directory, an ignored tree, or a separate Git working tree. It does not require
`README.md`, `.git/`, frontmatter, a branch, or a remote.

When durable local content benefits from context, prefer a plain `.local/README.md` as a lightweight index for notes,
TODOs, and important paths. Omit it when it adds no value.

## Restraint

- Do not create `.local/` merely to hold agent runtime state.
- Do not treat the standard hierarchy as a whitelist; add a project-specific area when it communicates a real role
  better than the common names.
- Do not relocate project-owned `AGENTS.md` or `.agents/` merely because local side files exist.
- Do not automate Git, remote, publication, or projection changes as an implicit consequence of applying this
  convention.
