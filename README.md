# Home

Home-style dotfiles and provisioning repository.

The durable design lives in `.agents/specs/home/spec.md`. The repo-local provisioning skill lives in
`.agents/skills/provision/`, and the plan helper is `.agents/skills/provision/bin/plan`.

Fresh hosts may need the bootstrap helper before normal provisioning:

```bash
.agents/skills/provision/bin/bootstrap
```

Preview the provisioning plan:

```bash
.agents/skills/provision/bin/plan --format markdown
```

`_` is the first normal provisioning module and is intended for small shared declarations without a focused module.
Platform modules such as `linux` run after `_`; platform dash variants such as `linux-` run immediately after their
base platform module.
