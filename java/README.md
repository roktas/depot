---
all:
  level: extra
  links:
    bin/: ~/.local/bin
linux:
  packages:
    - java
macos:
  packages:
    - java
    - cask:openwebstart
---

# Java

Extra Java toolchain module based on OpenJDK.

## Linux

### Install

Install OpenWebStart from the latest GitHub release `.deb` asset on apt-based Linux hosts.

```bash
if ! command -v apt-get >/dev/null; then
	exit 0
fi

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT HUP INT TERM

gh release download \
	--repo karakun/OpenWebStart \
	--pattern 'OpenWebStart_linux_*.deb' \
	--dir "$tmpdir"

sudo apt install -y "$tmpdir"/OpenWebStart_linux_*.deb
```

## KamuSM

Use the `java-` wrapper to run `.jar` files downloaded via OpenWebStart for KamuSM signatures:

```bash
java- -jar KamuSMKilitCozme.jar
```

## MacOS

### Configure

```bash
command -v brew >/dev/null || exit 0

prefix=$(brew --prefix openjdk 2>/dev/null || brew --prefix java 2>/dev/null || true)
source=${prefix:+$prefix/libexec/openjdk.jdk}
target=/Library/Java/JavaVirtualMachines/openjdk.jdk

[[ -n $source && -e $source ]] || exit 0
[[ -L $target && $(readlink "$target") == "$source" ]] && exit 0

if [[ -e $target && ! -L $target ]]; then
	printf 'E: %s exists and is not a symlink\n' "$target" >&2
	exit 1
fi

sudo install -d "$(dirname "$target")"
sudo ln -sfn "$source" "$target"
```
