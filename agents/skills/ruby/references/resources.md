# Ruby Knowledge

Authoritative resources for Ruby development. Use these sources rather than searching broadly.

**Never use these sources:**

- ruby-doc.org
- apidock.com

## Official Documentation

**Primary source:** <https://docs.ruby-lang.org/en/>

- Bundler command reference: <https://bundler.io/man/bundle-update.1.html>

### Other Useful Resources

- <https://rubyreferences.github.io/rubychanges/> - Version-by-version changelog with examples
- <https://railsatscale.com/> - Shopify engineering blog (Latest updates on Ruby and its toolings)

### Core & Standard Library

| Term | Meaning |
| ---- | ------- |
| Default gem | Ships with Ruby, cannot uninstall |
| Bundled gem | Ships with Ruby, can uninstall/replace |
| Standard library | APIs distributed with Ruby; an implementation may be built in, a default gem, or a bundled gem |

| Version | Documentation | Standard Library |
| ------- | ------------- | ---------------- |
| 3.2 | <https://docs.ruby-lang.org/en/3.2/> | <https://docs.ruby-lang.org/en/3.2/standard_library_rdoc.html> |
| 3.3 | <https://docs.ruby-lang.org/en/3.3/> | <https://docs.ruby-lang.org/en/3.3/standard_library_rdoc.html> |
| 3.4 | <https://docs.ruby-lang.org/en/3.4/> | <https://docs.ruby-lang.org/en/3.4/standard_library_md.html> |
| 4.0 | <https://docs.ruby-lang.org/en/4.0/> | <https://docs.ruby-lang.org/en/4.0/standard_library_md.html> |
| master | <https://docs.ruby-lang.org/en/master/> | <https://docs.ruby-lang.org/en/master/standard_library_md.html> |

## Testing Ecosystem

- [Minitest](https://docs.seattlerb.org/minitest/) - Provides testing facilities for TDD, BDD, and benchmarking
- [RSpec](https://rspec.info/documentation/) - Ruby DSL for BDD

## Typing Ecosystem

Two type definition formats exist in Ruby:

- **RBI** - Sorbet's format. Uses Ruby DSL syntax (`sig { ... }`) in `.rb` and `.rbi` files.
- **RBS** - Official Ruby format (Ruby 3.0+). Dedicated syntax in `.rbs` files or inline as comments.

### Sorbet Ecosystem

[Sorbet](https://github.com/sorbet/sorbet) is a static and runtime type checker for Ruby, maintained by Stripe. Key
companion tools:

- [Tapioca](https://github.com/Shopify/tapioca) - Generates RBI files for gems and DSLs (Rails, ActiveRecord, etc.)
- [Spoom](https://github.com/Shopify/spoom) - Coverage analysis, strictness bumping, dead code detection, signature migration

### RBS Ecosystem

- [rbs](https://github.com/ruby/rbs) - Official CLI for working with RBS files (prototype, list, methods)
- [Steep](https://github.com/soutaro/steep) - Type checker that uses RBS

### RBS Comments in Sorbet

Sorbet's RBS-style `#:` comments are experimental, require `--enable-experimental-rbs-comments`, lack runtime checking,
and are discouraged for production dependence by the Sorbet project. Preserve the repository's established RBI or
`sig` system by default; use RBS comments only for an explicitly experimental codebase that accepts those constraints.

Docs: <https://sorbet.org/docs/rbs-support>
