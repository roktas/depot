# Home

Home-style dotfiles and provisioning repository.

The durable design lives in `.agents/specs/home/spec.md`. The repo-local provisioning skill lives in
`.agents/skills/provision/`, and the plan helper is `.agents/skills/provision/bin/plan`.

Fresh hosts may need the state-free bootstrap helper before normal provisioning:

```bash
_/bin/bootstrap
```

Preview the provisioning plan:

```bash
.agents/skills/provision/bin/plan --format markdown
```

Support helpers live under `_` and are never recorded in provisioning state. Normal modules live at the repository root;
platform modules such as `linux` run before the other root modules.
