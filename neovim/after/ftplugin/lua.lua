vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.expandtab = true
vim.opt_local.foldmethod = "expr"
vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt_local.foldnestmax = 1

-- Save current view before formatting, restore after.
-- Idea taken from https://github.com/nvim-treesitter/nvim-treesitter/issues/1424#issuecomment-909181939

local group = vim.api.nvim_create_augroup("lua_restore_format", { clear = true })

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = group,
  pattern = "*.py",
  callback = function()
    vim.cmd "mkview"
  end,
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  group = group,
  pattern = "*.py",
  callback = function()
    vim.cmd "edit"
    pcall(vim.cmd.loadview)
  end,
})
