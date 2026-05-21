---
all:
  level: extra
  packages:
    - lima
    - liman
  links:
    default.yml: ~/.lima/default.yml
---

# Lima

Lima launches Linux virtual machines with automatic file sharing and port forwarding (similar to WSL2).

## Usage

### Project Helper

Use the external `"there"` helper from Liman for project-local test instances.

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

Start an Ubuntu 26.04 instance by mounting current directory to the writable `/here` directory.

```bash
limactl start --name=ubuntu \
  --set ".mounts = [{\"location\": \"$PWD\", \"mountPoint\": \"/here\", \"writable\": true}]" \
  --set ".firmware.legacyBIOS = true" \
  https://cloud-images.ubuntu.com/resolute/current/resolute-server-cloudimg-amd64.img
```
