---
all:
  level: minimal
  packages:
    - ruby
    - rubyfmt
    - gem:rubocop
    - gem:rubocop-md
    - gem:rubocop-packaging
    - gem:rubocop-rake
    - gem:rubocop-rubyfmt
  links:
    irbrc: ~/.config/irb/irbrc
    gemrc: ~/.config/gem/gemrc
    rubocop.yml: ~/.config/rubocop/config.yml
    rubocop_todo.yml: ~/.config/rubocop/.rubocop_todo.yml
---

# Ruby

Minimal Ruby setup with IRB, formatting, and RuboCop user configuration.
