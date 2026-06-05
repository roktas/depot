---
all:
  packages:
    - bun
    - node
    - npm:@biomejs/biome
  links:
    bunfig.toml: ~/.config/.bunfig.toml
    npmrc: ~/.npmrc
    eslintrc: ~/.eslintrc
    biome.json: ~/.config/biome/biome.json
    bin/: ~/.local/bin
---

# JavaScript

JavaScript runtime and formatter configuration, including Bun, Node, npm, ESLint config, and Biome.
