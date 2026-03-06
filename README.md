# Personal dotfiles

[Alacritty](https://alacritty.org) + [tmux](https://github.com/tmux/tmux/wiki) for my terminal. [fish](https://fishshell.com) for my shell. [Neovim](https://neovim.io) for my editor.

## Cheatsheet

### Tmux

Prefix is `Ctrl+a`.

#### Panes & windows

| Key | Action |
|---|---|
| `Prefix + V` | Vertical split (preserving path) |
| `Prefix + H` | Horizontal split (preserving path) |
| `Prefix + C` | Open Claude in a right vertical split |
| `Prefix + h/j/k/l` | Navigate panes (vim-style) |
| `Option + ←/→/↑/↓` | Resize pane |
| `Prefix + w` | Window picker (via Telescope) |
| `Prefix + s` | Session picker (via Telescope) |
| `Prefix + g` | Open global notes (Obsidian) in a popup |
| `Prefix + r` | Reload config |

#### Copy mode (vi)

| Key | Action |
|---|---|
| `v` | Begin selection |
| `r` | Toggle rectangle selection |
| `y` | Copy selection to system clipboard |
| `Prefix + p` | Paste buffer |

### Fish

#### Navigation

| Command | Description |
|---|---|
| `..` / `...` / `....` / `.....` | `cd` up 1–4 levels |
| `root` | `cd` to git root |
| `l [dir]` | Long listing with icons, git-ignore aware (exa) |
| `tre [dir]` | Tree view with icons (exa) |

#### Editor

| Command | Description |
|---|---|
| `ni [file]` | Alias for `nvim` |
| `fzni` | Pick a file with fzf, open in nvim |
| `today` | Open today's date as a markdown file in nvim |

#### Git

| Command | Description |
|---|---|
| `g` | Alias for `git` |
| `gc "msg"` | `git add -A && git commit -m` |
| `gp` | `git push` |

#### Python / venv

| Command | Description |
|---|---|
| `vf new -p (which python3.12) name` | Create a new virtualenv with the specific Python version |
| `vf connect <path>` | Write a `.venv` file to connect a virtualenv to the current directory |
| `pyclean` | Remove `__pycache__`, `.mypy_cache`, `.pyc`, `.pyo` recursively |

#### Misc

| Command | Description |
|---|---|
| `pct_change <a> <b>` | Print `(a - b) / b` as a percentage |
| `s2 <corpus_id>` | Fetch a Semantic Scholar paper by corpus ID |
| `s2fd <query>` | Find the top Semantic Scholar result for a query |
| `training_time` | Run the training time estimator script |

### Neovim

Leader key is `,`.

#### Motion & editing

| Key | Mode | Action |
|---|---|---|
| `L` | n/v | Jump to end of line |
| `j` / `k` | n/v | Move through wrapped lines |
| `jk` | i | Escape to normal mode |
| `;` | n/v | Enter command mode (`:`) |
| `s` / `S` | n | Leap forward / backward (2-char jump) |
| `∆` / `˚` | n/v | Move line down / up (Option+J / Option+K) |
| `Ctrl+U` / `Ctrl+D` | n | Scroll 10 lines up / down (cursor stays put) |
| `Ctrl+H` | n | Switch to previous buffer |
| `gx` | v | Open selected URL in browser |
| `<C-n>` | n/v | Multi-cursor: select word under cursor |
| `<C-c>` | n/v | Multi-cursor: select char under cursor |

#### Find (Telescope) — `<leader>f`

| Key | Action |
|---|---|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep (n) / grep selection (v) |
| `<leader>fb` | Buffers |
| `<leader>fh` | Help tags |
| `<leader>fc` | Commands |
| `<leader>ft` | TODO comments |
| `<leader>fj` | Fuzzy find in current buffer |
| `<leader>fdg` | Grep in current file's directory |
| `<leader>fdf` | File browser in current file's directory |

Inside a Telescope picker: `<C-j>`/`<C-k>` to move, `<C-q>` to send to quickfix, `<C-h>` for which-key help.

#### Go-to (LSP + Telescope) — `g`

| Key | Action |
|---|---|
| `<CR>` | Go to definition |
| `gde` | Go to definition (edit) |
| `gdv` | Go to definition (vsplit) |
| `gds` | Go to definition (split) |
| `gi` | Go to implementations |
| `gr` | Go to references |
| `K` | LSP hover |
| `<C-k>` | LSP signature help |

#### LSP — `<leader>l`

| Key | Action |
|---|---|
| `<leader>r` | Rename symbol (IncRename) |
| `<leader>ld` | Diagnostics (Telescope) |
| `<leader>ls` | Document symbols |
| `<leader>lt` | Trouble: project diagnostics |
| `<leader>lb` | Trouble: buffer diagnostics |
| `<leader>lr` | Restart LSP servers |
| `<leader>cm` | Open Mason |

#### Navigation panels

| Key | Action |
|---|---|
| `<F2>` | Toggle NvimTree file explorer |
| `<leader>a` | Toggle Aerial symbol outline (float) |
| `<leader>ts` | Tmux session picker |
| `<leader>tw` | Tmux window picker |

#### Buffer options — `<leader>b`

| Key | Action |
|---|---|
| `<leader>bc` | Copy buffer's relative path |
| `<leader>bd` | Open buffer's directory |
| `<leader>bf` | Toggle folding |
| `<leader>bg` | Refresh gitsigns |
| `<leader>bh` | Turn off search highlight |
| `<leader>bp` | Toggle autopairs |
| `<leader>bw` | Toggle line wrap |

#### Obsidian — `<leader>o`

| Key | Mode | Action |
|---|---|---|
| `<leader>oo` | n | Open note in Obsidian app |
| `<leader>oq` | n | Quick switch notes |
| `<leader>os` | n | Search notes |
| `<leader>od` | n | Daily notes picker |
| `<leader>ow` | n | Weekly notes picker |
| `<leader>ob` | n | Backlinks |
| `<leader>ol` | n | Links |
| `<leader>ot` | n | Tags |
| `<leader>oc` | n | Table of contents |
| `<leader>om` | n | Insert template |
| `<leader>on` | n | Open nav note |
| `<leader>or` | n | Rename note |
| `<leader>op` | n | Paste image |
| `<leader>oe` | v | Extract selection into new note |
| `<leader>ol` | v | Link selection to existing note |
| `<leader>on` | v | Link selection to new note |

#### OS / run — `<leader>z`

| Key | Action |
|---|---|
| `<leader>ze` | Execute current file (Python or Bash) |
| `<leader>zc` | Copy current file |
| `!` | `:AsyncRun ` (run shell command, output in terminal) |

#### Misc

| Key | Action |
|---|---|
| `<leader>us` | Switch colour theme |
| `<leader>cx` | Toggle Codex (OpenAI) popup |
| `<leader>pt` | Pomodoro timer picker |
| `<leader>?` | Show buffer-local keymaps (which-key) |
