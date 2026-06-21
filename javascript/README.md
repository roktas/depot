---
all:
  packages:
    - bun
    - node
    - npm:@biomejs/biome
  links:
    environment.d/bun.conf: ~/.config/environment.d/bun.conf
    bunfig.toml: ~/.config/.bunfig.toml
    npmrc: ~/.npmrc
    eslintrc: ~/.eslintrc
    biome.json: ~/.config/biome/biome.json
    bin/: ~/.local/bin
---

# JavaScript

JavaScript runtime and formatter configuration, including Bun, Node, npm, ESLint config, and Biome.
