---
all:
  level: extra
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

runner_bindir="$root/bin"
platform_bindir="$root/tex/texmf-$platform/bin"
mtxrun="$runner_bindir/mtxrun"
luametatex="$platform_bindir/luametatex"

context_installed() {
	[[ -x $mtxrun && -x $luametatex ]]
}

install_context() {
	for command in curl unzip; do
		if ! command -v "$command" >/dev/null; then
			printf "Missing command: %s\n" "$command" >&2
			exit 1
		fi
	done

	mkdir -p "$root"

	tmpdir=$(mktemp -d)
	trap 'rm -rf "$tmpdir"' EXIT HUP INT TERM

	curl \
		--fail \
		--location \
		--show-error \
		--output "$tmpdir/$archive" \
		"$base_url/$archive"

	unzip -oq "$tmpdir/$archive" -d "$root"

	chmod +x "$root/install.sh"

	(
		cd "$root" || exit
		./install.sh
	)
}

context_installed || install_context

for source in "$mtxrun" "$luametatex"; do
	if [[ ! -x $source ]]; then
		printf "Expected executable not found: %s\n" "$source" >&2
		exit 1
	fi
done

mkdir -p "$bindir"
ln -sfn "$luametatex" "$bindir/luametatex"

cat > "$bindir/mtxrun" <<EOF
#!/bin/sh

set -eu
unset CDPATH

root=\${CONTEXT_ROOT:-"$root"}
texroot="\$root/tex"

exec "\$root/bin/mtxrun" --tree="\$texroot" "\$@"
EOF

chmod +x "$bindir/mtxrun"

cat > "$runner_bindir/context" <<EOF
#!/bin/sh

set -eu
unset CDPATH

root=\${CONTEXT_ROOT:-"$root"}
texroot="\$root/tex"
texmf="\$texroot/texmf-context:\$texroot/texmf"

for tree in "\$texroot"/texmf-*; do
	if [ -d "\$tree" ]; then
		texmf="\$texmf:\$tree"
	fi
done

export TEXMF=\${TEXMF:-"\$texmf"}

exec "\$root/bin/mtxrun" --tree="\$texroot" --script context "\$@"
EOF

chmod +x "$runner_bindir/context"
ln -sfn "$runner_bindir/context" "$bindir/context"

printf "ConTeXt installed in %s\n" "$root"
printf "Commands installed into %s\n" "$bindir"

"$bindir/context" --version >/dev/null
```
