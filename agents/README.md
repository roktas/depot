---
all:
  packages:
    - cask:codex
    - opencode
    - aicommits
  links:
    skills/: ~/.agents/skills
---

# Agents

Installation instructions and shared assets for agents.

## Setup

### Codex

Make Enter insert a newline in the editor and submit with Ctrl/Alt+Enter or Ctrl+M.

```toml
[tui.keymap.composer]
submit = ["ctrl-enter", "alt-enter", "ctrl-m"]

[tui.keymap.editor]
insert_newline = ["enter"]
```

### OpenCode

Make Return insert a newline in the input and submit with Ctrl/Alt/Super+Return.

```json
{
  "$schema": "https://opencode.ai/tui.json",
  "keybinds": {
    "input_newline": "return",
    "input_submit": "ctrl+return,alt+return,super+return"
  }
}
```

### Antigravity

Make Enter insert a newline and submit with Ctrl/Alt/Cmd+Enter.

```json
[
  {
    "command": "-input.submit",
    "key": "enter"
  },
  {
    "command": "input.newline",
    "key": "enter"
  },

  {
    "command": "-input.newline",
    "key": "ctrl+enter"
  },
  {
    "command": "-input.newline",
    "key": "alt+enter"
  },
  {
    "command": "-input.newline",
    "key": "cmd+enter"
  },

  {
    "command": "input.submit",
    "key": "ctrl+enter"
  },
  {
    "command": "input.submit",
    "key": "alt+enter"
  },
  {
    "command": "input.submit",
    "key": "cmd+enter"
  }
]
```

Apply these bindings to the user-level configuration files.

```bash
ruby <<'RUBY'
require "fileutils"
require "json"

home = ENV.fetch("HOME")

codex_config = File.join(home, ".codex", "config.toml")
codex_block = <<~TOML.strip
  # BEGIN depot agent keybindings
  [tui.keymap.composer]
  submit = ["ctrl-enter", "alt-enter", "ctrl-m"]

  [tui.keymap.editor]
  insert_newline = ["enter"]
  # END depot agent keybindings
TOML

FileUtils.mkdir_p(File.dirname(codex_config))
codex_text = File.exist?(codex_config) ? File.read(codex_config) : ""
codex_text = codex_text.gsub(/\n?# BEGIN depot agent keybindings\n.*?\n# END depot agent keybindings\n?/m, "\n")
codex_text = codex_text.rstrip
codex_text = [codex_text, codex_block].reject(&:empty?).join("\n\n") + "\n"
File.write(codex_config, codex_text)

opencode_config = File.join(home, ".config", "opencode", "tui.json")
FileUtils.mkdir_p(File.dirname(opencode_config))
opencode_data = if File.exist?(opencode_config)
  JSON.parse(File.read(opencode_config))
else
  {}
end
opencode_data["$schema"] = "https://opencode.ai/tui.json"
opencode_data["keybinds"] ||= {}
opencode_data["keybinds"]["input_newline"] = "return"
opencode_data["keybinds"]["input_submit"] = "ctrl+return,alt+return,super+return"
File.write(opencode_config, JSON.pretty_generate(opencode_data) + "\n")

antigravity_config = File.join(home, ".config", "Antigravity", "User", "keybindings.json")
FileUtils.mkdir_p(File.dirname(antigravity_config))
antigravity_data = if File.exist?(antigravity_config)
  JSON.parse(File.read(antigravity_config))
else
  []
end
managed_keys = %w[enter ctrl+enter alt+enter cmd+enter]
managed_commands = %w[-input.submit input.newline -input.newline input.submit]
antigravity_data = antigravity_data.reject do |binding|
  managed_keys.include?(binding["key"]) && managed_commands.include?(binding["command"])
end
antigravity_data.concat(
  [
    { "command" => "-input.submit", "key" => "enter" },
    { "command" => "input.newline", "key" => "enter" },
    { "command" => "-input.newline", "key" => "ctrl+enter" },
    { "command" => "-input.newline", "key" => "alt+enter" },
    { "command" => "-input.newline", "key" => "cmd+enter" },
    { "command" => "input.submit", "key" => "ctrl+enter" },
    { "command" => "input.submit", "key" => "alt+enter" },
    { "command" => "input.submit", "key" => "cmd+enter" }
  ]
)
File.write(antigravity_config, JSON.pretty_generate(antigravity_data) + "\n")
RUBY
```
