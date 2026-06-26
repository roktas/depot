---
level: minimal
linux:
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
	ensure_apt_line /etc/apt/apt.conf.d/99notranslations 'Acquire::Languages "none";'
	ensure_apt_line /etc/apt/apt.conf.d/01norecommends 'APT::Install-Recommends "false";'
	ensure_apt_line /etc/apt/apt.conf.d/01norecommends 'APT::Install-Suggests "false";'
}

ensure_apt_line() {
	local file=$1
	local line=$2

	[[ -f $file ]] && grep -Fxq "$line" "$file" && return 0

	sudo install -d /etc/apt/apt.conf.d
	sudo line ensure "$file" "$line"
}

graphical_host() {
	local session=${XDG_CURRENT_DESKTOP:-}${DESKTOP_SESSION:-}

	if [[ -n $session && ! $session =~ (tty|headless) ]]; then
		return 0
	fi

	if [[ $(systemctl get-default 2>/dev/null || true) == graphical.target ]]; then
		return 0
	fi

	if systemctl is-enabled gdm3 sddm lightdm display-manager 2>/dev/null |
		grep -Eq '^(enabled|static|generated|alias|indirect)$'; then
		return 0
	fi

	if [[ -s /etc/X11/default-display-manager ]]; then
		return 0
	fi

	compgen -G '/usr/share/xsessions/*.desktop' >/dev/null && return 0
	compgen -G '/usr/share/wayland-sessions/*.desktop' >/dev/null && return 0

	return 1
}

install_desktop_packages() {
	if ! graphical_host; then
		printf 'W: skipping desktop package install: no graphical Linux session detected\n' >&2
		return 0
	fi

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

install_locales() {
	sudo apt-get update
	sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends locales
}

configure_apt_policy
install_locales
install_desktop_packages
```

## Configure

```bash
configure_apt_policy() {
	command -v apt-get >/dev/null || return 0

	ensure_apt_line /etc/apt/apt.conf.d/99notranslations 'Acquire::Languages "none";'
	ensure_apt_line /etc/apt/apt.conf.d/01norecommends 'APT::Install-Recommends "false";'
	ensure_apt_line /etc/apt/apt.conf.d/01norecommends 'APT::Install-Suggests "false";'
}

configure_flatpak() {
	command -v flatpak >/dev/null || return 0

	flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo
}

generate_locales() {
	local distribution
	local locale=${PROVISION_LOCALE:-en_US.UTF-8}

	case $locale in
	C.UTF-8 | en_US.UTF-8 | tr_TR.UTF-8)
		;;
	*)
		echo >&2 "Unsupported locale: $locale"
		exit 1
		;;
	esac

	locales_ready "$locale" && return 0

	distribution=$(
		unset ID
		# shellcheck source=/dev/null
		. /etc/os-release 2>/dev/null
		echo "$ID"
	)

	case $distribution in
	debian)
		printf '%s\n' \
			"locales locales/locales_to_be_generated multiselect tr_TR.UTF-8 UTF-8, en_US.UTF-8 UTF-8, C.UTF-8 UTF-8" \
			"locales locales/default_environment_locale select $locale" |
			sudo debconf-set-selections
		sudo rm -f /etc/locale.gen
		sudo env DEBIAN_FRONTEND=noninteractive dpkg-reconfigure -f noninteractive locales
		;;
	ubuntu)
		sudo locale-gen tr_TR.UTF-8 en_US.UTF-8 C.UTF-8
		;;
	*)
		return 0
		;;
	esac

	sudo update-locale LANG="$locale"
}

ensure_apt_line() {
	local file=$1
	local line=$2

	[[ -f $file ]] && grep -Fxq "$line" "$file" && return 0

	sudo install -d /etc/apt/apt.conf.d
	sudo line ensure "$file" "$line"
}

locale_available() {
	local locale=$1

	local normalized
	normalized=${locale,,}
	normalized=${normalized/utf-8/utf8}

	locale -a 2>/dev/null | tr '[:upper:]' '[:lower:]' | sed 's/utf-8/utf8/g' | grep -Fxq "$normalized"
}

locales_ready() {
	local locale=$1

	locale_available C.UTF-8 || return 1
	locale_available en_US.UTF-8 || return 1
	locale_available tr_TR.UTF-8 || return 1
	grep -Eq "^LANG=\"?$locale\"?$" /etc/default/locale 2>/dev/null
}

load_session_environment() {
	local name
	local uid
	local value

	for name in XDG_CURRENT_DESKTOP DESKTOP_SESSION XDG_RUNTIME_DIR DBUS_SESSION_BUS_ADDRESS; do
		[[ -z ${!name:-} ]] || continue

		value=$(systemctl --user show-environment 2>/dev/null | sed -n "s/^$name=//p" | tail -n 1)
		[[ -n $value ]] || continue

		export "$name=$value"
	done

	uid=$(id -u)
	if [[ -z ${XDG_RUNTIME_DIR:-} && -d /run/user/$uid ]]; then
		export XDG_RUNTIME_DIR=/run/user/$uid
	fi

	if [[ -z ${DBUS_SESSION_BUS_ADDRESS:-} && -n ${XDG_RUNTIME_DIR:-} && -S $XDG_RUNTIME_DIR/bus ]]; then
		export DBUS_SESSION_BUS_ADDRESS=unix:path=$XDG_RUNTIME_DIR/bus
	fi
}

gnome_desktop() {
	local session=${XDG_CURRENT_DESKTOP:-}${DESKTOP_SESSION:-}

	case ${session,,} in
	*gnome*) return 0 ;;
	esac

	command -v gnome-shell >/dev/null
}

gsettings_bin() {
	if [[ -x /usr/bin/gsettings ]]; then
		printf '%s\n' /usr/bin/gsettings
		return
	fi

	command -v gsettings
}

gsettings_command() {
	local gsettings
	gsettings=$(gsettings_bin) || return

	if [[ -n ${DBUS_SESSION_BUS_ADDRESS:-} ]]; then
		"$gsettings" "$@"
	elif command -v dbus-run-session >/dev/null; then
		dbus-run-session -- "$gsettings" "$@"
	else
		"$gsettings" "$@"
	fi
}

unbind() {
	local -a args=()

	read -r -a args < <(gsettings_command list-recursively | grep "'$1'" | cut -d' ' -f-2 2>/dev/null) || true

	if (( ${#args[@]} )); then
		echo >&2 "Unbinding $1..."
		gsettings_command set "${args[@]}" "[]"
	fi
}

apply_gnome_settings() {
	gsettings_bin >/dev/null || return 0

	load_session_environment
	gnome_desktop || return 0

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
	gsettings_command set org.gnome.desktop.peripherals.keyboard repeat-interval 10
	echo >&2 "Setting keyboard delay to 250..."
	gsettings_command set org.gnome.desktop.peripherals.keyboard delay 250
}

set_timezone() {
	local timezone=${PROVISION_TIMEZONE:-Europe/Istanbul}

	command -v timedatectl >/dev/null || return 0
	[[ $(timedatectl show -p Timezone --value 2>/dev/null || true) == "$timezone" ]] && return 0

	sudo timedatectl set-timezone "$timezone"
}

configure_apt_policy
generate_locales
set_timezone
configure_flatpak
apply_gnome_settings
```
