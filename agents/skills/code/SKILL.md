---
name: code
description: >-
  Use when diagnosing, reviewing, designing, modifying, refactoring, testing, building, or validating software and
  engineering artifacts: source code, tests, architecture, APIs, libraries, runtimes, parsers, build and CI systems,
  runtime configuration, schemas and specifications, or desired-state declarations. Orchestrate the relevant
  implementation-language skills such as Bash, C, Ruby, and TeX, plus commit guidance when a commit is in scope. Do not
  use for ordinary repository browsing, git-only operations, prose-only documentation, or file organization when no
  engineering decision is involved.
---

# Code

Own the engineering decisions shared across implementation languages. Let language, repository, domain, and workflow
skills supply their narrower constraints.

## Boundary and authority

- Follow the user's instructions, repository rules, current contracts, and task scope before this skill.
- Apply global instructions cumulatively. Loading this skill does not suspend unrelated rules, and silence here does
  not waive them. Override a broader rule only when a narrower instruction conflicts with it concretely.
- Own problem framing, design, root-cause analysis, change strategy, tests, validation, compatibility, and migration
  decisions that cross language-specific concerns.
- Let each implementation-language skill own its syntax, idiom, safety rules, style, tooling, and language-specific
  test practices.
- Prefer existing repository patterns over new abstractions. Do not replace useful domain structure merely to reduce
  the amount of code.
- Review and diagnosis do not authorize implementation. Change and build requests include the smallest complete
  implementation and proportionate verification.

## Orchestration

`code` is the entry point when engineering work is in scope. Load narrower skills in one direction:

1. Identify every implementation surface before review or editing.
2. Read [bash](../bash/SKILL.md) completely for Bash, POSIX shell, shell automation, CLI wrappers, dotfiles, CI shell,
   or shell snippets; read [c](../c/SKILL.md) completely for C; read [ruby](../ruby/SKILL.md) completely for Ruby; and
   read [tex](../tex/SKILL.md) completely for TeX sources, document build systems, or typographic implementation.
3. Load every applicable implementation-language skill for a mixed-language change. Apply its constraints early
   enough to shape the design and validation, not merely the final formatting pass.
4. When creating, editing, reviewing, or explaining a commit message or commit history, read
   [commits](../commits/SKILL.md) completely. Do not load it merely because a working tree is involved.
5. When `.agents/`, `.local/`, agent artifacts, or project-local ownership and placement are in scope, read
   [local](../local/SKILL.md) completely.
6. Let repository and domain skills retain authority over project-specific architecture, interfaces, facts, tools, and
   validation entrypoints. When substantive prose inside a TeX or code-facing document is also in scope, additionally
   use the `write` and target-natural-language skills when available.

Implementation-language and workflow skills do not invoke or reload `code`. When dispatch loads both, follow this
order rather than creating a cycle.

## Naming Things

Apply the user-wide preflight below in full. This copy is intentional reinforcement; the user-wide `AGENTS.md` remains
canonical. Keep both copies synchronized in the same change. Project- or language-specific rules refine it and override
it only for a concrete conflict.

When creating, renaming, or proposing a file, directory, command, skill, module, class, function, variable, public API,
or concept, apply this mandatory preflight:

1. Prefer one simple, meaningful word when context allows.
2. Do not repeat context supplied by the containing project, directory, module, class, or command.
   For example, in `provision`, prefer `Plan` over `ProvisionPlan`.
3. Before using `-`, `_`, `:`, `/`, camel/Pascal compounds, or multiword names, look for a simpler one-word name.
4. Match sibling names in the same scope: style, length, and specificity.
5. Public names should be short, polished, and memorable. Internal names may be plainer or more explicit.
6. Let name length follow scope: longer globally, shorter locally.
7. Add a qualifier only when it separates real sibling concepts in the current scope; do not add one just to sound more
   precise.
8. Avoid generic modeling words unless they name a real domain role. Name what the thing is for, not the container or
   implementation shape.

Break this preflight only for a concrete reason, and state it briefly.

## Workflow

1. Inspect relevant instructions, files, interfaces, tests, build configuration, and current behavior. Identify the
   user's underlying goal before choosing a change.
