-- Core neovim settings.
--
-- For filetype-specific settings, see after/ftplugin/*.lua.
-- For plugin-specific settings, see lua/plugin/*.lua.

------------------------
-- Filetype discovery --
------------------------
local group = vim.api.nvim_create_augroup("filetype_detect", { clear = true })
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  group = group,
  pattern = "Dockerfile.*",
  callback = function()
    -- Only set when the 'D' is uppercase.
    if string.sub(vim.api.nvim_buf_get_name(0), 1, 2) ~= "d" then
      vim.opt.filetype = "dockerfile"
    end
  end,
})
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  group = group,
  pattern = { "*.toml", "*.conf" },
  callback = function()
    vim.opt.filetype = "conf"
  end,
})
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  group = group,
  pattern = ".luacheckrc",
  callback = function()
    vim.opt.filetype = "lua"
  end,
})

-------------
-- Globals --
-------------
vim.g.maplocalleader = ","
vim.g.mapleader = ","
vim.g.python3_host_prog = os.getenv "VIRTUAL_ENV" .. "/bin/python"
-- Recommended to disable by nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-------------
-- Options --
-------------
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.hls = true
vim.opt.wrap = false
vim.opt.wildignore:append { "*.pdf", "*.o", "*.egg-info/", "__pycache__", ".mypy_cache" }
vim.opt.mouse = "a"
vim.opt.hidden = true
vim.opt.shell = "sh"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.foldnestmax = 2
vim.opt.expandtab = true
vim.opt.spell = true
vim.opt.colorcolumn = "100"
vim.opt.completeopt = { "longest", "menuone" }
vim.opt.guicursor = "i:ver25"
vim.opt.spelllang = "en_us"
vim.opt.spelloptions = { "camel" }
-- vim.opt.updatetime = 100
-- vim.opt.pastetoggle = "<F3>"
vim.opt.cursorline = true

if vim.api.nvim_win_get_height(0) > 20 then
  vim.opt.scroll = 20
else
  vim.opt.scroll = 0
end

-------------
-- Plugins --
-------------
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  }
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
  change_detection = {
    enabled = true,
    notify = false,
  },
})

--------------
-- Mappings --
--------------
-- Pull up my personal tips help doc.
vim.keymap.set("n", "<leader>hh", ":help personal-tips<cr>")

-- More sensible jump mappings.
vim.keymap.set("v", "L", "$h")
vim.keymap.set("v", "$", "$h")
vim.keymap.set("n", "L", "$")

-- Scroll with mouse one line at a time.
vim.keymap.set("n", "<ScrollWheelUp>", "<c-y>")
vim.keymap.set("n", "<ScrollWheelDown>", "<c-e>")

-- Hop up and down without losing track of where you are.
vim.keymap.set("n", "<C-U>", "10<c-y>")
vim.keymap.set("n", "<C-D>", "10<c-e>")

-- Insert line above/below and stay in normal mode.
vim.keymap.set("n", "<leader>O", "O<esc>")
vim.keymap.set("n", "<leader>o", "o<esc>")

-- Escape insert/visual mode with 'jk'.
vim.keymap.set("i", "jk", "<esc>l")
vim.keymap.set("v", "<leader>jk", "<esc>")

-- Move lines up/down.
vim.keymap.set("n", "∆", ":m .+1<cr>==")
vim.keymap.set("n", "˚", ":m .-2<cr>==")
vim.keymap.set("v", "∆", ":m '>+1<cr>gv=gv")
vim.keymap.set("v", "˚", ":m '<-2<cr>gv=gv")

-- Use ';' for ':'.
vim.keymap.set({ "n", "v" }, ";", ":")

-- Switch to previously edited buffer.
vim.keymap.set("n", "<c-h>", ":b#<cr>")

-- Shortcut for AsyncRun
vim.keymap.set("n", "$", ":AsyncRun ")

-- LSP code navigation shortcuts.
vim.keymap.set("n", "<c-k>", vim.lsp.buf.signature_help)
vim.keymap.set("n", "K", vim.lsp.buf.hover)
vim.keymap.set("n", "gi", vim.lsp.buf.implementation)
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gr", vim.lsp.buf.references)

-- Ignore line wrapping when navigating.
vim.keymap.set({ "n", "v" }, "j", "gj")
vim.keymap.set({ "n", "v" }, "k", "gk")
-- vim.keymap.set({ "n", "v" }, "0", "g0")
-- vim.keymap.set({ "n", "v" }, "$", "g$")

-- Open URLs.
vim.keymap.set({ "v" }, "gx", function()
  -- this is the best way I've found so far for getting the current visual selection
  local a_orig = vim.fn.getreg "a"
  vim.cmd [[silent! normal! "aygv]]
  local url = vim.fn.getreg "a"
  vim.fn.setreg("a", a_orig)

  if string.sub(url, 1, 4) == "http" then
    vim.fn.jobstart { "open", "--background", url }
  else
    vim.notify("Not sure how to open " .. url, vim.log.levels.ERROR)
  end
end)
