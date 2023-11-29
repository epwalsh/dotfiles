require "core.opts" -- NOTE: need to load core settings before Lazy.nvim

---------------------
-- Lazy.nvim setup --
---------------------

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then ---@diagnostic disable-line: undefined-field
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  }
end

vim.opt.rtp:prepend(lazypath) ---@diagnostic disable-line: undefined-field

require("lazy").setup("plugins", {
  change_detection = {
    enabled = true,
    notify = false,
  },
})

--------------------------------------
-- Load other personal config files --
--------------------------------------

require "core.ft_detect"
require "core.mappings"
require "core.commands"