2. On resumed Git work, inspect the branch, `HEAD`, and dirty state before editing, then summarize drift from the last
   handoff or visible session context.
3. If ambiguity could materially change the approach, ask before acting. Otherwise state a reasonable assumption and
   proceed within the requested review or edit scope.
4. Trace the affected behavior and contracts. For a defect, locate the root cause in the model, parser, runtime,
   architecture, or instructions rather than bypassing it with sentinel state, dummy state, or a narrow special case.
5. For a broad or architectural change, plan deliberately and add or update tests first. For a bounded change, verify
   or add the smallest useful characterization or regression coverage when practical.
6. Test the new positive contract and the behavior affected by the change. Tests and current-state artifacts must
   describe supported behavior and active invariants. Do not preserve superseded concepts through absence tests,
   rejection fixtures, compatibility scaffolding, or historical wording unless their absence is itself a concrete
   current security or interface contract. Use one-time searches and diff review, not durable tests, to verify that
   superseded concepts are gone.
7. Before encoding external tool behavior in code, configuration, or desired state, verify the required semantics with
   read-only inspection or a dry run in the target environment when available. Do not use the first mutation attempt
   as capability discovery.
8. Choose the simplest implementation that fully meets current requirements and invariants. Prefer an established,
   well-maintained library when it materially reduces complexity or risk and fits project constraints; do not add a
   dependency for trivial code.
9. Make the smallest coherent change. Keep source self-documenting; avoid obvious comments, commented-out code, dead
   code, comments that merely narrate the code or a past edit, temporary files, and unnecessary structure. Treat code
   in chat as repository-quality code.
10. Run the narrowest relevant checks first, then broaden when the changed behavior is shared or risk warrants it.
11. Perform the final review below, then report any validation that could not be run.

## Compatibility and change

- Preserve backward compatibility only for a concrete current contract: a released public API, external consumer,
  persisted user data, deployed state, or explicit repository or task requirement. Without such a contract, do not add
  shims, aliases, fallbacks, dual paths, or legacy formats.
- When a design decision changes, make the new decision canonical across code, tests, documentation, configuration,
  and desired state. Remove superseded concepts so current-state artifacts read as if the old decision had never
  existed.
- Use migrations only to transform real persisted or deployed state. Keep migration and recovery behavior explicit and
  outside steady-state code, documentation, configuration, and desired state. Retain migration artifacts only when the
  project requires durable history.
- In tracked files, use `~` for home-relative paths and repository- or module-relative paths for repository files.
  Never write expanded home paths.

## Review

Treat this sweep as mandatory for every code review and every implementation closeout. Perform it after focused review
and ordinary validation.

1. Re-read the request, active contracts, and each affected file or module as a whole, not only the changed hunks. Check
   structural integrity, control and data flow, terminology, assumptions, interfaces, error behavior, and agreement
   among code, tests, documentation, configuration, specifications, and desired state.
2. Inspect the final diff and bounded adjacent surfaces aggressively for leftovers, stale state, and slop: superseded
   names or concepts, dead or unreachable code, unused imports or dependencies, obsolete branches, stale tests or
   fixtures, outdated documentation or configuration, unjustified compatibility paths, duplicated logic, TODOs or
   placeholders, debug output, generated or temporary files, and accidental formatting or naming churn.
3. Use one-time searches keyed to renamed or removed concepts and inspect the supported path positively. Do not turn
   historical absence into permanent tests unless absence is itself a current security or interface contract.
4. During implementation, fix every in-scope finding introduced by the change, including any issue that must be resolved
   for the affected artifact to remain coherent. In review-only work, report it without editing. Report unrelated
   pre-existing debt separately instead of silently expanding scope.
5. Re-run affected checks after cleanup and confirm that the final artifacts describe one consistent current state.

## Output

- For review or diagnosis, state the supported conclusion, evidence, consequences, and uncertainty; do not edit unless
  requested or clearly authorized.
- For implementation, leave the repository clean of work residue and return the completed change, validation results,
  and any material remaining risk.
- For a design question, provide the smallest decision set needed to choose an approach; do not create an abstraction
  merely to demonstrate one.
