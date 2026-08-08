---
all:
  packages:
    - python
    - pylint
    - uv
    - uv:pyyaml
    - uv:rich
  links:
    pylintrc: ~/.config/pylintrc
---

# Python

Python runtime and user linting setup based on Homebrew Python, uv, Pylint, and PyYAML.
