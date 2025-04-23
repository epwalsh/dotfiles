local util = require "core.util"
local log = require "core.log"

---------------------
-- Timer commands. --
---------------------

vim.api.nvim_create_user_command("TimerStartWork", "TimerStart 25m Work", { nargs = 0 })

vim.api.nvim_create_user_command("TimerStartStretch", "TimerStart 5m Stretching", { nargs = 0 })

vim.api.nvim_create_user_command("TimerStartBreak", "TimerStart 5m Break", { nargs = 0 })

-------------------
-- Git commands. --
-------------------

vim.api.nvim_create_user_command("GcreateBranch", function(data)
  local branch_name = data.args
  vim.cmd("Git checkout -b " .. branch_name)
  vim.cmd("Git push --set-upstream origin " .. branch_name)
end, { nargs = 1 })

vim.api.nvim_create_user_command("GdeleteBranch", function()
  local exit_code, current_branch = util.system "git rev-parse --abbrev-ref HEAD"
  if exit_code ~= 0 or current_branch == nil then
    return log.error("Failed to retrieve current branch (exit code '%d')", exit_code)
  end

  ---@type string|?
  local default_branch
  exit_code, default_branch = util.system "git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@'"
  if exit_code ~= 0 or default_branch == nil then
    return log.error("Failed to retrieve default branch (exit code '%d')", exit_code)
  end

  if current_branch == default_branch then
    return log.warn("Your current branch ('%s') is your default branch, doing nothing", current_branch)
  end

  vim.cmd("Git checkout " .. default_branch)

  local upstream_count_str
  exit_code, upstream_count_str = util.system "git remote -v | grep upstream | wc -l"
  if exit_code ~= 0 or upstream_count_str == nil then
    return log.warn("Failed to check for upstream remote (exit code '%d')", exit_code)
  end

  local has_upstream_remote = false
  local upstream_count = tonumber(upstream_count_str)
  if upstream_count and upstream_count > 0 then
    has_upstream_remote = true
  end

  if has_upstream_remote then
    vim.cmd("Git pull --rebase upstream " .. default_branch)
  else
    vim.cmd "Git pull"
  end

  vim.cmd("Git branch -d " .. current_branch)
  vim.cmd "Git remote prune origin"
end, { nargs = 0 })

vim.api.nvim_create_user_command("Gbranch", function(_)
  vim.cmd "Telescope git_branches"
end, { nargs = 0 })

vim.api.nvim_create_user_command("Gcommit", function(data)
  local commit_msg = data.args
  vim.cmd "Git add -A"
  vim.cmd(string.format('Git commit -m "%s"', commit_msg))
  vim.cmd "Git push"
  require("gitsigns").refresh()
end, { nargs = 1 })

------------------------
-- Obsidian commands. --
------------------------

vim.api.nvim_create_user_command("PaperMetadata", function(ev)
  local obsidian = require "obsidian"

  ---@type obsidian.Client
  local client = obsidian.get_client()
  local note = assert(client:current_note())

  ---@type integer|string
  local corpus_id
  if ev.args and string.len(ev.args) > 0 then
    corpus_id = assert(tonumber(ev.args))
  elseif note.metadata and note.metadata.corpus_id then
    corpus_id = note.metadata.corpus_id
  else
    log.error "please provide the semantic scholar corpus ID"
    return
  end

  local data = util.get_paper_metadata(corpus_id)
  util.update_note_with_paper_metadata(note, data)
  if note:save_to_buffer() then
    log.info "Updated paper metadata"
  else
    log.info "Paper metadata already up-to-date"
  end
end, { nargs = "?" })

vim.api.nvim_create_user_command("NewPaper", function(ev)
  local obsidian = require "obsidian"

  ---@type obsidian.Client
  local client = obsidian.get_client()
  local corpus_id = assert(tonumber(ev.args))

  -- Get paper metadata.
  local data = util.get_paper_metadata(corpus_id)
  local note_title = data.title .. " (paper)"

  -- Create new note and add metadata.
  local note = client:create_note { title = note_title, no_write = true }
  util.update_note_with_paper_metadata(note, data)
  client:write_note(note)

  -- Insert link to the note.
  util.insert_text(client:format_link(note, { label = note_title }))
end, { nargs = 1 })

--------------------
-- Tmux commands. --
--------------------

vim.api.nvim_create_user_command("TmuxWindows", "Telescope tmux windows", { nargs = 0 })
vim.api.nvim_create_user_command("TmuxSessions", "Telescope tmux sessions", { nargs = 0 })

vim.api.nvim_create_user_command("TmuxWindowsAndQuit", function()
  vim.o.showtabline = 0
  vim.o.winbar = ""
  vim.o.laststatus = 0
  require("telescope").extensions.tmux.windows {
    quit_on_select = true,
    initial_mode = "normal",
    layout_config = { width = 1000000, height = 100000 },
  }
end, { nargs = 0 })

vim.api.nvim_create_user_command("TmuxSessionsAndQuit", function()
  vim.o.showtabline = 0
  vim.o.winbar = ""
  vim.o.laststatus = 0
  require("telescope").extensions.tmux.sessions {
    quit_on_select = true,
    initial_mode = "normal",
    layout_config = { width = 1000000, height = 100000 },
  }
end, { nargs = 0 })

-----------------------
-- OS util commands. --
-----------------------

vim.api.nvim_create_user_command("OScp", function(data)
  local source_path = vim.api.nvim_buf_get_name(0)

  ---@type string|?
  local target_path
  if data.args and string.len(data.args) > 0 then
    target_path = data.args
  else
    target_path = util.input("Enter target path: ", { default = source_path, completion = "file" })
  end

  if not target_path or string.len(target_path) == 0 then
    log.warn "canceled"
    return
  end

  vim.cmd "w"

  local out = vim.fn.system { "cp", source_path, target_path }
  if out and string.len(out) > 0 then
    log.error(out)
  else
    log.info("Copied '%s' to '%s'", source_path, target_path)
  end

  vim.cmd("e " .. target_path)
end, { nargs = "?", desc = "Copy the current file", complete = "file" })
