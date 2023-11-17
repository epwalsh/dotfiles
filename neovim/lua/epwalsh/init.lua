local module_lookups = {
  util = "epwalsh.util",
  log = "epwalsh.log",
  img_paste = "epwalsh.img_paste",
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
