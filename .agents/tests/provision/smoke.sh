#!/usr/bin/env bash

set -Eeuo pipefail; shopt -s nullglob; [[ -z ${TRACE:-} ]] || set -x; unset CDPATH; IFS=$' \n'

main() {
	local repo
	local script_dir

	script_dir=$(cd -- "${BASH_SOURCE[0]%/*}" >/dev/null && pwd)
	repo=${REPO_ROOT:-$(cd -- "$script_dir/../../.." >/dev/null && pwd)}
	LEVEL_EXTRA_MODULE=$repo/zz-level-extra-smoke
	PLATFORM_NULL_MODULE=$repo/zz-platform-null-smoke

	trap 'rm -rf "$LEVEL_EXTRA_MODULE" "$PLATFORM_NULL_MODULE"' EXIT HUP INT QUIT TERM

	export GIT_CONFIG_GLOBAL=${GIT_CONFIG_GLOBAL:-/tmp/provision-smoke-gitconfig}

	cd "$repo"
	git config --global --add safe.directory "$repo"

	ruby -c .agents/skills/provision/bin/plan

	if .agents/skills/provision/bin/plan >/tmp/plan.json 2>/tmp/plan.err; then
		echo "expected dirty worktree guard to fail" >&2
		exit 1
	fi

	grep -q "Dirty worktree" /tmp/plan.err

	.agents/skills/provision/bin/plan --allow-dirty --platform linux --host smoke >/tmp/plan.json

	ruby -rjson -e '
		plan = JSON.parse(File.read("/tmp/plan.json"))
		abort "wrong mode" unless plan.fetch("mode") == "apply"
		abort "wrong level" unless plan.fetch("level") == "normal"
		abort "wrong platform" unless plan.fetch("platform") == "linux"
		general = plan.fetch("modules").find { |mod| mod.fetch("name") == "_" }
		abort "missing general module" unless general
		abort "general module should be first" unless plan.fetch("modules").first.fetch("name") == "_"
		abort "general module should install shared tools" unless general.fetch("packages_to_install").any? { |pkg| pkg.fetch("value") == "brew:zoxide" }
		linux = plan.fetch("modules").find { |mod| mod.fetch("name") == "linux" }
		abort "missing linux platform module" unless linux
		abort "linux platform module should be second" unless plan.fetch("modules")[1].fetch("name") == "linux"
		abort "missing linux install section" unless linux.fetch("special_sections").key?("Install")
		abort "linux dash variant should not be planned at normal level" if plan.fetch("modules").any? { |mod| mod.fetch("name") == "linux-" }
		agents = plan.fetch("modules").find { |mod| mod.fetch("name") == "agents" }
		abort "missing agents module" unless agents
		abort "agents should default to normal level" unless agents.fetch("level") == "normal"
		abort "agents should be virtual" unless agents.fetch("virtual") == true
		git = plan.fetch("modules").find { |mod| mod.fetch("name") == "git" }
		abort "missing git module" unless git
		abort "git should not be virtual" unless git.fetch("virtual") == false
		abort "missing brew:git" unless git.fetch("packages_to_install").any? { |pkg| pkg.fetch("value") == "brew:git" }
		abort "missing git config link" unless git.fetch("links_to_create").any? { |link| link.fetch("target") == "~/.config/git/config" }
		abort "missing git bin fan-in link" unless git.fetch("links_to_create").any? { |link| link.fetch("source") == "bin/git-renew" && link.fetch("target") == "~/.local/bin/git-renew" && link.fetch("fan_in") == true }
		mc = plan.fetch("modules").find { |mod| mod.fetch("name") == "mc" }
		abort "missing mc module" unless mc
		abort "missing mc.ini copy" unless mc.fetch("copies_to_create").any? { |copy| copy.fetch("target") == "~/.config/mc/ini" }
		abort "gnome module should not be planned" if plan.fetch("modules").any? { |mod| mod.fetch("name") == "gnome" }
	'

	rm -rf "$LEVEL_EXTRA_MODULE"
	mkdir -p "$LEVEL_EXTRA_MODULE"
	cat >"$LEVEL_EXTRA_MODULE/README.md" <<'EOF'
---
all:
  level: extra
---

# Level Extra Smoke
EOF

	.agents/skills/provision/bin/plan --allow-dirty --platform linux --host smoke >/tmp/normal-plan.json
	.agents/skills/provision/bin/plan --allow-dirty --level extra --platform linux --host smoke >/tmp/extra-plan.json

	ruby -rjson -e '
		normal_plan = JSON.parse(File.read("/tmp/normal-plan.json"))
		extra_plan = JSON.parse(File.read("/tmp/extra-plan.json"))
		abort "extra module should not be planned at normal level" if normal_plan.fetch("modules").any? { |mod| mod.fetch("name") == "zz-level-extra-smoke" }
		linux_dash = extra_plan.fetch("modules").find { |mod| mod.fetch("name") == "linux-" }
		abort "missing linux dash variant at extra level" unless linux_dash
		abort "linux dash variant should follow linux" unless extra_plan.fetch("modules")[2].fetch("name") == "linux-"
		extra = extra_plan.fetch("modules").find { |mod| mod.fetch("name") == "zz-level-extra-smoke" }
		abort "missing extra module at extra level" unless extra
		abort "wrong extra module level" unless extra.fetch("level") == "extra"
	'

	rm -rf "$PLATFORM_NULL_MODULE"
	mkdir -p "$PLATFORM_NULL_MODULE"
	cat >"$PLATFORM_NULL_MODULE/README.md" <<'EOF'
---
macos: ~
---

# Platform Null Smoke

## Install

```bash
true
```
EOF

	.agents/skills/provision/bin/plan --allow-dirty --platform macos --host smoke >/tmp/macos-plan.json

	ruby -rjson -e '
		plan = JSON.parse(File.read("/tmp/macos-plan.json"))
		abort "gnome should not be planned on macos" if plan.fetch("modules").any? { |mod| mod.fetch("name") == "gnome" }
		abort "linux should not be planned on macos" if plan.fetch("modules").any? { |mod| mod.fetch("name") == "linux" }
		smoke = plan.fetch("modules").find { |mod| mod.fetch("name") == "zz-platform-null-smoke" }
		abort "missing platform null module" unless smoke
		abort "missing platform null install section" unless smoke.fetch("special_sections").key?("Install")
	'

	.agents/skills/provision/bin/plan --mode refresh --platform linux --host smoke >/tmp/refresh-plan.json

	ruby -rjson -e '
		plan = JSON.parse(File.read("/tmp/refresh-plan.json"))
		abort "wrong refresh mode" unless plan.fetch("mode") == "refresh"
		neovim = plan.fetch("modules").find { |mod| mod.fetch("name") == "neovim" }
		abort "missing neovim module" unless neovim
		abort "refresh should not create links" unless neovim.fetch("links_to_create").empty?
		abort "missing neovim refresh package" unless neovim.fetch("packages_to_refresh").any? { |pkg| pkg.fetch("value") == "brew:neovim" }
		abort "missing neovim update section" unless neovim.fetch("special_sections").key?("Update")
	'

	echo "provision smoke ok"
}

main "$@"
