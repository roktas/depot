# Test Environments

Use this reference when setting up container runtimes for provisioning smoke tests.

## Docker

Use Docker for fast smoke checks. Bind mount the repository read-only; do not copy this repository into Docker images.

```bash
docker run --rm -v /home/roktas/Dropbox/src/home:/repo:ro home-provision-smoke
```

### Debian Setup

Install Docker Engine from Docker's official apt repository, not Debian's `docker.io` package.

```bash
sudo apt update
sudo apt install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo adduser "$USER" docker
newgrp docker
docker info
```

Existing long-running processes, agents, tmux sessions, or terminals may need to be restarted before they see the new
`docker` group membership.

## LXD

Use LXD when a system-container host simulation is useful, especially for SSH, apt, sudo, systemd, or user-home behavior.

### Debian Setup

```bash
sudo apt install --install-recommends lxd
sudo adduser "$USER" lxd
newgrp lxd
lxc info
sudo lxd init
```

Use `newgrp lxd` to refresh group membership in the current shell. Existing long-running processes, agents, tmux
sessions, or terminals may still need to be restarted. Use `lxc info` to verify non-root access.

### Ubuntu Smoke Container

```bash
.agents/skills/provision/bin/lxd-smoke
```

Use `--keep` to keep the container for manual inspection. Use `--name NAME` to choose a stable instance name.
Use `--boot` to test the Linux boot bootstrap instead of the normal provision smoke script.

Use `security.nesting=true` for Ubuntu 26.04 LXD containers. Without it, `systemd-networkd` and `systemd-resolved` can
fail during credential mount namespacing with `status=226/NAMESPACE`, leaving the container without working DHCP/DNS.

Delete LXD smoke instances after the test run unless the user explicitly asks to keep them for manual inspection.
