---
name: ruby
description: >-
  Use when working on Ruby source, gems, Ruby-facing Rails code, Minitest or RSpec tests, Ruby packaging, Ruby style
  review, Ruby typing with RBI/RBS, modern Ruby syntax choices, or Ruby public API documentation with YARD.
---

# Ruby

## References

Load detailed guidance based on context:

| Topic | Reference | Load When |
|-------|-----------|-----------|
| Resources | `references/resources.md` | Up-to-date Ruby resources, mostly documentation |
| YARD | `references/yard.md` | Writing or reviewing Ruby public API documentation |

## General

- Resolve the supported Ruby range from `.ruby-version`, version-manager files, `required_ruby_version`, CI, lockfiles,
  and repository instructions before choosing syntax or APIs. The installed interpreter is evidence about the current
  machine, not the project's compatibility floor.
- When no version evidence exists, use clear broadly supported syntax and state a version assumption only when it affects
  the design. Do not silently upgrade syntax across unrelated code.

## Design

- Use the number of classes the problem domain requires to give each real concept, invariant, and behavior a coherent
  home. Do not over-engineer with speculative abstractions, but do not avoid classes so aggressively that an anemic
  model pushes domain behavior into procedural services, hashes, or conditionals.
- For simple record-like values, use `Data.define` when the supported Ruby range permits immutable member semantics, and
  use `Struct.new` when mutation is part of the contract. Do not write a bespoke class solely to hold fields; use one
  when validation, invariants, behavior, inheritance, or a stable public API justifies it.
- Reduce an owning class's internal complexity with cohesive nested helper modules or classes when useful. Keep these
  helpers inside the owning namespace, mark their constants with `private_constant`, and do not expose them through
  public signatures unless they are intentionally part of the API.

## Bundler

- Use `bundle update --all` when intentionally updating every dependency; do not rely on argumentless `bundle update`,
  because current Bundler configurations can require the explicit flag. Pass gem names for targeted updates. Inspect the
  lockfile diff and run relevant tests after either form.

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

- **Formatting** - Use the formatter already configured by the repository, whether `rubyfmt`, RuboCop, Syntax Tree, or
  another tool. When none is configured, follow surrounding style and do not introduce a formatter as an incidental
  change. Do not hand-align code against formatter output.
- **Methods** - Use `def foo = ...` syntax for simple expression methods when it improves clarity.
- **Order**
  1. `include`/`extend`
  2. Constants (Alpha)
  3. `attr_*` (Alpha)
  4. `initialize`
  5. `public` methods (Alpha)
  6. `private` methods (Alpha)

- **Alphabetize** arrays, dicts, assignments, and methods if order is irrelevant.
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

- Follow the repository's selected test framework and helper. Do not translate between Minitest and RSpec merely to
  apply this skill.
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
- Do not leave placeholder tests, unexplained skips, commented-out assertions, or commented-out test bodies. Specify
  the behavior now or remove the placeholder.
