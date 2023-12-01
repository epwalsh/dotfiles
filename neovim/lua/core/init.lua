local module_lookups = {
  util = "core.util",
  log = "core.log",
  img_paste = "core.img_paste",
}

local M = setmetatable({}, {
  __index = function(t, k)
    local require_path = module_lookups[k]
    if not require_path then
      return
    end

    local mod = require(require_path)
    t[k] = mod

    return mod
  end,
})

return M
