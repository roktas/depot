---
name: lang-tex
description: Use when working on TeX, LaTeX, ConTeXt, BibTeX, document build systems, typographic cleanup, TeX package choices, multilingual documents, or publication-quality source edits.
metadata:
  author: https://github.com/roktas
  version: "1.0.0"
---

# TeX Skills

## General

- Follow the conversation language, but keep TeX comments, macros, labels, and file names in English.
- Skip basics unless asked; prefer publication-quality source with simple structure.
- **Engine** - Assume LuaTeX or XeTeX unless specified otherwise.

## Style

- **Indent** - 2 spaces.
- **Comments** - Code should be self-documenting. If you need a comment to explain WHAT the code does, consider
  refactoring to make it clearer. Unacceptable comments:
  - Comments that repeat what code does
  - Commented-out code (delete it)
  - Obvious comments ("increment counter")
  - Comments instead of good naming
  - Comments about updates to old code (e.g. `# now supports xyz`)

## Patterns

- **Modern (LuaTeX/XeTeX)** - Use `fontspec`/`polyglossia` instead of legacy packages.

  ```tex
  \usepackage{fontspec}
  % \setmainfont{FreeSerif}

  \usepackage{polyglossia}
  \setdefaultlanguage{turkish}
  \setotherlanguages{english}
  ```

- **Legacy (pdfLaTeX)** - Use following preamble for legacy TeX engines.

  ```tex
  \usepackage[utf8]{inputenc}
  \usepackage[T1]{fontenc}
  \usepackage[english, turkish]{babel}
  ```
