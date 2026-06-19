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

## Configure

```bash
if ! command -v code >/dev/null; then
	exit 0
fi

extensions=(
	GitHub.codespaces
	GitHub.github-vscode-theme
	adpyke.codesnap
	arcticicestudio.nord-visual-studio-code
	chrislajoie.vscode-modelines
	ms-vscode-remote.vscode-remote-extensionpack
)

mapfile -t installed < <(code --list-extensions)

for extension in "${extensions[@]}"; do
	if printf '%s\n' "${installed[@]}" | grep -Fqx "$extension"; then
		continue
	fi

	code --install-extension "$extension"
done
```
