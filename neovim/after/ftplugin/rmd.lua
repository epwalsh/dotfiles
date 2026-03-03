---@diagnostic disable: inject-field

vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.expandtab = true
vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.list = false
vim.opt_local.omnifunc = ""
vim.opt_local.conceallevel = 2
vim.opt_local.foldmethod = "expr"
vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt_local.foldlevel = 99

-- Start an ipython session
-- vim.keymap.set("n", "<leader>s", ":belowright 10split<cr>:terminal ipython<cr>i", { silent = true, buffer = true })

-- Add useful markdown-specific mappings to vim-surround
-- See: https://github.com/tpope/vim-surround/issues/15#issuecomment-2209423548
--
-- (e)phmasis (bold) with '**'. E.g. with visual selection, type 'Se'.
vim.cmd 'let b:surround_{char2nr("e")} = "**\r**"'
