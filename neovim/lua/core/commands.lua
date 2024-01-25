vim.api.nvim_create_user_command("TimerStartWork", "TimerStart 25m Work", { nargs = 0 })

vim.api.nvim_create_user_command("TimerStartStretch", "TimerStart 5m Stretching", { nargs = 0 })

vim.api.nvim_create_user_command("TimerStartBreak", "TimerStart 5m Break", { nargs = 0 })

vim.api.nvim_create_user_command("GcreateBranch", function(data)
  local branch_name = data.args
  vim.cmd("Git checkout -b " .. branch_name)
  vim.cmd("Git push --set-upstream origin " .. branch_name)
end, { nargs = 1 })

vim.api.nvim_create_user_command("Gbranch", function(_)
  vim.cmd "Telescope git_branches"
end, { nargs = 0 })
