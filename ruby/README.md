---
all:
  level: minimal
  packages:
    - ruby
    - gem:rubocop
    - gem:rubocop-md
    - gem:rubocop-packaging
    - gem:rubocop-rails-omakase
    - gem:rubocop-rake
  links:
    irbrc: ~/.config/irb/irbrc
    gemrc: ~/.config/gem/gemrc
    rubocop.yml: ~/.config/rubocop/config.yml
---

# Ruby

Minimal Ruby setup with IRB and RuboCop user configuration.
