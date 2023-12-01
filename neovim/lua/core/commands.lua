vim.api.nvim_create_user_command("TimerStartWork", "TimerStart 25m Work", { nargs = 0 })

vim.api.nvim_create_user_command("TimerStartStretch", "TimerStart 5m Stretching", { nargs = 0 })

vim.api.nvim_create_user_command("TimerStartBreak", "TimerStart 5m Break", { nargs = 0 })
