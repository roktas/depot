#!/usr/bin/env bash

set -euo pipefail
[[ -z ${TRACE:-} ]] || set -x
unset CDPATH

cleanup_dirty_guard_module=
cleanup_level_extra_module=
cleanup_link_target_list_module=
cleanup_platform_null_module=
cleanup_repair_repo=

# ------------------------------------------------------------------------------------------------------------------------
# Helpers
# ------------------------------------------------------------------------------------------------------------------------

cleanup() {
	rm -rf "$cleanup_dirty_guard_module" "$cleanup_level_extra_module" "$cleanup_link_target_list_module" "$cleanup_platform_null_module"
	[[ -z $cleanup_repair_repo ]] || rm -rf "$cleanup_repair_repo"
}

# ------------------------------------------------------------------------------------------------------------------------
# Main
# ------------------------------------------------------------------------------------------------------------------------

main() {
	local dirty_guard_module
	local head
	local level_extra_module
	local link_target_list_module
	local platform_null_module
	local repair_repo=
	local repo
	local script_dir

	script_dir=$(cd -- "${BASH_SOURCE[0]%/*}" >/dev/null && pwd)
	repo=${REPO_ROOT:-$(cd -- "$script_dir/../../.." >/dev/null && pwd)}
	dirty_guard_module=$repo/zz-dirty-guard-smoke
	level_extra_module=$repo/zz-level-extra-smoke
	link_target_list_module=$repo/zz-link-target-list-smoke
	platform_null_module=$repo/zz-platform-null-smoke
	cleanup_dirty_guard_module=$dirty_guard_module
	cleanup_level_extra_module=$level_extra_module
	cleanup_link_target_list_module=$link_target_list_module
	cleanup_platform_null_module=$platform_null_module

	trap cleanup EXIT HUP INT QUIT TERM

	export GIT_CONFIG_GLOBAL=${GIT_CONFIG_GLOBAL:-/tmp/provision-smoke-gitconfig}

	cd "$repo"
	git config --global --add safe.directory "$repo"

	ruby -c .agents/skills/depot/bin/plan

	rm -rf "$dirty_guard_module"
	mkdir -p "$dirty_guard_module"
	cat >"$dirty_guard_module/README.md" <<'EOF'
# Dirty Guard Smoke
EOF

	if .agents/skills/depot/bin/plan >/tmp/plan.json 2>/tmp/plan.err; then
		echo "expected dirty worktree guard to fail" >&2
		exit 1
	fi

	grep -q "Dirty worktree" /tmp/plan.err
	rm -rf "$dirty_guard_module"

	.agents/skills/depot/bin/plan --allow-dirty --platform linux --host smoke >/tmp/plan.json

	ruby -rjson -e '
		plan = JSON.parse(File.read("/tmp/plan.json"))
		abort "wrong mode" unless plan.fetch("mode") == "apply"
		abort "wrong level" unless plan.fetch("level") == "normal"
		abort "wrong platform" unless plan.fetch("platform") == "linux"
		linux = plan.fetch("modules").find { |mod| mod.fetch("name") == "linux" }
		abort "missing linux platform module" unless linux
		abort "linux platform module should be first" unless plan.fetch("modules").first.fetch("name") == "linux"
		abort "missing linux install section" unless linux.fetch("special_sections").key?("Install")
		misc = plan.fetch("modules").find { |mod| mod.fetch("name") == "misc" }
		abort "missing misc module" unless misc
		abort "misc module should run alphabetically" unless plan.fetch("modules").map { |mod| mod.fetch("name") }.index("misc") > plan.fetch("modules").map { |mod| mod.fetch("name") }.index("markdown")
		abort "misc module should install shared tools" unless misc.fetch("packages_to_install").any? { |pkg| pkg.fetch("value") == "brew:zoxide" }
		chrome = plan.fetch("modules").find { |mod| mod.fetch("name") == "chrome" }
		abort "missing chrome module" unless chrome
		abort "missing chrome linux install section" unless chrome.fetch("special_sections").dig("Install", "body").include?("google-chrome-beta")
		abort "chrome linux plan should not install macos cask" unless chrome.fetch("packages_to_install").empty?
		abort "linux dash variant should not be planned at normal level" if plan.fetch("modules").any? { |mod| mod.fetch("name") == "linux-" }
		agents = plan.fetch("modules").find { |mod| mod.fetch("name") == "agents" }
		abort "missing agents module" unless agents
		abort "agents should default to normal level" unless agents.fetch("level") == "normal"
		abort "agents should not be virtual" unless agents.fetch("virtual") == false
		abort "missing opencode package" unless agents.fetch("packages_to_install").any? { |pkg| pkg.fetch("value") == "brew:opencode" }
		abort "agents should keep low-cost skills under ~/.agents" unless agents.fetch("links_to_create").any? { |link| link.fetch("target") == "~/.agents/skills/commits" }
		abort "agents colon skill should be the common source" if File.symlink?("agents/skills/colon")
		abort "agents frontier colon skill should be a shared symlink" unless File.symlink?("agents-/skills/colon")
		abort "agents frontier colon symlink target changed" unless File.readlink("agents-/skills/colon") == "../../agents/skills/colon"
		abort "agents frontier bash skill should be a shared symlink" unless File.symlink?("agents-/skills/bash")
		abort "agents frontier bash symlink target changed" unless File.readlink("agents-/skills/bash") == "../../agents/skills/bash"
		abort "agents frontier ruby skill should be a shared symlink" unless File.symlink?("agents-/skills/ruby")
		abort "agents frontier ruby symlink target changed" unless File.readlink("agents-/skills/ruby") == "../../agents/skills/ruby"
		agents_frontier = plan.fetch("modules").find { |mod| mod.fetch("name") == "agents-" }
		abort "missing agents frontier module" unless agents_frontier
		abort "missing codex cask" unless agents_frontier.fetch("packages_to_install").any? { |pkg| pkg.fetch("value") == "cask:codex" }
		abort "agents frontier should link codex skills" unless agents_frontier.fetch("links_to_create").any? { |link| link.fetch("target") == "~/.codex/skills/commits" }
		abort "agents frontier should link shared bash skill" unless agents_frontier.fetch("links_to_create").any? { |link| link.fetch("source") == "skills/bash" && link.fetch("target") == "~/.codex/skills/bash" }
		abort "agents should not directly link frontier bash skill" if agents.fetch("links_to_create").any? { |link| link.fetch("target") == "~/.codex/skills/bash" }
		abort "agents frontier should link codex hooks by directory" unless agents_frontier.fetch("links_to_create").any? { |link| link.fetch("source") == "codex/hooks/shellcheck" && link.fetch("target") == "~/.codex/hooks/shellcheck" && link.fetch("fan_in") == true }
		abort "agents frontier should not link system skills" if agents_frontier.fetch("links_to_create").any? { |link| link.fetch("target").include?("/.system") }
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

	rm -rf "$link_target_list_module"
	mkdir -p "$link_target_list_module/bin"
	touch "$link_target_list_module/config" "$link_target_list_module/bin/tool"
	cat >"$link_target_list_module/README.md" <<'EOF'
---
all:
  links:
    config:
      - ~/.config/target-list/a
      - ~/.config/target-list/b
    bin/:
      - ~/.local/bin
      - ~/.local/sbin
---

# Link Target List Smoke
EOF

	.agents/skills/depot/bin/plan --allow-dirty --platform linux --host smoke >/tmp/link-target-list-plan.json

	ruby -rjson -e '
		plan = JSON.parse(File.read("/tmp/link-target-list-plan.json"))
		smoke = plan.fetch("modules").find { |mod| mod.fetch("name") == "zz-link-target-list-smoke" }
		abort "missing link target list module" unless smoke
		links = smoke.fetch("links_to_create")
		abort "missing first scalar source target" unless links.any? { |link| link.fetch("source") == "config" && link.fetch("target") == "~/.config/target-list/a" }
		abort "missing second scalar source target" unless links.any? { |link| link.fetch("source") == "config" && link.fetch("target") == "~/.config/target-list/b" }
		abort "missing first fan-in list target" unless links.any? { |link| link.fetch("source") == "bin/tool" && link.fetch("target") == "~/.local/bin/tool" && link.fetch("fan_in") == true }
		abort "missing second fan-in list target" unless links.any? { |link| link.fetch("source") == "bin/tool" && link.fetch("target") == "~/.local/sbin/tool" && link.fetch("fan_in") == true }
	'

	rm -rf "$level_extra_module"
	mkdir -p "$level_extra_module"
	cat >"$level_extra_module/README.md" <<'EOF'
---
all:
  level: extra
---

# Level Extra Smoke
EOF

	.agents/skills/depot/bin/plan --allow-dirty --platform linux --host smoke >/tmp/normal-plan.json
	.agents/skills/depot/bin/plan --allow-dirty --level extra --platform linux --host smoke >/tmp/extra-plan.json

	ruby -rjson -e '
		normal_plan = JSON.parse(File.read("/tmp/normal-plan.json"))
		extra_plan = JSON.parse(File.read("/tmp/extra-plan.json"))
		abort "extra module should not be planned at normal level" if normal_plan.fetch("modules").any? { |mod| mod.fetch("name") == "zz-level-extra-smoke" }
		linux_dash = extra_plan.fetch("modules").find { |mod| mod.fetch("name") == "linux-" }
		abort "missing linux dash variant at extra level" unless linux_dash
		abort "linux dash variant should follow linux" unless extra_plan.fetch("modules")[1].fetch("name") == "linux-"
		abort "missing linux dash dropignore package" unless linux_dash.fetch("packages_to_install").any? { |pkg| pkg.fetch("value") == "github:mweirauch/dropignore" }
		abort "calibre should be a guarded install section" unless linux_dash.fetch("special_sections").dig("Install", "body").include?("com.calibre_ebook.calibre")
		extra = extra_plan.fetch("modules").find { |mod| mod.fetch("name") == "zz-level-extra-smoke" }
		abort "missing extra module at extra level" unless extra
		abort "wrong extra module level" unless extra.fetch("level") == "extra"
		c = extra_plan.fetch("modules").find { |mod| mod.fetch("name") == "c" }
		abort "missing c extra module" unless c
		abort "missing c llvm package" unless c.fetch("packages_to_install").any? { |pkg| pkg.fetch("value") == "brew:llvm" }
		javascript = extra_plan.fetch("modules").find { |mod| mod.fetch("name") == "javascript" }
		abort "missing javascript module" unless javascript
		abort "missing tapped bun formula" unless javascript.fetch("packages_to_install").any? { |pkg| pkg.fetch("value") == "brew:oven-sh/bun/bun" }
		virtualbox = extra_plan.fetch("modules").find { |mod| mod.fetch("name") == "virtualbox" }
		abort "missing virtualbox extra module" unless virtualbox
		abort "virtualbox should be virtual" unless virtualbox.fetch("virtual") == true
		abort "missing virtualbox install section" unless virtualbox.fetch("special_sections").key?("Install")
		abort "missing virtualbox postinstall section" unless virtualbox.fetch("special_sections").key?("Postinstall")
		abort "ghostty should not be planned on linux" if extra_plan.fetch("modules").any? { |mod| mod.fetch("name") == "ghostty" }
		vscode = extra_plan.fetch("modules").find { |mod| mod.fetch("name") == "vscode" }
		abort "missing vscode module" unless vscode
		abort "vscode linux plan should not install cask" if vscode.fetch("packages_to_install").any? { |pkg| pkg.fetch("value") == "cask:visual-studio-code" }
	'

	rm -rf "$platform_null_module"
	mkdir -p "$platform_null_module"
	cat >"$platform_null_module/README.md" <<'EOF'
---
macos: ~
---

# Platform Null Smoke

## All Platforms

### Install

```bash
echo all
```

## MacOS

### Install

```bash
echo macos
```
EOF

	.agents/skills/depot/bin/plan --allow-dirty --platform macos --host smoke >/tmp/macos-plan.json

	ruby -rjson -e '
		plan = JSON.parse(File.read("/tmp/macos-plan.json"))
		abort "gnome should not be planned on macos" if plan.fetch("modules").any? { |mod| mod.fetch("name") == "gnome" }
		abort "linux should not be planned on macos" if plan.fetch("modules").any? { |mod| mod.fetch("name") == "linux" }
		ghostty = plan.fetch("modules").find { |mod| mod.fetch("name") == "ghostty" }
		abort "missing ghostty module on macos" unless ghostty
		abort "missing ghostty macos cask" unless ghostty.fetch("packages_to_install").any? { |pkg| pkg.fetch("value") == "cask:ghostty" }
		chrome = plan.fetch("modules").find { |mod| mod.fetch("name") == "chrome" }
		abort "missing chrome module on macos" unless chrome
		abort "missing chrome beta macos cask" unless chrome.fetch("packages_to_install").any? { |pkg| pkg.fetch("value") == "cask:google-chrome@beta" }
		abort "chrome macos plan should not include linux install" if chrome.fetch("special_sections").key?("Install")
		abort "virtualbox should not be planned on macos" if plan.fetch("modules").any? { |mod| mod.fetch("name") == "virtualbox" }
		smoke = plan.fetch("modules").find { |mod| mod.fetch("name") == "zz-platform-null-smoke" }
		abort "missing platform null module" unless smoke
		abort "missing platform null install section" unless smoke.fetch("special_sections").key?("Install")
		body = smoke.fetch("special_sections").fetch("Install").fetch("body")
		abort "platform scoped sections should preserve document order" unless body.index("echo all") < body.index("echo macos")
	'

	rm -rf "$platform_null_module"
	mkdir -p "$platform_null_module"
	cat >"$platform_null_module/README.md" <<'EOF'
---
all:
  packages:
    - "brew:"
---

# Invalid Package Smoke
EOF

	if .agents/skills/depot/bin/plan --allow-dirty --platform linux --host smoke >/tmp/invalid-package-plan.json 2>/tmp/invalid-package-plan.err; then
		echo "expected invalid package name guard to fail" >&2
		exit 1
	fi

	grep -q "Package name must not be empty" /tmp/invalid-package-plan.err

	rm -rf "$platform_null_module"

	.agents/skills/depot/bin/plan --mode refresh --platform linux --host smoke >/tmp/refresh-plan.json

	ruby -rjson -e '
		plan = JSON.parse(File.read("/tmp/refresh-plan.json"))
		abort "wrong refresh mode" unless plan.fetch("mode") == "refresh"
		neovim = plan.fetch("modules").find { |mod| mod.fetch("name") == "neovim" }
		abort "missing neovim module" unless neovim
		abort "refresh should not create links" unless neovim.fetch("links_to_create").empty?
		abort "missing neovim refresh package" unless neovim.fetch("packages_to_refresh").any? { |pkg| pkg.fetch("value") == "brew:neovim" }
		abort "missing neovim update section" unless neovim.fetch("special_sections").key?("Update")
	'

	ruby -rjson -ropen3 -e '
		%w[
			/tmp/normal-plan.json
			/tmp/extra-plan.json
			/tmp/macos-plan.json
			/tmp/refresh-plan.json
		].each do |path|
			plan = JSON.parse(File.read(path))
			plan.fetch("modules").each do |mod|
				mod.fetch("special_sections").each do |name, section|
					section.fetch("bash_blocks").each_with_index do |block, index|
						_stdout, stderr, status = Open3.capture3("bash", "-n", stdin_data: block)
						next if status.success?

						abort "invalid bash block in #{mod.fetch(%q[name])} #{name} ##{index + 1}: #{stderr}"
					end
				end
			end
		end
	'

	repair_repo=$(mktemp -d "${TMPDIR:-/tmp}/provision-repair-repo.XXXXXX")
	cleanup_repair_repo=$repair_repo
	cp -a "$repo/." "$repair_repo"
	mkdir -p "$repair_repo/.agents/state/hosts/smoke-repair"
	head=$(git -C "$repair_repo" rev-parse HEAD)
	cat >"$repair_repo/.agents/state/hosts/smoke-repair/depot.md" <<EOF
---
head: $head
done:
  git: notok
  mc: ok
---
EOF

	"$repair_repo/.agents/skills/depot/bin/plan" --repo "$repair_repo" --allow-dirty --mode repair --platform linux --host smoke-repair >/tmp/repair-plan.json

	ruby -rjson -e '
		plan = JSON.parse(File.read("/tmp/repair-plan.json"))
		abort "wrong repair mode" unless plan.fetch("mode") == "repair"
		git = plan.fetch("modules").find { |mod| mod.fetch("name") == "git" }
		abort "missing git module in repair plan" unless git
		abort "git should be repaired" if git.fetch("skipped")
		abort "repair should include git packages" unless git.fetch("packages_to_install").any? { |pkg| pkg.fetch("value") == "brew:git" }
		abort "repair should include git links" if git.fetch("links_to_create").empty?
		mc = plan.fetch("modules").find { |mod| mod.fetch("name") == "mc" }
		abort "missing mc module in repair plan" unless mc
		abort "mc should be skipped during repair" unless mc.fetch("skipped")
		abort "skipped repair module should not include copies" unless mc.fetch("copies_to_create").empty?
	'

	echo "provision smoke ok"
}

main "$@"
