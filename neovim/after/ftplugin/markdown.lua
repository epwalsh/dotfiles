---@diagnostic disable: inject-field

vim.g.markdown_fenced_languages = { "html", "python", "bash=sh", "rust" }
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
-- vim.opt_local.foldtext = "v:lua.markdown_fold_text()"

-- function _G.markdown_fold_text()
--   local line = vim.fn.getline(vim.v.foldstart)
--   local line_count = vim.v.foldend - vim.v.foldstart + 1
--   return " ﹀ " .. line
-- end

-- Start an ipython session
vim.keymap.set("n", "<leader>s", ":belowright 10split<cr>:terminal ipython<cr>i", { silent = true, buffer = true })
