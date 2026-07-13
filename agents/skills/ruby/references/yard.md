# YARD

Load this reference when writing or reviewing Ruby public API documentation.

## Contract

- Document every public class, module, and method. Describe semantics and observable behavior, not implementation.
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

1. Identify new or changed public surfaces after implementation and update their YARD blocks.
2. Add an explicit YARD subtask after implementation work in task lists that change public Ruby APIs.
3. Run `yard stats --list-undoc` to find undocumented surfaces, then run `yard doc` to verify generation.
