-- Core neovim settings.
--
-- For filetype-specific settings, see ftplugin/* and after/ftplugin/*
-- For plugin-specific settings, see after/plugin/*

---------------
-- Auto cmds --
---------------
-- Ensure the right filetype is set for these special cases.
local group = vim.api.nvim_create_augroup("filetype_detect", { clear = true })
vim.api.nvim_create_autocmd({ "BufRead" }, {
	group = group,
	pattern = "Dockerfile.*",
	callback = function()
		vim.opt.filetype = "dockerkfile"
	end,
})
vim.api.nvim_create_autocmd({ "BufRead" }, {
	group = group,
	pattern = "*.toml",
	callback = function()
		vim.opt.filetype = "conf"
	end,
})
vim.api.nvim_create_autocmd({ "BufRead" }, {
	group = group,
	pattern = "*.conf",
	callback = function()
		vim.opt.filetype = "conf"
	end,
})
vim.api.nvim_create_autocmd({ "BufRead" }, {
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
vim.g.python3_host_prog = os.getenv("VIRTUAL_ENV") .. "/bin/python"

-------------
-- Options --
-------------
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.hls = true
vim.opt.wrap = false
vim.opt.wildignore:append({ "*.pdf", "*.o", "*.egg-info/", "__pycache__", ".mypy_cache" })
vim.opt.mouse = "a"
vim.opt.hidden = true
vim.opt.shell = "sh"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.completeopt = { "longest", "menuone" }
vim.opt.guicursor = "i:ver25"
vim.opt.spelllang = "en_us"
vim.opt.spelloptions = { "camel" }
vim.opt.updatetime = 100
vim.opt.pastetoggle = "<F3>"
vim.opt.cursorline = true

if vim.api.nvim_win_get_height(0) > 20 then
	vim.opt.scroll = 20
else
	vim.opt.scroll = 0
end

-------------
-- Plugins --
-------------
-- TODO: switch to a Lua-based plugin manager like lazy.nvim
vim.cmd("source ~/.config/nvim/plugins.vim")

----------------
-- Appearance --
----------------
vim.opt.background = "dark"
vim.g.material_style = "oceanic"

require("lualine").setup({
	options = {
		theme = "horizon",
		-- theme = "auto", -- let 'material' set it
		-- theme = "nightfly",
		-- theme = "palenight",
	},
})

require("material").setup({
	lualine_style = "default",
})

vim.cmd("colorscheme material")
vim.cmd("highlight CursorLine ctermbg=236")
vim.cmd("highlight CursorLineNr cterm=None")
vim.cmd("highlight ColorColumn ctermbg=236")

--------------
-- Mappings --
--------------
vim.cmd("source ~/.config/nvim/plugins.vim")

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

-- LSP code navigation shortcuts.
vim.keymap.set("n", "<c-k>", vim.lsp.buf.signature_help)
vim.keymap.set("n", "K", vim.lsp.buf.hover)
vim.keymap.set("n", "gi", vim.lsp.buf.implementation)
vim.keymap.set("n", "gd", vim.lsp.buf.type_definition)
vim.keymap.set("n", "gr", vim.lsp.buf.references)

-- Ignore line wrapping when navigating.
vim.keymap.set({ "n", "v" }, "j", "gj")
vim.keymap.set({ "n", "v" }, "k", "gk")
vim.keymap.set({ "n", "v" }, "0", "g0")
vim.keymap.set({ "n", "v" }, "$", "g$")
