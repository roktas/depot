---
all:
  level: normal
  links:
    bin/box: ~/.local/bin/box
---

# Dropbox

Installs the `box` wrapper for service-aware Dropbox control where a host has a managed Dropbox service, while still
delegating to the Dropbox CLI on hosts without one.

## Notes

Use `box` for service-aware manual control. `dropbox status` remains safe for direct status reads, but `box start`,
`box stop`, and `box restart` keep manual operations aligned with the systemd user service where one is installed.

On non-Linux platforms, `box` does not manage a service. It keeps the same command habit and delegates to the Dropbox
CLI when available.
