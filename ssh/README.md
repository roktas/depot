---
all:
  level: minimal
  links:
    config: ~/.ssh/config
    hushlogin: ~/.hushlogin
---

# SSH

Shared SSH client configuration and Linux SSH and sudo environment tuning.

The shared client config uses `~/.ssh/config.d` for per-platform and private fragments.

## Configure

```bash
mkdir -p ~/.ssh/config.d
chmod 700 ~/.ssh ~/.ssh/config.d
```

## Linux

### Configure

```bash
changed=0
current=$(mktemp)
desired=$(mktemp)
trap 'rm -f "$current" "$desired"' EXIT HUP INT QUIT TERM

cat >"$desired" <<'EOF'
UseDNS no
AllowAgentForwarding yes
ClientAliveInterval 60
ClientAliveCountMax 60
AcceptEnv LANG LC_* pass_*
EOF

ssh_span_current() {
	[[ -r /etc/ssh/sshd_config ]] || return 1

	awk '
		/^# >>> tilde:ssh$/ { active = 1; next }
		/^# <<< tilde:ssh$/ { found = 1; active = 0; next }
		active { print }
		END { exit found ? 0 : 1 }
	' /etc/ssh/sshd_config >"$current"
	cmp -s "$desired" "$current"
}

if [[ -f /etc/ssh/sshd_config ]] && grep -q '^# BEGIN HOME PROVISION$' /etc/ssh/sshd_config; then
	sudo perl -0pi -e 's/^# BEGIN HOME PROVISION\n.*?^# END HOME PROVISION\n?//ms' /etc/ssh/sshd_config
	changed=1
fi

if ! ssh_span_current; then
	# shellcheck disable=SC2024
	sudo span ensure /etc/ssh/sshd_config ssh <"$desired"
	changed=1
fi

if [[ ! -e /etc/sudoers.d/ssh ]]; then
	sudo line ensure /etc/sudoers.d/ssh 'Defaults env_keep += "SSH_*"'
	sudo chmod 0440 /etc/sudoers.d/ssh
	changed=1
fi

if (( changed )) && command -v systemctl >/dev/null; then
	sudo systemctl restart ssh || sudo systemctl restart sshd || true
fi
```
