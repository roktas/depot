# YARD

Load this reference when writing or reviewing Ruby public API documentation.

## Contract

- Document every new or changed public class, module, and method in scope. Do not turn a focused change into a
  repository-wide legacy documentation sweep unless the user requests it. Describe semantics and observable behavior,
  not implementation.
- Keep documentation in English unless the user requests otherwise.
- Give classes and modules a concise responsibility summary.
- For each public method, document every applicable part of its contract:
  - `@param name [Type]` for each parameter and `@option` for meaningful hash options.
  - `@return [Type]` with the exact return type and meaning. Use `[void]` when the return value is not part of the API.
    Describe keys or members for structured returns such as hashes.
  - One `@raise [Error]` per exception that callers can observe, with the condition that raises it.
  - `@yield`, `@yieldparam`, and `@yieldreturn` when block behavior is part of the contract.
- Document `self.call` separately from `#call`; do not let one stand in for the other.
- Use `@example` for module-level constructs and whenever usage clarifies semantics. Prefer concise runnable examples.
- Use `@see` for related APIs instead of duplicating their documentation.
- Document private methods only when their behavior is non-obvious.
- Use advanced tags such as `@abstract`, `@deprecated`, `@api private`, and `@overload` only when they express a real
  contract.
- If a contract needs elaborate prose, first check whether avoidable API friction should be fixed in code.

## Workflow

1. Identify new or changed public surfaces before implementation so their contracts inform the design.
2. Update their YARD blocks with the implementation and tests; do not postpone documentation until context is lost.
3. Run the repository's narrowest YARD validation, then `yard stats --list-undoc` or `yard doc` when the project uses
   those whole-project checks. Review newly reported legacy gaps separately from regressions introduced by the change.
