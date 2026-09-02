---
all:
  packages:
    - playwright-cli
    - rtk
    - skill:github.com/AminBlg/SimpleEnglish
    - skill:github.com/roktas/ajans
  links:
    skills/: ~/.agents/skills
    ~/.agents/skills/ajans/agents/AGENTS.md: ~/.agents/AGENTS.md
    ~/.agents/skills/ajans/skills/bash: ~/.agents/skills/bash
    ~/.agents/skills/ajans/skills/c: ~/.agents/skills/c
    ~/.agents/skills/ajans/skills/deai: ~/.agents/skills/deai
    ~/.agents/skills/ajans/skills/go: ~/.agents/skills/go
    ~/.agents/skills/ajans/skills/grilling: ~/.agents/skills/grilling
    ~/.agents/skills/ajans/skills/local: ~/.agents/skills/local
    ~/.agents/skills/ajans/skills/naming: ~/.agents/skills/naming
    ~/.agents/skills/ajans/skills/oci: ~/.agents/skills/oci
    ~/.agents/skills/ajans/skills/ruby: ~/.agents/skills/ruby
    ~/.agents/skills/ajans/skills/testing: ~/.agents/skills/testing
    ~/.agents/skills/ajans/skills/tex: ~/.agents/skills/tex
    ~/.agents/skills/ajans/skills/writing: ~/.agents/skills/writing
    ~/.agents/skills/SimpleEnglish/skills/simple-english: ~/.agents/skills/simple-english
---

# Agents

Install shared agent tooling and project canonical public instructions and reusable skills into the `~/.agents` surface.

Ajans is installed as the managed external checkout `~/.agents/skills/ajans`. Its `agents/AGENTS.md` is projected to
`~/.agents/AGENTS.md`, and its component skills are linked into the shared top-level skill directory so they remain
directly addressable by skill name. SimpleEnglish is installed separately and exposed on the same surface.

This module owns deployment only. Public user-wide agent instructions, reusable skills, and their validation belong in
Ajans. The local `skills/` directory is reserved for deployment links such as the maintainer's Tilde checkout.

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
