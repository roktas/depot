---
all:
  level: minimal
  links:
    bin/vpn: ~/.local/bin/vpn
---

# Tailscale

Tailscale is a zero-config mesh VPN built on WireGuard.

Tilde treats Tailscale as a pre-bootstrap system dependency, not as a Homebrew-managed package. On Debian-family Linux
hosts, install and run the official deb package and systemd service before Tilde. On macOS, use the installed
Tailscale app or another existing CLI provider.

The `vpn` wrapper provides the shared exit-node workflow and status output without owning Tailscale installation.
