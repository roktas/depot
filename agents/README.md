---
all:
  packages:
    - playwright-cli
    - rtk
    - skill:github.com/roktas/covit
  links:
    AGENTS.md: ~/.agents/AGENTS.md
    skills/: ~/.agents/skills
    ~/.agents/skills/covit/skills/bash: ~/.agents/skills/bash
    ~/.agents/skills/covit/skills/c: ~/.agents/skills/c
    ~/.agents/skills/covit/skills/code: ~/.agents/skills/code
    ~/.agents/skills/covit/skills/english: ~/.agents/skills/english
    ~/.agents/skills/covit/skills/ruby: ~/.agents/skills/ruby
    ~/.agents/skills/covit/skills/tex: ~/.agents/skills/tex
    ~/.agents/skills/covit/skills/text: ~/.agents/skills/text
    ~/.agents/skills/covit/skills/turkish: ~/.agents/skills/turkish
    ~/.agents/skills/covit/skills/view: ~/.agents/skills/view
---

# Agents

Common agent instructions and skills installed through the shared `~/.agents` surface.

Keep this module model-neutral. If an asset is only for one agent CLI, put it in that CLI's own module.

Covit is installed as the managed external checkout `~/.agents/skills/covit`. Its component skills are linked into the
shared top-level skill directory so roots and specialists remain sibling-addressable. Repository-owned public skills
remain under `skills/`.

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
