---
name: tex
description: Use when working on TeX, LaTeX, ConTeXt, BibTeX, document build systems, typographic cleanup, TeX package choices, multilingual documents, or publication-quality source edits.
metadata:
  author: https://github.com/roktas
  version: "1.0.0"
---

# TeX

## General

- Follow the conversation language, but keep TeX comments, macros, labels, and file names in English.
- Skip basics unless asked; prefer publication-quality source with simple structure.
- Inspect `latexmkrc`, build scripts, CI, document class, engine directives, package set, bibliography backend, and
  existing generated-file policy before editing. Preserve the established engine and toolchain unless the task requires
  a migration.
- Prefer short contextual file names. Do not include backend or implementation details in names unless they
  disambiguate real siblings or are part of an established interface.
- For a new Unicode document with no project constraints, prefer LuaLaTeX when it is available. State the choice and do
  not assume the current machine's engine exists in the user's publication environment.

## Workflow

1. Identify authoritative source files and distinguish them from generated `.aux`, `.bbl`, `.toc`, PDF, and other
   build artifacts.
2. Preserve document-class and publisher constraints; do not replace a template or package stack incidentally.
3. Make the smallest source change, then run the project's configured build until references and bibliography settle.
4. Inspect warnings relevant to the change, the rendered pages affected, and the Git diff. Do not silence warnings
   globally to hide a local defect.

## Style

- **Indent** - 2 spaces.
- **Comments** - Code should be self-documenting. If you need a comment to explain WHAT the code does, consider
  refactoring to make it clearer. Unacceptable comments:
  - Comments that repeat what code does
  - Commented-out code (delete it)
  - Obvious comments ("increment counter")
  - Comments instead of good naming
  - Comments about updates to old code (e.g. `% now supports xyz`)

## Patterns

- **Modern Unicode engines** - Use `fontspec` for system fonts. Keep the project's existing `babel` or `polyglossia`
  language system; both support modern engines, and changing between them is a migration rather than cleanup.

  For a project that already uses `polyglossia`:

  ```tex
  \usepackage{fontspec}

  \usepackage{polyglossia}
  \setdefaultlanguage{turkish}
  \setotherlanguages{english}
  ```

- **pdfLaTeX** - Use compatible font encoding and language packages when the project targets pdfLaTeX. Add `inputenc`
  only when the supported LaTeX distribution still requires it; modern LaTeX kernels default to UTF-8.

  ```tex
  \usepackage[T1]{fontenc}
  \usepackage[english, turkish]{babel}
  ```
