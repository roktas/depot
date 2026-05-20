# Test Environments

Use Lima for end-to-end provisioning tests.

## Lima

The `lima` module provides `lima/bin/here`, a project-local instance helper. It mounts the current directory writable at
`/here`, uses Ubuntu by default, and names instances from the selected image plus the current directory path hash.

Run the normal provision smoke script inside the Lima instance:

```bash
.agents/skills/provision/bin/smoke
```

Run the bootstrap helper inside the Lima instance:

```bash
.agents/skills/provision/bin/smoke boot
```

For fast repeated tests, stop the instance instead of destroying it:

```bash
.agents/skills/provision/bin/smoke stop
```

For a fresh-host test, destroy the instance explicitly:

```bash
.agents/skills/provision/bin/smoke destroy
```

Clean Lima's image cache only when explicitly requested:

```bash
.agents/skills/provision/bin/smoke prune
```

## Direct Helper

Use the helper directly when a test needs a custom command:

```bash
lima/bin/here run bash -lc 'cd /here && .agents/tests/provision/smoke.sh'
```

`lima/bin/here` supports:

- `auto`: create/start the project instance and enter a shell under `/here`.
- `start`: start an existing instance and enter a shell under `/here`.
- `run COMMAND [ARG...]`: create/start the instance and run the command with `/here` as working directory.
- `stop`: stop the instance while preserving its disk.
- `destroy`: delete the instance while preserving Lima's image cache.
- `prune`: explicitly prune Lima's cache.
