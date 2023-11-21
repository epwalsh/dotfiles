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
