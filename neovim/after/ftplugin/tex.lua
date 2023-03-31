vim.cmd "let b:autopairs_enabled=0"
vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.expandtab = true
vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.list = false

local group = vim.api.nvim_create_augroup("tex_settings", { clear = true })
vim.api.nvim_create_autocmd({ "BufNewFile" }, {
  group = group,
  pattern = "*.tex",
  command = "0r ~/.config/nvim/headers/template.tex",
})
