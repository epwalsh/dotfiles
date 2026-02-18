# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles for macOS: Alacritty + tmux for terminal, Fish for shell, Neovim for editor. Configs are organized into tool-specific directories and symlinked to their target locations manually or via `bootstrap.sh`.

## Symlink Layout

| Directory | Symlinked to |
|---|---|
| `tmux/.tmux*` | `~/` |
| `neovim/*` | `~/.config/nvim/` |
| `fish/*` | `~/.config/fish/` |
| `alacritty/alacritty.toml` | `~/.config/alacritty/` |
| `starship/starship.toml` | `~/.config/starship.toml` |
| `claude/*` | `~/.claude/` |
| `go/.*` | `~/` |
| `global_gitignore` | `~/.gitignore` |

## Global Claude Code configuration (`claude/`)

- **`hooks/`** — Scripts used by custom hooks.
- **`statusline.sh`** — Custom statusline showing model, directory, context window usage (color-coded), cost, and git status.
- `rules/` and `skills/` — for custom rules and skills.

## Neovim (`neovim/`)

Lua-based config using Lazy.nvim. Leader key is `,`. Key architectural files:
- `init.lua` — Entry point, loads core modules and plugins.
- `lua/core/` — A custom Lua module with general settings, keymaps, autocommands, helper functions, etc.
- `lua/plugins/` — Plugin specs loaded by Lazy.nvim.

Lua formatting is enforced by `.stylua.toml` at the repo root: 2-space indent, 120-column width, double quotes.

## Fish Shell (`fish/`)

- `config.fish` — PATH setup, vi keybindings, prompt, etc.
- `functions/` — custom functions for navigation, git helpers, venv management, logging, etc.
- `conf.d/` — Auto-loaded: Python venv auto-activation, `.env` file loading on directory change, etc.

## Tmux (`tmux/.tmux.conf`)

Prefix is `Ctrl+A`. Notable bindings beyond standard:
- `g` — Popup that opens a coding agent (like Claude) in the git root (or current dir).
- `G` — Popup for Obsidian notes navigation.
- `w` / `s` — Session/window picker via Telescope.
- `V` / `H` — Vertical/horizontal splits preserving current path.
- `Ctrl+hjkl` — Pane navigation (vim-style).
