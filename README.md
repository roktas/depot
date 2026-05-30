# Tilde

Dotfiles and provisioning repository.

The durable design lives in `.agents/specs/tilde/spec.md`. The repo-local Tilde skill lives in
`.agents/skills/tilde/`, and the plan helper is `.agents/skills/tilde/bin/plan`.

Fresh hosts may need the bootstrap helper before normal provisioning:

```bash
.agents/skills/tilde/bin/bootstrap
```

Preview the provisioning plan:

```bash
.agents/skills/tilde/bin/plan --format markdown
```

`misc` is a normal provisioning module for small shared declarations without a focused module. Platform modules such as
`linux` run first; platform dash variants such as `linux-` run immediately after their base platform module. Other root
modules, including `misc`, then run alphabetically.
