-- Configure auto formatting using stylua.
--

local format_buffer = require("stylua-nvim").format_file

local group = vim.api.nvim_create_augroup("lua_format", { clear = true })

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = group,
  pattern = "*.lua",
  callback = format_buffer,
})
