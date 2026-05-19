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
Use `--boot` to test the Linux bootstrap helper instead of the normal provision smoke script.

Use `security.nesting=true` for Ubuntu 26.04 LXD containers. Without it, `systemd-networkd` and `systemd-resolved` can
fail during credential mount namespacing with `status=226/NAMESPACE`, leaving the container without working DHCP/DNS.

The smoke helper restarts the container after setting `security.nesting=true`; if you reproduce the steps manually, do
the same before diagnosing network failures. Treat active `systemd-networkd` and `systemd-resolved` as necessary but not
sufficient: LXD image downloads use the host network, while apt runs from inside the container and depends on bridge
NAT/firewall forwarding. A cached image can therefore exist even when container outbound HTTP is broken.

When apt mirror access is flaky or IPv6 is broken, use retrying apt commands, force IPv4, and make `apt-get update`
fail on unreachable indexes instead of silently reusing stale lists:

```bash
apt-get -o Acquire::Retries=3 -o Acquire::ForceIPv4=true -o APT::Update::Error-Mode=any update
apt-get -o Acquire::Retries=3 -o Acquire::ForceIPv4=true install -y --no-install-recommends ruby
```

If apt still times out, verify outbound HTTP from inside the container before changing package commands:

```bash
lxc exec INSTANCE -- bash -lc 'timeout 5 bash -lc "</dev/tcp/1.1.1.1/80"'
lxc exec INSTANCE -- bash -lc 'ip -4 addr show dev eth0; ip route; resolvectl dns eth0 || true'
```

If the route and DNS look valid but outbound HTTP times out, inspect host-side LXD bridge NAT, firewall, and forwarding
rules before rerunning the smoke test.

Delete LXD smoke instances after the test run unless the user explicitly asks to keep them for manual inspection.
