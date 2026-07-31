# Code Smells

Use these as hypotheses during reviews, never as automatic violations. Repository rules and concrete contracts win.
Skip patterns already enforced by tooling, and report a smell only with local evidence and a maintainability consequence.
Choose the remedy that simplifies the actual design; do not introduce an abstraction merely to silence a label.

- **Mysterious Name** — A name does not reveal what a value, function, or type represents. Rename it; if no honest name
  fits, clarify the underlying design.
- **Duplicated Code** — The same logic shape appears in several reviewed paths. Reuse the canonical implementation or
  extract the smallest shared shape.
- **Feature Envy** — Logic depends more on another object's data than on its own. Consider moving the behavior closer
  to the data it interprets.
- **Data Clumps** — The same related values repeatedly travel together. Group them only when they form a real domain
  concept or invariant.
- **Primitive Obsession** — A primitive carries domain rules that callers must repeatedly remember. Introduce a domain
  type only when it centralizes real behavior or validation.
- **Repeated Switches** — Several paths branch on the same discriminator. Centralize the decision in the simplest
  canonical model, table, or dispatcher that fits the codebase.
- **Shotgun Surgery** — One logical change requires scattered edits. Move the changing knowledge toward one owner.
- **Divergent Change** — One file changes for several unrelated reasons. Separate responsibilities when the split
  improves ownership and locality.
- **Speculative Generality** — Parameters, hooks, layers, or abstractions serve no current requirement. Delete or inline
  them until a concrete need exists.
- **Message Chains** — A caller navigates a long internal object chain. Put the required operation behind the nearest
  stable interface when that reduces coupling.
- **Middle Man** — A layer mostly delegates without hiding complexity or enforcing a contract. Remove it and call the
  real owner directly.
- **Refused Bequest** — A subtype ignores or overrides most inherited behavior. Replace the inheritance relationship
  with the simplest honest model, often composition or a narrower contract.
