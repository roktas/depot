---
name: fenced
description: Test fixture for fenced Markdown content in the skill-package validator.
---

# Fenced Link Fixture

This apparent link belongs to a code example and must not be resolved as package content:

```text
[example](missing.md)
```

Neither inline code such as `[example](missing-inline.md)` nor an HTML comment is package content:

<!-- [example](missing-comment.md) -->

A site-root URL is not relative to the skill package: [asset](/images/example.png).

An ordinary package link with an optional title still is: [reference](reference.md "fixture title").
