local util = require "core.util"

local M = {}

M._timers = {}

---@param time_left number
---@return string
local function format_time(time_left)
  if time_left <= 60 then
    return string.format("%ds", time_left)
  elseif time_left <= 300 then
    if math.fmod(time_left, 60) == 0 then
      return os.date("%Mm", time_left) ---@diagnostic disable-line: return-type-mismatch
    else
      return os.date("%Mm %Ss", time_left) ---@diagnostic disable-line: return-type-mismatch
    end
  elseif time_left < 3600 then
    return os.date("%Mm", time_left) ---@diagnostic disable-line: return-type-mismatch
  else
    if math.fmod(time_left, 3600) == 0 then
      return os.date("%Hh", time_left) ---@diagnostic disable-line: return-type-mismatch
    else
      return os.date("%Hh %Mm", time_left) ---@diagnostic disable-line: return-type-mismatch
    end
  end
end

---@class Notifier
---@field timer_id integer
---@field time_limit integer
---@field name string|?
---@field notification any
local Notifier = {}

---@param timer_id integer
---@param time_limit integer
---@param name string|?
---@return Notifier
Notifier.new = function(timer_id, time_limit, name)
  local self = setmetatable({}, { __index = Notifier })
  self.timer_id = timer_id
  self.time_limit = time_limit
  self.name = name
  self.notification = nil
  return self
end

---@param text string
---@param level string|integer
---@param timeout boolean|integer
Notifier.update = function(self, text, level, timeout)
  ---@type string
  local title
  if self.name ~= nil then
    title = string.format("Timer #%d, %s, %s", self.timer_id, self.name, format_time(self.time_limit))
  else
    title = string.format("Timer #%d, %s", self.timer_id, format_time(self.time_limit))
  end
  self.notification = vim.notify(text, level, {
    icon = "󱎫",
    title = title,
    timeout = timeout,
    replace = self.notification,
    hide_from_history = true,
  })
end

---@param time_left number
Notifier.tick = function(self, time_left)
  self:update(string.format(" 󰄉  %s left...", format_time(time_left)), "info", false)
end

Notifier.start = function(self)
  self:update(" 󰄉  Starting...", "info", false)
end

Notifier.done = function(self)
  self:update(" 󰄉  timer done!", "warn", 3000)

  if util.get_os() == util.OS.Darwin then
    os.execute(
      string.format(
        [[osascript -e 'display notification "Timer done!" with title "Timer #%d, %s" sound name "Ping"']],
        self.timer_id,
        format_time(self.time_limit)
      )
    )
  end
end

Notifier.stop = function(self)
  self:update(" 󰄉  timer stopped!", "warn", 1000)
end

---@param time_limit integer seconds
---@param name string|?
---@return integer time_id
M.start_timer = function(time_limit, name)
  local start_time = vim.loop.hrtime()
  local timer = assert(vim.loop.new_timer())
  local timer_id = vim.tbl_count(M._timers) + 1
  local notifier = Notifier.new(timer_id, time_limit, name)

  M._timers[timer_id] = { timer = timer, notifier = notifier }

  notifier:start()

  timer:start(
    1000,
    1000,
    vim.schedule_wrap(function()
      local time_elapsed = (vim.loop.hrtime() - start_time) / 1000000000
      local time_left = time_limit - time_elapsed

      if time_left > 0 then
        notifier:tick(time_left)
      else
        timer:close()
        notifier:done()
        M._timers[timer_id] = nil
      end
    end)
  )

  return timer_id
end

---@param timer_id integer
---@return boolean
M.stop_timer = function(timer_id)
  if M._timers[timer_id] ~= nil then
    M._timers[timer_id].timer:close()
    M._timers[timer_id].notifier:stop()
    M._timers[timer_id] = nil
    return true
  else
    return false
  end
end

return M
