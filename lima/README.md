---
all:
  level: extra
  packages:
    - lima
  links:
    default.yml: ~/.lima/default.yml
---

# Lima

Lima launches Linux virtual machines with automatic file sharing and port forwarding (similar to WSL2).

## Usage

### By Default Config

Start a default instance.

```bash
limactl start --name=default ~/.lima/default.yml
```

Destroy default instance.

```bash
limactl stop default
limactl delete default
limactl prune
```

### By CLI Options

Start an Ubuntu 26.04 instance by mounting current directory to the writable `/self` directory.

```bash
limactl start --name=ubuntu \
  --set ".mounts = [{\"location\": \"$PWD\", \"mountPoint\": \"/self\", \"writable\": true}]" \
  --set ".firmware.legacyBIOS = true" \
  https://cloud-images.ubuntu.com/resolute/current/resolute-server-cloudimg-amd64.img
```
