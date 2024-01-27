local util = require "core.util"
local log = require "core.log"

vim.api.nvim_create_user_command("TimerStartWork", "TimerStart 25m Work", { nargs = 0 })

vim.api.nvim_create_user_command("TimerStartStretch", "TimerStart 5m Stretching", { nargs = 0 })

vim.api.nvim_create_user_command("TimerStartBreak", "TimerStart 5m Break", { nargs = 0 })

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
