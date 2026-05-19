---
all:
  level: minimal
---

# Linux

## Install

### APT Policy

Apply a small apt baseline only on apt-based systems.

```bash
if ! command -v apt-get >/dev/null; then
	exit 0
fi

sudo install -d /etc/apt/apt.conf.d
printf '%s\n' 'Acquire::Languages "none";' | sudo tee /etc/apt/apt.conf.d/99notranslations >/dev/null
printf '%s\n' 'APT::Install-Recommends "false";' 'APT::Install-Suggests "false";' |
	sudo tee /etc/apt/apt.conf.d/01norecommends >/dev/null
```

### Locale

Generate English and Turkish UTF-8 locales when the system uses Debian or Ubuntu locale tooling.

```bash
if ! command -v apt-get >/dev/null; then
	exit 0
fi

locale=${PROVISION_LOCALE:-en_US.UTF-8}

case :en_US.UTF-8:tr_TR.UTF-8: in
*:"$locale":*)
;;
*)
	echo >&2 "Unsupported locale: $locale"
	exit 1
;;
esac

sudo apt-get update
sudo apt-get install -y --no-install-recommends locales

distribution=$(unset ID && . /etc/os-release 2>/dev/null && echo "$ID")

case $distribution in
debian)
	printf '%s\n' \
		"locales locales/locales_to_be_generated multiselect tr_TR.UTF-8 UTF-8, en_US.UTF-8 UTF-8" \
		"locales locales/default_environment_locale select $locale" |
		sudo debconf-set-selections
	sudo rm -f /etc/locale.gen
	sudo dpkg-reconfigure -f noninteractive locales
;;
ubuntu)
	sudo locale-gen tr_TR.UTF-8 en_US.UTF-8
;;
*)
	exit 0
;;
esac

sudo update-locale LANG="$locale"
```

### Timezone

Set the system timezone when `timedatectl` is available.

```bash
timezone=${PROVISION_TIMEZONE:-Europe/Istanbul}

if ! command -v timedatectl >/dev/null; then
	exit 0
fi

sudo timedatectl set-timezone "$timezone"
```

### Desktop Packages

Install baseline Linux desktop packages.

```bash
if ! command -v apt-get >/dev/null; then
	exit 0
fi

sudo apt-get update
sudo apt-get install -y --no-install-recommends \
	flatpak \
	remmina \
	remmina-plugin-rdp \
	wl-clipboard
```

### Flatpak

Configure Flathub for per-user Flatpak installs.

```bash
if ! command -v flatpak >/dev/null; then
	if ! command -v apt-get >/dev/null; then
		exit 0
	fi

	sudo apt-get update
	sudo apt-get install -y --no-install-recommends flatpak
fi

flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo
```

### GNOME

Apply GNOME desktop settings only when a GNOME session is available.

```bash
if ! command -v gsettings >/dev/null || ! command -v xdg-mime >/dev/null; then
	exit 0
fi

if [[ ${XDG_CURRENT_DESKTOP:-} != *GNOME* && ${DESKTOP_SESSION:-} != *gnome* ]]; then
	exit 0
fi

unbind() {
	local -a args=()

	read -r -a args < <(gsettings list-recursively | grep "'$1'" | cut -d' ' -f-2 2>/dev/null) || true

	if (( ${#args[@]} )); then
		echo >&2 "Unbinding $1..."
		gsettings set "${args[@]}" "[]"
	fi
}

unbind "F1" ; unbind "<Shift>F1" ; unbind "<Alt>F1"
unbind "F2" ; unbind "<Shift>F2" ; unbind "<Alt>F2"
unbind "F3" ; unbind "<Shift>F3" ; unbind "<Alt>F3"
unbind "F4" ; unbind "<Shift>F4" ; unbind "<Alt>F4"
unbind "F5" ; unbind "<Shift>F5" ; unbind "<Alt>F5"
unbind "F6" ; unbind "<Shift>F6" ; unbind "<Alt>F6"
unbind "F7" ; unbind "<Shift>F7" ; unbind "<Alt>F7"
unbind "F8" ; unbind "<Shift>F8" ; unbind "<Alt>F8"
unbind "F9" ; unbind "<Shift>F9" ; unbind "<Alt>F9"
unbind "F10"; unbind "<Shift>F10"; unbind "<Alt>F10"
unbind "F12"; unbind "<Shift>F12"; unbind "<Alt>F12"

unbind "<Alt>Space"; unbind "<Alt>space"
unbind "<Alt>Above_Tab"; unbind "<Super>Above_Tab"

echo >&2 "Setting keyboard repeat interval to 10..."
gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 10
echo >&2 "Setting keyboard delay to 250..."
gsettings set org.gnome.desktop.peripherals.keyboard delay 250

gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name 'Flameshot'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command 'sh -c -- "flameshot gui"'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding '<Control>Print'
```
