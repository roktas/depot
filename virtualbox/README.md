---
linux:
  level: extra
---

# VirtualBox

Extra Linux VirtualBox host installation with explicit guards.

## Linux

### Install

Install VirtualBox from Oracle's apt repository only on physical Debian or Ubuntu hosts and only when explicitly
requested.

```bash
if [[ ${PROVISION_VIRTUALBOX_HOST:-} != 1 ]]; then
	exit 0
fi

if [[ $(systemd-detect-virt 2>/dev/null || true) != none ]]; then
	exit 0
fi

if ! command -v apt-get >/dev/null; then
	exit 0
fi

# shellcheck source=/dev/null
. /etc/os-release

case ${ID:-} in
debian|ubuntu)
;;
*)
	exit 0
;;
esac

version=${PROVISION_VIRTUALBOX_VERSION:-7.2}

sudo apt-get update
sudo apt-get install -y --no-install-recommends linux-headers-"$(uname -r)"
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://www.virtualbox.org/download/oracle_vbox_2016.asc -o /etc/apt/keyrings/virtualbox.asc
sudo chmod a+r /etc/apt/keyrings/virtualbox.asc
sudo gpg --dearmor --batch --yes -o /etc/apt/keyrings/virtualbox.gpg /etc/apt/keyrings/virtualbox.asc

printf 'deb [signed-by=/etc/apt/keyrings/virtualbox.gpg] https://download.virtualbox.org/virtualbox/debian %s contrib\n' \
	"$VERSION_CODENAME" |
	sudo tee /etc/apt/sources.list.d/virtualbox.list >/dev/null

sudo apt-get update
sudo apt-get install -y --no-install-recommends "virtualbox-$version"
sudo adduser "$USER" vboxusers || true

if command -v VBoxManage >/dev/null; then
	VBoxManage setproperty machinefolder "$HOME/VirtualBox"
elif command -v vboxmanage >/dev/null; then
	vboxmanage setproperty machinefolder "$HOME/VirtualBox"
fi
```

### Configure

Install the Oracle VirtualBox Extension Pack only when explicitly requested. This may require accepting Oracle's license
terms during installation.

```bash
if [[ ${PROVISION_VIRTUALBOX_EXTPACK:-} != 1 ]]; then
	exit 0
fi

if ! command -v vboxmanage >/dev/null && ! command -v VBoxManage >/dev/null; then
	exit 0
fi

vboxmanage=$(command -v vboxmanage || command -v VBoxManage)
version=$("$vboxmanage" --version)
version=${version%r*}
extpack=Oracle_VM_VirtualBox_Extension_Pack-"$version".vbox-extpack
file=${TMPDIR:-/tmp}/"$extpack"

if "$vboxmanage" list extpacks 2>/dev/null |
	awk -v version="$version" '
		/^Pack no\. / {
			found = 0
		}
		/^Extension Packs:/ {
			next
		}
		/^Name:[[:space:]]+Oracle VM VirtualBox Extension Pack$/ {
			found = 1
		}
		/^Version:/ && found && $2 == version {
			ok = 1
		}
		END {
			exit ok ? 0 : 1
		}
	'
then
	exit 0
fi

curl -fL "https://download.virtualbox.org/virtualbox/$version/$extpack" -o "$file"
sudo "$vboxmanage" extpack install --replace "$file"
rm -f "$file"
```
