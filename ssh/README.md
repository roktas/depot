---
all:
  level: minimal
  links:
    config: ~/.ssh/config
---

# SSH

Shared SSH client configuration and Linux SSH and sudo environment tuning.

The shared client config uses `~/.ssh/config.d` for per-platform and private fragments.

## Post Install

```bash
mkdir -p ~/.ssh/config.d
chmod 700 ~/.ssh ~/.ssh/config.d
```

## Linux

### Install

```bash
if [[ -f /etc/ssh/sshd_config ]]; then
	sudo perl -0pi -e 's/^# BEGIN HOME PROVISION\n.*?^# END HOME PROVISION\n?//ms' /etc/ssh/sshd_config
fi

sudo span ensure /etc/ssh/sshd_config ssh <<'EOF'
UseDNS no
AllowAgentForwarding yes
ClientAliveInterval 60
ClientAliveCountMax 60
AcceptEnv LANG LC_* pass_*
EOF

sudo line ensure /etc/sudoers.d/ssh 'Defaults env_keep += "SSH_*"'
sudo chmod 0440 /etc/sudoers.d/ssh

if command -v systemctl >/dev/null; then
	sudo systemctl restart ssh || sudo systemctl restart sshd || true
fi
```
