---
name: humanizer
description: Remove clustered AI-writing habits without flattening the author's voice or changing meaning. Use when the user asks to humanize, de-AI, remove AI tone or slop, make prose sound natural, or when a writing workflow selects a humanizing pass for substantive prose. Do not use as an AI detector or to rewrite code, quotations, citations, identifiers, or metadata-only content.
license: MIT
metadata:
  source: https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing
  version: "2.10.0"
---

# Humanizer

Make prose sound like the intended author in the intended genre. Remove recurring machine-like habits, but do not
replace them with a fabricated personality.

## Priorities

Apply these authorities in order:

1. The user's explicit request and preservation constraints
2. Project, publication, genre, and language rules
3. A supplied author sample or clearly established voice
4. The input's meaning, evidence, uncertainty, register, and useful structure
5. The generic pattern guidance below

Higher-priority rules override lower-priority heuristics. When another skill invokes `humanizer`, follow that skill's
file, authority, and output contract.

Preserve:

- Facts, claims, qualifications, uncertainty, citations, and source relationships
- Technical terms, identifiers, proper names, quotations, code, and deliberate formatting
- Distinctive details, defensible opinions, mixed feelings, asides, and irregular rhythm already present
- Coverage and rhetorical purpose; paragraph count and sentence structure may change when coherence improves

Never invent a fact, anecdote, opinion, reaction, first-person experience, quotation, citation, or biographical detail
to make the text feel human.

## Workflow

1. Read the complete editable text and any voice sample before rewriting.
2. Establish the genre, audience, language, register, and protected material. If any is explicit, do not guess a
   replacement.
3. Find clusters of the patterns below. A single watched word or punctuation mark is not enough.
4. Before a substantial rewrite, a passage with several cluster types, or a case where false positives are plausible,
   read [examples.md](references/examples.md) completely. For a short edit with one obvious cluster, the rules here are
   sufficient.
5. Plan the smallest coherent edits that remove those clusters while preserving the text's obligations and voice.
6. Rewrite once, then audit the result internally for lost meaning, changed claim strength, fabricated detail,
   flattened voice, repetitive rhythm, and remaining pattern clusters.
7. Return the final rewrite only, unless the user asks for diagnosis, a comparison, or an edit summary. If no
   meaningful cluster exists, say that no humanizing change is needed instead of rewriting for activity's sake.

Do not expose draft-and-critique scaffolding merely to prove that the pass occurred.

## Pattern clusters

Treat these as diagnostic signals, not banned forms.

### Inflated content

- Unearned claims of significance, legacy, notability, cultural importance, or broad historical meaning
- Promotional language such as `vibrant`, `breathtaking`, `renowned`, `must-visit`, or `groundbreaking` without evidence
- Participial tails that add vague analysis: `highlighting`, `underscoring`, `reflecting`, `showcasing`, `fostering`
- Generic `Challenges`, `Future outlook`, or conclusion sections that repeat abstractions instead of adding facts
- Lists of media mentions, followers, or authorities used as substitutes for a relevant supported point

Remove empty intensifiers, but restate the underlying claim directly and at the same strength. Do not infer that a claim
lacks support merely because its evidence is absent from an isolated excerpt. Qualify or remove a claim only when the
user authorizes substantive editing and the supplied context establishes that it is unsupported; otherwise preserve it
or flag it separately. Never make up a source or specific detail.

### Vague or evasive language

- Unnamed authorities: `experts argue`, `observers note`, `industry reports`, `some critics`
- Speculative gap filling about undocumented people or events
- Knowledge-cutoff disclaimers or paragraphs about the absence of information
- Excessive hedging, filler, abstract nouns, and elaborate substitutes for `is`, `has`, or a direct verb
- False ranges such as `from X to Y` when the endpoints do not form a meaningful scale

Name and cite an authority only when the source is available. Without that source, preserve the original attribution
and uncertainty rather than turning the claim into the narrator's assertion or deleting it. If substantive source
cleanup is in scope and the supplied context establishes that the attribution is a placeholder, flag or revise it
without inventing a replacement.

### Formulaic rhetoric

- Repeated negative pivots: `not only ... but`, `not just X; it is Y`, or clipped `no guessing` tails
- Forced groups of three, synonym cycling, and mechanically balanced sentences
- Authority poses such as `the real question`, `at its core`, `what really matters`, or `the deeper issue`
- Generic signposting: `let's dive in`, `here's what you need to know`, `now let's explore`
- Aphorism templates such as `X is the language of Y` or `X is not a tool but a mirror`
- Manufactured punchlines, repeated sentence fragments, and theatrical openers such as `Honestly?` or `Here's the thing`
- Generic upbeat endings that add no concrete consequence or next step

State the point directly. Vary rhythm only where the content calls for it; do not manufacture roughness or fragments as
proof of humanity.

### Mechanical structure and formatting

- Repeated bold-label lists when ordinary prose or a simple list would read better
- A heading followed by a one-line restatement before the real content
- Unnecessary title case, emoji decoration, or chat-style framing carried into document prose
- Documentation that narrates a recent diff instead of describing the current system
- Uniform punctuation or compound-word choices that conflict with the language or publication style

Do not impose a universal punctuation ban. Em dashes, en dashes, curly quotes, title case, emojis, passive voice, and
bold text can all be correct. Change them only when they participate in a repeated formula, contradict the applicable
style, or were explicitly prohibited.

### Chat and approval artifacts

- `Of course`, `Certainly`, `Great question`, `You're absolutely right`, `I hope this helps`
- Offers to continue, expand, or provide examples embedded in the deliverable
- Sycophantic agreement or praise that replaces analysis

Remove these from document prose. Keep genuine salutations and correspondence conventions when the text is actually a
message or letter.

## Voice calibration

When the user supplies a sample, match observable choices rather than stereotypes:

- Sentence length and cadence
- Vocabulary and level of formality
- Paragraph openings and transitions
- Punctuation, parenthetical asides, repetition, and preferred degree of directness

Do not copy unrelated claims or verbal tics mechanically. When no sample exists, preserve the input's defensible voice
and make it plainer; do not default to an opinionated first-person persona.

Use genre-specific restraint:

- Keep technical, academic, legal, encyclopedic, and reference prose neutral unless its contract says otherwise.
- In personal or editorial prose, retain personality already supported by the text or sample; do not invent one.
- In UI text and documentation, favor clarity and stable terminology over conversational color.
- For non-English prose, apply the same structural principles through the relevant language skill. Do not transplant an
  English watch list as literal translation rules.

## False positives

Do not flag a passage solely because it has polished grammar, formal vocabulary, passive voice, a common transition,
one em dash, curly quotes, a three-item list, a short emphatic sentence, or a familiar compound adjective. Quotations,
titles, proper names, examples, templates, and house style can legitimately contain watched forms.

Look for repetition plus functional weakness: several signals should make the prose vaguer, more inflated, more
uniform, or less faithful to its intended voice. If an edit would only make a human choice more generic, keep the
original. Use the preservation cases in [examples.md](references/examples.md) when punctuation, passive voice, or
personal cadence may be legitimate.

## Output

- For a rewrite request, return the final rewritten text in the requested format.
- For a review request, identify specific clustered patterns and their effects; rewrite only when requested or clearly
  included in the task.
- For a comparison request, show only the level of before/after detail the user needs.
- Keep explanations outside the rewritten artifact unless the artifact itself calls for them.

This guidance adapts pattern categories documented by Wikipedia's WikiProject AI Cleanup. It is an editing checklist,
not evidence that a person or model authored a particular text.
