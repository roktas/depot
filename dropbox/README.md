---
all:
  level: normal
  links:
    bin/box: ~/.local/bin/box
---

# Dropbox

Installs the `box` wrapper and, on initialized Linux Dropbox hosts, runs Dropbox through a linger-enabled user service.
Unsupported platforms and hosts without an initialized Dropbox installation are skipped by live guardrails.

## Configure

```bash
[[ -x $HOME/.local/bin/box ]] || exit 0
"$HOME/.local/bin/box" provision
```

## Notes

Use `box` for service-aware manual control. `dropbox status` remains safe for direct status reads, but `box start`,
`box stop`, and `box restart` keep manual operations aligned with the systemd user service where one is installed.

On non-Linux platforms, `box` does not manage a service. It keeps the same command habit and delegates to the Dropbox
CLI when available. If the CLI is missing, `box status` reports whether the Dropbox app appears active from the live
process state.
