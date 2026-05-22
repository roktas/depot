# Depot

Dotfiles and provisioning repository.

The durable design lives in `.agents/specs/depot/spec.md`. The repo-local provisioning skill lives in
`.agents/skills/provision/`, and the plan helper is `.agents/skills/provision/bin/plan`.

Fresh hosts may need the bootstrap helper before normal provisioning:

```bash
.agents/skills/provision/bin/bootstrap
```

Preview the provisioning plan:

```bash
.agents/skills/provision/bin/plan --format markdown
```

`misc` is a normal provisioning module for small shared declarations without a focused module. Platform modules such as
`linux` run first; platform dash variants such as `linux-` run immediately after their base platform module. Other root
modules, including `misc`, then run alphabetically.
