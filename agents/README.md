---
all:
  packages:
    - playwright-cli
    - rtk
    - skill:github.com/AminBlg/SimpleEnglish
    - skill:github.com/roktas/ajans
  links:
    AGENTS.md: ~/.agents/AGENTS.md
    skills/: ~/.agents/skills
    ~/.agents/skills/ajans/skills/bash: ~/.agents/skills/bash
    ~/.agents/skills/ajans/skills/c: ~/.agents/skills/c
    ~/.agents/skills/ajans/skills/deai: ~/.agents/skills/deai
    ~/.agents/skills/ajans/skills/go: ~/.agents/skills/go
    ~/.agents/skills/ajans/skills/grilling: ~/.agents/skills/grilling
    ~/.agents/skills/ajans/skills/naming: ~/.agents/skills/naming
    ~/.agents/skills/ajans/skills/ruby: ~/.agents/skills/ruby
    ~/.agents/skills/ajans/skills/testing: ~/.agents/skills/testing
    ~/.agents/skills/ajans/skills/tex: ~/.agents/skills/tex
    ~/.agents/skills/ajans/skills/writing: ~/.agents/skills/writing
    ~/.agents/skills/SimpleEnglish/skills/simple-english: ~/.agents/skills/simple-english
---

# Agents

Common agent instructions and skills installed through the shared `~/.agents` surface.

Keep this module model-neutral. If an asset is only for one agent CLI, put it in that CLI's own module.

Ajans is installed as the managed external checkout `~/.agents/skills/ajans`. Its component skills are linked into the
shared top-level skill directory so they remain directly addressable by skill name. SimpleEnglish is installed separately
at `~/.agents/skills/SimpleEnglish`, with its `simple-english` skill exposed on the same shared surface. Repository-owned
public skills remain under `skills/`.

## Validate

Run from the repository root after changing skills or their helpers:

```bash
rtk agents/tests/skills
rtk agents/tests/skills agents/tests/fixtures/skills
```

The general audit validates repository-owned skill packages, their Markdown links, and external skill links. The
fixture invocation checks code and comment exclusions, site-root URLs, and titled package links. Validate an external
skill in its canonical repository as well when that repository changes. Pass another skill directory as the optional
argument when a related repository reuses this audit.

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
