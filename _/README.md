# Support

This directory is reserved for state-free provisioning support helpers.

It is not a provisioning module, is never discovered by normal plans, and is never recorded in provisioning state.
Helpers in this directory must be idempotent because they run before state-managed provisioning can begin.

## Bootstrap

Run `bin/bootstrap` explicitly on fresh hosts before normal provisioning:

```bash
_/bin/bootstrap
```

Pass a platform only when autodetection is not appropriate:

```bash
_/bin/bootstrap linux
_/bin/bootstrap macos
```
