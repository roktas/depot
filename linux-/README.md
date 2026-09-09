---
all:
  level: extra
linux:
  packages:
    - flatpak:com.calibre_ebook.calibre
---

# Linux Variant

Extra Linux system provisioning for optional, guarded host capabilities and Linux-only desktop tools.

## Install

### Firewall

Install UFW and configure allowed services. The firewall is enabled only when explicitly requested.

```bash
if [[ ${PROVISION_LINUX_FIREWALL:-} != 1 ]]; then
	exit 0
fi

if ! command -v apt-get >/dev/null; then
	exit 0
fi

sudo apt-get update
sudo apt-get install -y --no-install-recommends ufw

firewall_allow=${PROVISION_FIREWALL_ALLOW:-ssh http https}

for service in $firewall_allow; do
	sudo ufw allow "$service"
done

if [[ ${PROVISION_FIREWALL_ENABLE:-} == 1 ]]; then
	sudo ufw --force enable
fi
```

### Docker

Install Docker Engine from Docker's apt repository. This is extra/manual Linux system provisioning.

```bash
if [[ ${PROVISION_LINUX_DOCKER:-} != 1 ]]; then
	exit 0
fi

if ! command -v apt-get >/dev/null; then
	exit 0
fi

# shellcheck source=/dev/null
. /etc/os-release

sudo apt-get update
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL "https://download.docker.com/linux/$ID/gpg" -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

arch=$(dpkg --print-architecture)
printf 'deb [arch=%s signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/%s %s stable\n' \
	"$arch" "$ID" "$VERSION_CODENAME" |
	sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

sudo apt-get update
sudo apt-get install -y --no-install-recommends \
	containerd.io \
	docker-buildx-plugin \
	docker-ce \
	docker-ce-cli \
	docker-compose-plugin

sudo adduser "$USER" docker || true
```

### Laptop

Install laptop-oriented networking and power tools. This is extra/manual Linux system provisioning.

```bash
if [[ ${PROVISION_LINUX_LAPTOP:-} != 1 ]]; then
	exit 0
fi

if ! command -v apt-get >/dev/null; then
	exit 0
fi

sudo apt-get update
sudo apt-get install -y --no-install-recommends \
	avahi-autoipd \
	bluetooth \
	iw \
	powertop \
	wireless-tools \
	wpasupplicant
```

### Printer

Install printer support. This is extra/manual Linux system provisioning.

```bash
if [[ ${PROVISION_LINUX_PRINTER:-} != 1 ]]; then
	exit 0
fi

if ! command -v apt-get >/dev/null; then
	exit 0
fi

sudo apt-get update
sudo apt-get install -y \
	cups \
	cups-bsd \
	cups-client \
	foomatic-db-engine \
	hp-ppd \
	hplip \
	openprinting-ppds \
	printer-driver-all
```

### VPN

Install NetworkManager OpenVPN integration. This is extra/manual Linux system provisioning.

```bash
if [[ ${PROVISION_LINUX_VPN:-} != 1 ]]; then
	exit 0
fi

if ! command -v apt-get >/dev/null; then
	exit 0
fi

sudo apt-get update
sudo apt-get install -y --no-install-recommends network-manager-openvpn-gnome
```

### VM Cleanup

Run image cleanup only in virtual machines and only when explicitly requested.

```bash
if [[ ${PROVISION_LINUX_VM_CLEAN:-} != 1 ]]; then
	exit 0
fi

if [[ $(systemd-detect-virt 2>/dev/null || true) == none ]]; then
	exit 0
fi

if command -v apt-get >/dev/null; then
	sudo find /etc/apt -type f -name '*.list.save' -exec rm -f {} +
	sudo apt-get -y autoremove --purge || true
	sudo apt-get -y autoclean || true
	sudo apt-get -y clean || true
fi

sudo find /var/cache -type f -delete || true
sudo find /var/log -type f -exec truncate -s 0 {} + || true
sudo rm -f /var/lib/dhcp/* || true
```

## Notes

### Canon G6000 series (USB)

Use `ipp-usb` on the loopback interface and create a direct CUPS IPP queue. This avoids the auto-discovered
`implicitclass://` queue that can hang GNOME's print dialog.

In `/etc/ipp-usb/ipp-usb.conf`, use:

```ini
[network]
interface = loopback
dns-sd = disable
```

The printer endpoint is `ipp://localhost:60000/ipp/print`. Use the `everywhere` driver and set the direct queue as the
default:

```bash
sudo lpadmin -p Canon_G6000_series_USB -E \
	-v ipp://localhost:60000/ipp/print -m everywhere
lpoptions -d Canon_G6000_series_USB
```

The relevant services are `cups`, `cups-browsed`, and `ipp-usb`.
