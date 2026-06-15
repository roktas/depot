---
all:
  level: extra
  links:
    settings.json: ~/.config/Code/User/settings.json
macos:
  packages:
    - cask:visual-studio-code
---

# Visual Studio Code

Extra Visual Studio Code module with user settings and extension installation.

## Post Install

```bash
if command -v code &>/dev/null; then
	code --force --install-extension GitHub.codespaces
	code --force --install-extension GitHub.github-vscode-theme
	code --force --install-extension adpyke.codesnap
	code --force --install-extension arcticicestudio.nord-visual-studio-code
	code --force --install-extension chrislajoie.vscode-modelines
	code --force --install-extension ms-vscode-remote.vscode-remote-extensionpack
fi
```
