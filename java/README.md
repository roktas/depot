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

## MacOS

### Postinstall

```bash
sudo ln -sfn /opt/homebrew/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
```
