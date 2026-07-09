---
all:
  level: extra
  links:
    bin/context: ~/.local/bin/context
    bin/mtxrun: ~/.local/bin/mtxrun
  packages:
    - pandoc
    - texlive
    - unzip
---

# TeX

Extra TeX publishing toolchain with TeX Live and Pandoc.

## Install

Install ConTeXt LMTX from Pragma ADE. Homebrew's `context` package is an unrelated macOS application.

```bash
root=${CONTEXT_ROOT:-"$HOME/.local/share/context"}
bindir="$HOME/.local/bin"
base_url="https://lmtx.pragma-ade.nl/install-lmtx"

os=$(uname -s)
machine=$(uname -m)

case "$os:$machine" in
Linux:x86_64 | Linux:amd64)
	archive="context-linux-64.zip"
	platform="linux-64"
	;;

Linux:aarch64 | Linux:arm64)
	archive="context-linux-aarch64.zip"
	platform="linux-aarch64"
	;;

Darwin:arm64)
	archive="context-osx-arm64.zip"
	platform="osx-arm64"
	;;

Darwin:x86_64 | Darwin:amd64)
	archive="context-osx-64.zip"
	platform="osx-64"
	;;

*)
	printf "Unsupported platform: %s/%s\n" "$os" "$machine" >&2
	exit 1
	;;
esac

platform_bindir="$root/tex/texmf-$platform/bin"
context="$platform_bindir/context"
mtxrun="$platform_bindir/mtxrun"
luametatex="$platform_bindir/luametatex"

context_installed() {
	[[ -x $context && -x $mtxrun && -x $luametatex ]] || return 1

	case $(file -bL "$luametatex" 2>/dev/null || true) in
	ELF* | Mach-O*)
		;;
	*)
		return 1
		;;
	esac

	"$context" --version >/dev/null 2>&1 &&
		"$mtxrun" --version >/dev/null 2>&1
}

install_context() {
	for command in curl unzip; do
		if ! command -v "$command" >/dev/null; then
			printf "Missing command: %s\n" "$command" >&2
			exit 1
		fi
	done

	tmpdir=$(mktemp -d)
	trap 'rm -rf "$tmpdir"' EXIT HUP INT TERM

	mkdir -p "$root"

	curl \
		--fail \
		--location \
		--show-error \
		--output "$tmpdir/$archive" \
		"$base_url/$archive"

	rm -f "$context" "$mtxrun" "$luametatex"

	unzip -oq "$tmpdir/$archive" -d "$root"

	chmod +x "$root/install.sh"

	(
		cd "$root" || exit
		./install.sh
	)
}

context_installed || install_context

for source in "$context" "$mtxrun" "$luametatex"; do
	if [[ ! -x $source ]]; then
		printf "Expected executable not found: %s\n" "$source" >&2
		exit 1
	fi
done

mkdir -p "$bindir"
ln -sfn "$luametatex" "$bindir/luametatex"

printf "ConTeXt installed in %s\n" "$root"
printf "LuaMetaTeX installed into %s\n" "$bindir"

"$context" --version >/dev/null 2>&1
"$mtxrun" --version >/dev/null 2>&1
```
