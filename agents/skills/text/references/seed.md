# Seed Regions

`TEXT-.md` may contain two top-level regions:

```markdown
=== OUTLINE ===

# Introduction

- Establish the problem.
  - Explain the limitations of existing approaches.
- Introduce the proposed approach only afterward.

# Method

A free-form description of the intended reasoning and section flow.

=== CONTENT ===

# Introduction

Source prose and directives begin here.
```

The exact region markers are:

```text
=== OUTLINE ===
=== CONTENT ===
```

Apply these rules:

- Put each marker alone on an unindented line.
- Use each region at most once.
- Put `OUTLINE` before `CONTENT`.
- Ignore marker-like text inside fenced code blocks.
- Require `CONTENT` when `OUTLINE` is present.
- When no marker exists, treat the entire body after frontmatter as `CONTENT`.
- Allow `CONTENT` without `OUTLINE`, although the marker is unnecessary.
- Never copy region markers into `TEXT.md` or a derived output.

## OUTLINE

Allow free-form steering in `OUTLINE`, including Markdown headings, nested
lists, short paragraphs, tables, examples, and notes about order, emphasis,
scope, or reasoning.

Treat its structure as intended document flow and coverage, not as
publication-ready prose. Expand, combine, or reorganize it when necessary
without losing its intended progression, hierarchy, emphasis, or exclusions.
Do not copy it mechanically into the master.

## CONTENT

Interpret `CONTENT` as follows:

- Headings are proposed structural anchors for the master.
- Unmarked prose, lists, quotations, code blocks, and other Markdown elements
  are preferred source material.
- Directives create explicit obligations, constraints, or requested content
  elements.

Give unmarked content a strong presumption of use, but not an absolute
obligation. Translate, rewrite, expand, shorten, merge, move, or omit it when
repetition, conflict, weak evidence, low value, or document structure justifies
the change.

Do not silently lose unique and meaningful unmarked content. Preserve its
substance or report why it was not used.
