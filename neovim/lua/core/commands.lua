local log = require "core.log"
local pomo_timer = require "core.pomo_timer"

vim.api.nvim_create_user_command("TimerStart", function(data)
  if data.fargs == nil or #data.fargs == 0 or #data.fargs > 2 then
    return log.error "Invalid arguments.\nUsage: TimeStart TIMELIMIT [NAME]"
  end

  local time_arg = string.lower(data.fargs[1])
  local name = data.fargs[2]

  ---@type number|?
  local time_limit
  if vim.endswith(time_arg, "m") then
    time_limit = tonumber(string.sub(time_arg, 1, -2)) * 60
  elseif vim.endswith(time_arg, "h") then
    time_limit = tonumber(string.sub(time_arg, 1, -2)) * 3600
  elseif vim.endswith(time_arg, "s") then
    time_limit = tonumber(string.sub(time_arg, 1, -2))
  else
    time_limit = tonumber(time_arg)
  end

  if time_limit == nil then
    return log.error("invalid time limit '%s'", time_arg)
  end

  pomo_timer.start_timer(time_limit, name)
end, { nargs = "+" })

vim.api.nvim_create_user_command("TimerStop", function(data)
  pomo_timer.stop_timer(assert(tonumber(data.args)))
end, { nargs = 1 })

vim.api.nvim_create_user_command("TimerStartWork", "TimerStart 25m Work", { nargs = 0 })

vim.api.nvim_create_user_command("TimerStartStretch", "TimerStart 5m Stretching", { nargs = 0 })

vim.api.nvim_create_user_command("TimerStartBreak", "TimerStart 5m Break", { nargs = 0 })
