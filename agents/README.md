---
all:
  packages:
    - playwright-cli
    - rtk
  links:
    ../../ajans/agents/AGENTS.md: ~/.agents/AGENTS.md
    ../../ajans/skills/: ~/.agents/skills
---

# Agents

Expose shared agent tooling and public agent assets through the `~/.agents` surface.

The canonical public agent configuration lives in the sibling Ajans checkout. This manifest links the shared agent
instructions and all direct children of `ajans/skills`. The module does not contain copies or symlinks for Ajans assets.
Tilde owns its runtime link outside this module. The Configure section installs only the SimpleEnglish skill. It skips
this installation when `npx` is not available.

Dropbox-backed hosts use `~/Dropbox/ajans`. Git-backed hosts use the matching sibling checkout at
`~/.local/src/ajans`. The controller must refresh this Git-backed checkout before the target plan. Module-relative source
paths select the applicable sibling checkout in both layouts.

This module owns projection and deployment only. Public user-wide instructions, reusable skills, and their validation
belong in Ajans; private agent assets belong in the private companion repository.

## Prerequisites

The Ajans sibling checkout must be present. Dropbox synchronizes the checkout on interactive hosts. The Tilde controller
delivers it to Git-backed hosts.

```bash
if [[ -d $HOME/Dropbox ]]; then
	readonly TARGET=$HOME/Dropbox/ajans
else
	readonly TARGET=$HOME/.local/src/ajans
fi

[[ -d $TARGET/.git ]]
```

## Configure

```bash
cd "$HOME" || exit

graphical_host() {
	local session=${XDG_CURRENT_DESKTOP:-}${DESKTOP_SESSION:-}

	if [[ -n $session && ! $session =~ (tty|headless) ]]; then
		return 0
	fi

	if [[ $(systemctl get-default 2>/dev/null || true) == graphical.target ]]; then
		return 0
	fi

	if systemctl is-enabled gdm3 sddm lightdm display-manager 2>/dev/null |
		grep -Eq '^(enabled|static|generated|alias|indirect)$'; then
		return 0
	fi

	if [[ -s /etc/X11/default-display-manager ]]; then
		return 0
	fi

	compgen -G '/usr/share/xsessions/*.desktop' >/dev/null && return 0
	compgen -G '/usr/share/wayland-sessions/*.desktop' >/dev/null && return 0

	return 1
}

install_browser() {
	case $(uname -s) in
	Darwin)
		playwright-cli install-browser chrome-for-testing
		;;
	Linux)
		if ! graphical_host; then
			printf 'W: skipping Playwright browser install: no graphical Linux session detected\n' >&2
			return 0
		fi
		playwright-cli install-browser chrome-for-testing
		;;
	esac
}

install_simple_english() {
	local skill_dir=$HOME/.agents/skills/simple-english

	if [[ -f $skill_dir/SKILL.md && ! -L $skill_dir ]]; then
		return 0
	fi

	if [[ -e $skill_dir || -L $skill_dir ]]; then
		printf 'E: cannot install SimpleEnglish: target exists and is not a skill directory\n' >&2
		return 1
	fi

	if ! command -v npx &>/dev/null; then
		printf 'W: skipping SimpleEnglish install: npx is not available\n' >&2
		return 0
	fi

	npx -y skills add AminBlg/SimpleEnglish --skill simple-english --global --agent codex --yes
}

install_browser
install_simple_english
playwright-cli install --skills agents
```
