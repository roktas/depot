---
all:
  level: minimal
  links:
    config: ~/.ssh/config
---

# SSH

Shared SSH client configuration and Linux SSH and sudo environment tuning.

The shared client config uses `~/.ssh/config.d` for per-platform and private fragments.

## Postinstall

```bash
mkdir -p ~/.ssh/config.d
chmod 700 ~/.ssh ~/.ssh/config.d
```

## Linux

### Install

Apply conservative SSH and sudo environment tweaks.

```bash
fix_block() {
	local file=$1

	[[ -f $file ]] || return 0
	sudo sed -i '/BEGIN HOME PROVISION/,/END HOME PROVISION/d' "$file"
	{
		echo "# BEGIN HOME PROVISION"
		cat
		echo "# END HOME PROVISION"
	} | sudo tee -a "$file" >/dev/null
}

{
	echo "UseDNS no"
	echo "AllowAgentForwarding yes"
	echo "ClientAliveInterval 60"
	echo "ClientAliveCountMax 60"
	echo "AcceptEnv LANG LC_* pass_*"
} | fix_block /etc/ssh/sshd_config

printf '%s\n' 'Defaults env_keep += "SSH_*"' | sudo tee /etc/sudoers.d/ssh >/dev/null
sudo chmod 0440 /etc/sudoers.d/ssh

if command -v systemctl >/dev/null; then
	sudo systemctl restart ssh || sudo systemctl restart sshd || true
fi
```
