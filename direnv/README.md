---
all:
  level: minimal
  packages:
    - direnv
  links:
    direnvrc: ~/.config/direnv/direnvrc
    direnv.toml: ~/.config/direnv/direnv.toml
---

# Direnv

Minimal Direnv setup for project-local environment loading.

Projects opt into Homebrew librsvg paths with `use librsvg`. Projects that publish gems opt into the private
RubyGems credential with `use rubygems`.
