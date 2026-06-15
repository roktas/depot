---
all:
  level: minimal
  packages:
    - ca-certificates
    - curl
    - gh
    - gnupg
    - zoxide
---

# Linux

Minimal Linux platform baseline for apt policy, locale, timezone, desktop packages, fonts, Flatpak, GNOME settings, and
shared command-line tools needed by later Linux module `Install` sections.

## Install

```bash
if ! command -v apt-get >/dev/null; then
	exit 0
fi

configure_apt_policy() {
	sudo install -d /etc/apt/apt.conf.d
	sudo line ensure /etc/apt/apt.conf.d/99notranslations 'Acquire::Languages "none";'
	sudo line ensure /etc/apt/apt.conf.d/01norecommends 'APT::Install-Recommends "false";'
	sudo line ensure /etc/apt/apt.conf.d/01norecommends 'APT::Install-Suggests "false";'
}

configure_flatpak() {
	command -v flatpak >/dev/null || return 0

	flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo
}

generate_locales() {
	local distribution
	local locale=${PROVISION_LOCALE:-en_US.UTF-8}

	case :en_US.UTF-8:tr_TR.UTF-8: in
	*:"$locale":*)
		;;
	*)
		echo >&2 "Unsupported locale: $locale"
		exit 1
		;;
	esac

	sudo apt-get update
	sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends locales

	distribution=$(unset ID && . /etc/os-release 2>/dev/null && echo "$ID")

	case $distribution in
	debian)
		printf '%s\n' \
			"locales locales/locales_to_be_generated multiselect tr_TR.UTF-8 UTF-8, en_US.UTF-8 UTF-8" \
			"locales locales/default_environment_locale select $locale" |
			sudo debconf-set-selections
		sudo rm -f /etc/locale.gen
		sudo env DEBIAN_FRONTEND=noninteractive dpkg-reconfigure -f noninteractive locales
		;;
	ubuntu)
		sudo locale-gen tr_TR.UTF-8 en_US.UTF-8
		;;
	*)
		return 0
		;;
	esac

	sudo update-locale LANG="$locale"
}

graphical_host() {
	[[ $(systemctl get-default 2>/dev/null || true) == graphical.target ]] || return 1
	systemctl is-enabled gdm3 sddm lightdm display-manager 2>/dev/null | grep -q enabled
}

install_desktop_packages() {
	graphical_host || return 0

	sudo apt-get update
	sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
		avahi-daemon \
		flatpak \
		fonts-spleen \
		remmina \
		remmina-plugin-rdp \
		wl-clipboard \
		xdg-utils
}

set_timezone() {
	local timezone=${PROVISION_TIMEZONE:-Europe/Istanbul}

	command -v timedatectl >/dev/null || return 0

	sudo timedatectl set-timezone "$timezone"
}

unbind() {
	local -a args=()

	read -r -a args < <(gsettings list-recursively | grep "'$1'" | cut -d' ' -f-2 2>/dev/null) || true

	if (( ${#args[@]} )); then
		echo >&2 "Unbinding $1..."
		gsettings set "${args[@]}" "[]"
	fi
}

apply_gnome_settings() {
	command -v gsettings >/dev/null || return 0
	command -v xdg-mime >/dev/null || return 0

	if [[ ${XDG_CURRENT_DESKTOP:-} != *GNOME* && ${DESKTOP_SESSION:-} != *gnome* ]]; then
		return 0
	fi

	unbind "F1"; unbind "<Shift>F1"; unbind "<Alt>F1"
	unbind "F2"; unbind "<Shift>F2"; unbind "<Alt>F2"
	unbind "F3"; unbind "<Shift>F3"; unbind "<Alt>F3"
	unbind "F4"; unbind "<Shift>F4"; unbind "<Alt>F4"
	unbind "F5"; unbind "<Shift>F5"; unbind "<Alt>F5"
	unbind "F6"; unbind "<Shift>F6"; unbind "<Alt>F6"
	unbind "F7"; unbind "<Shift>F7"; unbind "<Alt>F7"
	unbind "F8"; unbind "<Shift>F8"; unbind "<Alt>F8"
	unbind "F9"; unbind "<Shift>F9"; unbind "<Alt>F9"
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
}

configure_apt_policy
generate_locales
set_timezone
install_desktop_packages
configure_flatpak
apply_gnome_settings
```
