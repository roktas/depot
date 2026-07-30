# Directives

## Contents

- [Syntax and identity](#syntax-and-identity)
- [PRESERVE](#preserve)
- [ENSURE](#ensure)
- [AVOID](#avoid)
- [TERM](#term)
- [SOURCE](#source)
- [CITE](#cite)
- [QUESTION](#question)
- [FIGURE](#figure)
- [TABLE](#table)
- [EXAMPLE](#example)

## Syntax and identity

Use GFM-alert-like blockquote directives:

```markdown
> [!TYPE]
> Directive content.

> [!TYPE:stable-id]
> Directive content.
```

Apply these rules:

- Write `TYPE` in uppercase.
- Use a stable ID only when the obligation needs identity across revisions.
- Write IDs as short lowercase slugs and keep them unique within the seed.
- Treat the same ID as the same obligation across revisions. Report duplicate
  IDs or reuse of one ID with a different directive type.
- Treat a changed or removed ID as loss of identity continuity; do not guess
  that it still names an earlier obligation.
- End a directive with its blockquote.
- Scope it to the nearest preceding heading and that heading's section unless
  the directive content states another scope.
- Do not nest directives.
- Do not copy directive wrappers into `TEXT.md`.
- Report unknown directive types instead of ignoring them.

Supported directives are:

```text
PRESERVE
ENSURE
AVOID
TERM
SOURCE
CITE
QUESTION
FIGURE
TABLE
EXAMPLE
```

## PRESERVE

```markdown
> [!PRESERVE]
> This wording must remain highly faithful.
```

Create a wording-sensitive obligation.

When the target language matches the seed passage, preserve the wording as
closely as grammar and integration permit. When the target language differs,
translate with high fidelity while preserving meaning, claim strength, scope,
qualification, uncertainty, emphasis, and rhetorical function.

Do not freely paraphrase, generalize, strengthen, weaken, or silently omit the
passage. Allow only small grammatical or connective changes needed to
integrate it into the surrounding text.

## ENSURE

```markdown
> [!ENSURE]
> Explain that manually drawn elements can later enter the programmatic
> workflow.
```

Create a content-sensitive obligation.

Make the required idea, distinction, argument, qualification, or coverage
appear in the master. Do not treat the supplied wording as publication-ready
by default. Develop, expand, restructure, split, combine, translate, or
relocate it as needed.

Preserve its intended meaning, evidential status, uncertainty, and claim
strength. Never invent support.

## AVOID

```markdown
> [!AVOID]
> Do not present the system as a replacement for vector drawing applications.
```

Create a negative requirement.

Avoid the named claim, framing, term, implication, structure, or stylistic
behavior. Treat `AVOID` as binding, not as a weak preference.

If an existing human edit conflicts with `AVOID`, attempt a minimal
reconciliation. Report the conflict when both cannot be satisfied safely.

## TERM

```markdown
> [!TERM]
> Keep `derender` lowercase and formatted as code.
```

Define terminology behavior, including:

- Required term or spelling
- Capitalization
- Translation or non-translation
- First-use form
- Abbreviation
- Formatting
- Prohibited alternatives

Apply it consistently within its stated scope.

## SOURCE

```markdown
> [!SOURCE:benchmark-results]
> Use `results/benchmark.csv` in the performance discussion.
```

Require the named source or source group to be inspected and used
substantively. Resolve relative paths from the project root unless the source
pool establishes another resolvable identity.

`SOURCE` does not itself require a bibliographic citation. The source may be a
data file, note, image, draft, terminology document, transcript, or other
working material.

Report a missing, unreadable, irrelevant, or contradictory required source.
Never invent its content.

## CITE

```markdown
> [!CITE:smith-2025]
> Compare the method with Smith et al. and cite the source in this section.
```

Require an explicit citation in the master and any relevant derived output.

Inspect the source and verify that it supports the associated statement. Do
not add a citation merely because a title or identifier looks relevant. Never
invent bibliographic data, page numbers, quotations, results, or support.

If citation syntax or bibliography management is project-specific, follow
`AGENTS.md`, the selected output format, and relevant auxiliary skills.

## QUESTION

```markdown
> [!QUESTION:performance-scope]
> Should a performance comparison be included?
```

Record an unresolved human decision.

Do not copy the question into the master or final output unless the document
itself is intended to present it as a research question. Resolve it only when
the seed, sources, project instructions, or explicit user direction provide a
sound answer.

When unresolved, continue conservatively where possible and report the open
decision. Do not invent a decision that materially changes the document.

## FIGURE

```markdown
> [!FIGURE:workflow]
> Show the path from Inkscape SVG through `derender` to the final output.
```

Require a figure.

Develop its supported role, placement, intended interpretation, caption,
labels, and asset requirements. Follow project and output-format instructions
for implementation.

Report missing assets or evidence. Do not fabricate data or depict unsupported
results.

## TABLE

```markdown
> [!TABLE:comparison]
> Compare manual, programmatic, and hybrid production.
```

Require a table.

Determine its useful dimensions, placement, caption, labels, and relationship
to the surrounding argument. Use only supported data and distinctions.

## EXAMPLE

```markdown
> [!EXAMPLE:hybrid-shape]
> Show how a manually drawn SVG element becomes part of a script.
```

Require an example.

Develop enough context for the example to perform its intended explanatory or
evidential role. Do not invent executable behavior, data, or results.
