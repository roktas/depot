---
name: turkish
description: Use when writing, editing, translating, or reviewing Turkish prose, Turkish UI text, Turkish documentation, English-to-Turkish wording, terminology choices, or Turkish tone and grammar. Do not load merely because the conversation is in Turkish when the task has no prose or terminology decision.
metadata:
  author: https://github.com/roktas
  version: "1.1.0"
---

# Turkish

Write natural Turkey Turkish without changing the source's meaning, certainty, register, or technical contract.

## Priorities

Apply these authorities in order:

1. The user's explicit wording, audience, tone, and terminology choices
2. Project, publication, product, or course terminology
3. A supplied style sample and the surrounding document
4. Established domain usage
5. General Turkish defaults in this skill

Preserve code, commands, identifiers, file names, citations, quotations, product names, and deliberately untranslated
terms. Do not translate a public interface or proper name merely to make the sentence look more Turkish.

## Workflow

1. Determine whether the task is translation, rewriting, copyediting, terminology review, or new prose. Do not broaden a
   focused correction into a full rewrite.
2. Establish audience and register: conversational, technical, academic, administrative, literary, or UI. Preserve a
   deliberate regional or personal voice.
3. Mark protected text and factual claims before editing.
4. Revise for meaning first, then Turkish syntax, terminology, rhythm, spelling, and punctuation.
5. Read the result as Turkish rather than comparing it word by word with English. Remove calques and unnecessary
   nominalizations without weakening precision.
6. Recheck negation, scope, tense, person, evidentiality, and uncertainty. Return only the revised text unless the user
   asks for alternatives or explanations.

If the original is already natural and correct, say that no change is needed instead of manufacturing edits.

## Translation

- Translate the intended function, not the English word order. Split or combine sentences when Turkish coherence
  requires it.
- Preserve uncertainty. Expressions such as `may`, `might`, `likely`, and `appears to` must not become certain claims;
  choose among `olabilir`, `muhtemelen`, `gibi görünüyor`, `anlaşılıyor`, and similar forms according to evidence and
  register.
- Preserve distinctions among obligation, recommendation, permission, and possibility. Do not flatten `must`, `should`,
  `may`, and `can` into one modal form.
- Prefer an established Turkish domain term when one exists and fits the audience. When usage is divided, use the
  project's choice; otherwise give the clearest Turkish form and retain the English term on first use when useful.
- Do not invent a universal one-word equivalent for a polysemous term. Translate the sense used in the sentence.

## Editing

- Prefer direct verbs over stacked nouns and helper verbs when meaning stays intact. Reduce mechanical uses of
  `gerçekleştirmek`, `sağlamak`, `yapmak`, `bulunmak`, and `-mesi/-ması` chains, but do not ban them.
- Keep subjects and modifiers close enough to avoid ambiguity. Repair English-shaped noun strings and misplaced
  qualifiers.
- Use passive voice when the actor is unknown, irrelevant, or conventionally omitted; otherwise prefer a clear actor.
- Vary sentence length according to content. Do not force every sentence to be short or replace a deliberate cadence
  with uniform plainness.
- Preserve cohesive repetition when it names the same concept. Do not cycle through synonyms merely to avoid repeating
  a technical term.
- Keep Turkish characters and suffixes correct. Follow the document's established quotation and punctuation style
  unless it is erroneous or the user requests a change.

## Context-sensitive terms

These examples prevent common false equivalences; they are not a fixed glossary:

| English | Prefer | Avoid |
|---|---|---|
| `bug` | `hata` in ordinary technical prose | leaving `bug` untranslated without a project reason |
| `bug fix` | `hata düzeltmesi` | `hata giderimi` when the direct form is clearer |
| `verbosity` | `ayrıntı düzeyi` for a setting; `gereksiz ayrıntı` or `laf kalabalığı` for criticism | `sadelik`, which reverses the dimension |
| `deprecated` | `kullanım dışı`, `artık önerilmiyor`, or the project's established term | `kaldırıldı` when the feature still exists |
| `argument` | `sav` or `argüman` in reasoning; `argüman` in a function call or command line | `parametre` when the API distinction matters |

For UI labels, optimize for the action a user can predict, not for literal symmetry with the English label. For academic
or legal prose, retain necessary terms of art and claim strength even when a plainer paraphrase sounds smoother.

## Review output

For a terminology or grammar review, identify the exact phrase, its effect, and the recommended form. Offer multiple
forms only when they represent a real register or meaning choice. Do not bury the preferred answer in a long list of
near-synonyms.
