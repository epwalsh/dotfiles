---@diagnostic disable: inject-field

vim.g.maplocalleader = ","
vim.g.mapleader = ","
vim.g.python3_host_prog = os.getenv "VIRTUAL_ENV" .. "/bin/python"
-- Recommended to disable by nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

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
vim.opt.spellcapcheck = ""
-- vim.opt.updatetime = 100
-- vim.opt.pastetoggle = "<F3>"
vim.opt.cursorline = true

if vim.api.nvim_win_get_height(0) > 20 then
  vim.opt.scroll = 20
else
  vim.opt.scroll = 0
end

-- vim.cmd [[
-- augroup folds
-- " Don't screw up folds when inserting text that might affect them, until
-- " leaving insert mode. Foldmethod is local to the window. Protect against
-- " screwing up folding when switching between windows.
-- autocmd InsertEnter * if !exists('w:last_fdm') | let w:last_fdm=&foldmethod | setlocal foldmethod=manual | endif
-- autocmd InsertLeave,WinLeave * if exists('w:last_fdm') | let &l:foldmethod=w:last_fdm | unlet w:last_fdm | endif
-- augroup END
-- ]]
