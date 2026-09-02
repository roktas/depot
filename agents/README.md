---
all:
  packages:
    - playwright-cli
    - rtk
    - skill:github.com/AminBlg/SimpleEnglish
  links:
    AGENTS.md: ~/.agents/AGENTS.md
    skills/: ~/.agents/skills
    ~/.agents/skills/SimpleEnglish/skills/simple-english: ~/.agents/skills/simple-english
---

# Agents

Expose shared agent tooling and public agent assets through the `~/.agents` surface.

The canonical public agent configuration lives in the sibling Ajans checkout. `AGENTS.md` and the Ajans-owned entries
under `skills/` are relative links into `../ajans`, following the same sibling-checkout model used for the Tilde skill.
The local `skills/tilde` link continues to point at the sibling Tilde checkout. SimpleEnglish is installed separately and
exposed on the same shared skill surface.

This module owns projection and deployment only. Public user-wide instructions, reusable skills, and their validation
belong in Ajans; private agent assets belong in the private companion repository.

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

install_browser
playwright-cli install --skills agents
```
