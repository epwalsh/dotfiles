---
name: dotfiles-config
description: Answer questions about Pete's personal dotfiles and configuration. Use when the user asks about their specific tmux, fish, or neovim setup — e.g. "what's my keybinding for X", "how is my fish shell configured", "what neovim plugins do I have", "how does my tmux prefix work". Do NOT use for general tmux/fish/neovim questions unrelated to this specific config.
---

# Dotfiles Config

This skill answers questions about the personal dotfiles at `~/dotfiles` (also the current working directory in this repo).

## Config file locations

| Tool | Key files |
|---|---|
| tmux | `tmux/.tmux.conf` |
| fish | `fish/config.fish`, `fish/functions/`, `fish/conf.d/` |
| neovim | `neovim/init.lua`, `neovim/lua/core/mappings.lua`, `neovim/lua/core/opts.lua`, `neovim/lua/plugins/` |
| alacritty | `alacritty/alacritty.toml` |
| starship | `starship/starship.toml` |

## Instructions

1. Read the relevant config file(s) for the tool being asked about.
2. Answer based on what is actually in the config — do not guess or use general knowledge about defaults.
3. When answering about keybindings or commands, quote the exact binding/alias from the file.
4. If a question spans multiple tools (e.g. tmux + fish), read both.
5. The README.md at the repo root has a cheatsheet summarising key bindings — consult it for a quick overview before diving into raw config files.
