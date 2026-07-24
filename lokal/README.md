---
level: normal
---

# Lokal

Install Lokal from its source checkout and expose its command and skill.

Dropbox-backed hosts use `~/Dropbox/lokal`. Other hosts clone the repository under `~/.local/src/lokal`. The skill
link always uses the path reported by `lokal --skill`.

## Prerequisites

```bash
command -v git >/dev/null
command -v ruby >/dev/null
```

## Install

```bash
set -Eeuo pipefail
unset CDPATH

root=$HOME/.local/src/lokal
[[ ! -d $HOME/Dropbox ]] || root=$HOME/Dropbox/lokal

if [[ ! -e $root && ! -L $root ]]; then
	mkdir -p "${root%/*}"
	git clone -- https://github.com/roktas/lokal.git "$root"
fi

[[ -d $root ]] || {
	printf 'E: Lokal checkout path is not a directory: %s\n' "$root" >&2
	exit 1
}
[[ $(git -C "$root" rev-parse --is-inside-work-tree 2>/dev/null) == true ]] || {
	printf 'E: existing Lokal path is not a Git checkout: %s\n' "$root" >&2
	exit 1
}
[[ -x $root/bin/lokal ]] || {
	printf 'E: Lokal executable is missing: %s/bin/lokal\n' "$root" >&2
	exit 1
}

"$root/bin/lokal" --version >/dev/null
```

## Update

```bash
set -Eeuo pipefail
unset CDPATH

root=$HOME/.local/src/lokal
[[ ! -d $HOME/Dropbox ]] || root=$HOME/Dropbox/lokal

[[ $(git -C "$root" rev-parse --is-inside-work-tree 2>/dev/null) == true ]] || {
	printf 'E: Lokal checkout is unavailable: %s\n' "$root" >&2
	exit 1
}
[[ -z $(git -C "$root" status --porcelain --untracked-files=no) ]] || {
	printf 'E: Lokal checkout has tracked changes: %s\n' "$root" >&2
	exit 1
}

upstream=$(git -C "$root" rev-parse --abbrev-ref --symbolic-full-name '@{u}')
git -C "$root" fetch --prune
git -C "$root" merge --ff-only "$upstream"
```

## Configure

```bash
set -Eeuo pipefail
unset CDPATH

root=$HOME/.local/src/lokal
[[ ! -d $HOME/Dropbox ]] || root=$HOME/Dropbox/lokal

[[ $(git -C "$root" rev-parse --is-inside-work-tree 2>/dev/null) == true ]] || {
	printf 'E: Lokal checkout is unavailable: %s\n' "$root" >&2
	exit 1
}
[[ -x $root/bin/lokal ]] || {
	printf 'E: Lokal executable is missing: %s/bin/lokal\n' "$root" >&2
	exit 1
}

ensure_link() {
	local source=$1
	local target=$2

	if [[ -L $target ]]; then
		[[ $(readlink "$target") == "$source" ]] || {
			printf 'E: refusing to replace existing link: %s\n' "$target" >&2
			return 1
		}
		return 0
	fi

	[[ ! -e $target ]] || {
		printf 'E: refusing to replace existing path: %s\n' "$target" >&2
		return 1
	}

	ln -s "$source" "$target"
}

mkdir -p "$HOME/.local/bin" "$HOME/.agents/skills"
ensure_link "$root/bin/lokal" "$HOME/.local/bin/lokal"

skill=$(lokal --skill)
[[ $skill == /* && $skill != *$'\n'* && -f $skill/SKILL.md ]] || {
	printf 'E: lokal --skill returned an invalid path: %s\n' "$skill" >&2
	exit 1
}

ensure_link "$skill" "$HOME/.agents/skills/lokal"
```
