---
all:
  level: extra
  packages:
    - cask:visual-studio-code
  links:
    settings.json: ~/.config/Code/User/settings.json
---

# Visual Studio Code

## Postinstall

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
