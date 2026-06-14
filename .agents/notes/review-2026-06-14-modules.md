# Module Review Findings

Review date: 2026-06-14
Scope: selected modules in `~/Dropbox/home` and `~/Dropbox/home-`
Changes: none (read-only review); one fix applied separately

## Fixed separately

- `fish/config.fish`: `b` bundle helper used `arg[1]` instead of `argv[2]`, so the `.envrc` setup branch checked a non-existent variable.

## Findings

### 1. SSH client config file permissions are 644

`home/ssh/config` and `home-/ssh/config.d/macos.conf` are mode `644`. SSH accepts 644 for client config, but 600 is preferred for files that may contain hostnames, usernames, or connection policy. The `ssh` Postinstall chmods `~/.ssh` and `~/.ssh/config.d` to 700 but does not set `~/.ssh/config` to 600.

Because Tilde links `~/.ssh/config` as a symlink to the repository file, SSH checks the target file permissions. Consider adding `chmod 600 ~/.ssh/config` to the Postinstall block, or setting 600 on the repository files if the deployment process preserves it.

### 2. Fish XDG variables are universal instead of global

`fish/config.fish` uses `set -U` for `XDG_CACHE_HOME`, `XDG_CONFIG_HOME`, and `XDG_DATA_HOME`. Universal variables persist in Fish's universal variable store across sessions and may outlive the config file. For environment variables that should mirror the config, `set -gx` is more predictable and respects the current shell session.

### 3. Linux module runs apt-get update twice

`linux/README.md` `Install` section calls `apt-get update` in both `generate_locales()` and `install_desktop_packages()`. Combining updates or relying on the first call would make the script slightly faster and produce less output.

### 4. macOS Screen Sharing Postinstall could document load-failed-5

The Postinstall uses `sudo launchctl load -w` and then verifies service activity. Field experience shows `launchctl load` may emit `Load failed: 5` while still succeeding; the current idempotence check handles this correctly. Adding a short inline comment about `Load failed: 5` being benign would make the behavior explicit for future readers.

## Positive observations

- `misc/todo` actions use clean symlink shortcuts (`e -> edit`, `n -> note`, `pr -> projectview`, `r -> revive`) and consistent Bash boilerplate.
- `ssh` uses `~/.ssh/config.d/*.conf` Include pattern, which works well with the private `home-/ssh/config.d/macos.conf` fragment.
- `macos` Screen Sharing Postinstall has good idempotence and error handling.
- All Bash code blocks in the reviewed modules pass `bash -n` syntax validation.
