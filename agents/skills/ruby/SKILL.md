---
name: ruby
description: >-
  Use when working on Ruby code, gems, Rails-adjacent projects, Minitest or RSpec tests, Ruby packaging, Ruby style
  review, Ruby typing with RBI/RBS, modern Ruby syntax choices, or public API documentation with YARD.
---

# Ruby

## References

Load detailed guidance based on context:

| Topic | Reference | Load When |
|-------|-----------|-----------|
| Resources | `references/resources.md` | Up-to-date Ruby resources, mostly documentation |
| YARD | `references/yard.md` | Writing or reviewing Ruby public API documentation |

## General

- Follow the conversation language, but keep code comments, variables, and file names in English.
- Skip basics unless asked; prefer simple Ruby over clever Ruby.
- Prefer short contextual file and command names. Do not include backend or implementation details in names unless they
  disambiguate real siblings or are part of an established interface.
- **Ruby Version** - **Always** use modern Ruby syntax/version if Ruby version is unspecified. **Do not** write code in legacy syntax.

## Bundler

- Use `bundle update --all` when intentionally updating every dependency; argumentless `bundle update` is deprecated
  in Bundler 4. Pass gem names for targeted updates.

## Loading

- Preserve gem entrypoint boundaries. Keep `bin/foo` thin: load the established executable implementation with
  `require "foo/binaries/foo"` or `require "foo/cli"`, then invoke it. Do not reach into `lib` with `require_relative`.
  Let the installed gem, Bundler, or the test harness provide the load path unless the repository explicitly promises
  bare checkout execution.
- For bare checkout execution, allow `bin/foo` to prepend only its adjacent `lib/` directory to `$LOAD_PATH` when
  absent, then keep the normal `require`. Treat this as a narrow package-discovery bootstrap; do not use it to assemble
  library internals or search arbitrary paths.
- In an executable implementation, load the public library entrypoint with `require "foo"` and then any
  executable-only features. Do not load executable implementations from `lib/foo.rb`.
- Make each public library or component entrypoint own its internal file tree with `require_relative`. Use normal
  `require` for external gems and independently loadable component entrypoints.
- Keep standard-library requires near the files that use them unless the repository consistently centralizes them.
  Keep leaf files free of sibling requires when their owning entrypoint already establishes the load order.
- Before changing gem loading, inspect the repository's existing library entrypoints, executable implementations, and
  package tests. Validate every promised mode: bare checkout execution without Bundler or `RUBYLIB`, explicitly
  configured source execution when applicable, and installed-gem execution.

## Style

- **Formatting** - Use `rubyfmt` as the formatting source of truth. Do not hand-align code or fight formatter output.
- **Methods** - Use `def foo = ...` syntax for simple expression methods when it improves clarity.
- **Order**
  1. `include`/`extend`
  2. Constants (Alpha)
  3. `attr_*` (Alpha)
  4. `initialize`
  5. `public` methods (Alpha)
  6. `private` methods (Alpha)

- **Alphabetize** arrays, dicts, assignments, and methods if order is irrelevant.
- **Comments** - Code should be self-documenting. If you need a comment to explain WHAT the code does, consider
  refactoring to make it clearer. Unacceptable comments:
  - Comments that repeat what code does
  - Commented-out code (delete it)
  - Obvious comments ("increment counter")
  - Comments instead of good naming
  - Comments about updates to old code (e.g. `# now supports xyz`)
- **Autocorrection** - Treat broad RuboCop autocorrection, especially `rubocop -A`, as unsafe until reviewed. Inspect
  the diff before committing autocorrected Ruby.
- **Lint and APIs** - Do not rename public keywords, abstract method parameters, or CLI interface parameters only to
  satisfy lint; those names can be API contracts.

## Visibility

- For a cohesive run of private singleton helpers defined in one lexical scope, define the group under
  `class << self` after `private` instead of maintaining a trailing `private_class_method` name list.
- Keep `private_class_method` for isolated methods and constructors, inherited or generated methods, and cases where
  visibility is intentionally changed after definition.

## Minitest

- Use the narrowest command that covers a change, then broaden when touched code is shared.
- Before changing behavior, add or verify characterization coverage for the current contract. Do not start a major
  refactor until the relevant behavior has enough coverage. Test-helper and snapshot-policy changes are normal
  exceptions to the tests-first rule.
- Mirror the runtime file path under `test`, and put the test class in the same namespace as the code under test.
- Name test methods as compact behavior contracts. Optimize for failure output: the name should identify which contract
  failed without opening the file, while relying on file, class, and namespace context instead of restating everything.
- Prefer `test_<subject>_<behavior>` when the subject helps group output. Use stable domain or method words for related
  tests, and behavior verbs such as `returns`, `raises`, `rejects`, `extracts`, `preserves`, `caches`, `exposes`, and
  `allows`.
- Name the observable result, not merely the setup. Avoid bare labels such as `simple`, `basics`, `usual`, `default`,
  `empty`, `valid`, `invalid`, `with_*`, or `without_*` unless the complete name still states the contract.
- Use `with_*` or `without_*` only for a meaningful variant of a behavior already named by the rest of the method.
- Use punctuation suffixes only when they are part of the public API under test, such as bang methods or predicates.
- Keep the complete method name, including `test_`, at 60 characters or less. Do not enforce a numeric minimum; short
  names are fine when they still state a behavior in context.
- Do not make every assertion in a table appear in the method name, and do not split a coherent table-driven test into
  tiny methods merely to name every case. Prefer a focused table using `each_slice(2)` for expected/actual pairs when
  the cases exercise the same behavior.
- When renaming a test, keep its body and placement unchanged unless they violate a separate rule.
- Do not add migration-style absence tests for removed, unused, or never-working APIs unless absence is an active
  contract such as sandboxing, namespace-pollution prevention, or invalid-input rejection. Remove dead APIs and retain
  positive tests for supported behavior.
- Do not leave placeholder tests, unexplained skips, commented-out assertions, or commented-out test bodies. Specify
  the behavior now or remove the placeholder.
