-- NOTE: don't try to use which-key for single-key mappings.

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
vim.keymap.set("n", "!", ":AsyncRun ")

-- Ignore line wrapping when navigating.
vim.keymap.set({ "n", "v" }, "j", "gj")
vim.keymap.set({ "n", "v" }, "k", "gk")
-- vim.keymap.set({ "n", "v" }, "0", "g0")
-- vim.keymap.set({ "n", "v" }, "$", "g$")

-- Toggle folding.
vim.keymap.set("n", "<F3>", function()
  vim.opt_local.foldenable = not vim.opt_local.foldenable
end)

-- Open visually-selected links in browser.
vim.keymap.set({ "v" }, "gx", function()
  local log = require "core.log"
  local util = require "core.util"

  local maybe_url = util.get_visual_selection()
  if string.sub(maybe_url, 1, 4) == "http" then
    vim.fn.jobstart { "open", maybe_url }
  else
    log.error("'%s' does not look like a URL", maybe_url)
  end
end)

-- Exit terminal mode like you'd expect.
vim.keymap.set("t", "<C-w>h", "<C-\\><C-n><C-w>h", { silent = true })
vim.keymap.set("t", "<C-w>l", "<C-\\><C-n><C-w>l", { silent = true })
vim.keymap.set("t", "<C-w>j", "<C-\\><C-n><C-w>j", { silent = true })
vim.keymap.set("t", "<C-w>k", "<C-\\><C-n><C-w>k", { silent = true })
vim.keymap.set("t", "<esc>", "<C-\\><C-n>", { silent = true })
