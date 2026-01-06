-- local group = vim.api.nvim_create_augroup("epwalsh_core", { clear = true })

-- vim.api.nvim_create_autocmd({ "BufWritePost" }, {
--   group = group,
--   pattern = "*",
--   callback = function()
--     vim.cmd "Gitsigns refresh"
--   end,
-- })

local group = vim.api.nvim_create_augroup("core_python", { clear = true })

vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  group = group,
  pattern = "*.py",
  desc = "Apply code folds after reading Python file into buffer (https://stackoverflow.com/a/79716151)",
  callback = function()
    vim.schedule(function()
      vim.cmd "normal! zx"
    end)
  end,
})

-- vim.cmd [[
-- augroup folds
-- " Don't screw up folds when inserting text that might affect them, until
-- " leaving insert mode. Foldmethod is local to the window. Protect against
-- " screwing up folding when switching between windows.
-- autocmd InsertEnter * if !exists('w:last_fdm') | let w:last_fdm=&foldmethod | setlocal foldmethod=manual | endif
-- autocmd InsertLeave,WinLeave * if exists('w:last_fdm') | let &l:foldmethod=w:last_fdm | unlet w:last_fdm | endif
-- augroup END
-- ]]
